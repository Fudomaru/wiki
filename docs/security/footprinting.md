---
title: Footprinting
description: This is the basis of a lot of enumeration, and I want to write it all down.
---


# Footprinting

Stands for recon using scans and third-party providers. 
Mostly active enumeration. And for that, it should be performed separately from OSINT. 


## Enumeration Methodology

Footprinting follows a layered approach — always working **outside-in**:

1. **Infrastructure Enumeration** — Understand the full scope first. What domains, IP ranges, cloud assets, and third-party providers are in play? Sources include public DNS records, WHOIS, ASN lookups, and low-level scans. Goal: map what exists and how systems communicate.

2. **Host Enumeration** — Zoom into individual hosts. What services are running? What ports are open? What is the host capable of? Goal: build a complete picture of one target before moving deeper.

3. **OS Enumeration** — Go as deep as possible into the OS layer. Internal configs, running processes, user privileges, sensitive files, and misconfigured settings. Goal: find what a surface-level scan would miss.

---

## Infrastructure Enumeration

Infrastructure enumeration is **passive** — you stay hidden and act like a visitor. No direct connections to the company. Goal: understand their full internet presence before touching anything.

### Starting Point — The Company Website

Read the main website carefully. What services do they offer? What technologies are implied? An IoT company needs embedded systems. A SaaS company needs APIs and cloud. This gives you a developer's-eye view of what infrastructure must exist even before you scan anything.

### Subdomain Discovery via Certificate Transparency

SSL certificates are logged publicly. `crt.sh` indexes all issued certificates — each one can reveal subdomains.

```bash
# Get all certificates for a domain as JSON
curl -s "https://crt.sh/?q=inlanefreight.com&output=json" | jq .

# Filter for unique subdomains only
curl -s "https://crt.sh/?q=inlanefreight.com&output=json" | jq . | grep name | cut -d":" -f2 | grep -v "CN=" | cut -d'"' -f2 | awk '{gsub(/\\n/,"\n");}1;' | sort -u
```

### Resolve Subdomains to IPs

```bash
# For each subdomain in your list, resolve it and filter company-owned IPs
for i in $(cat subdomainlist); do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f1,4; done

# Build an IP list for Shodan
for i in $(cat subdomainlist); do host $i | grep "has address" | grep inlanefreight.com | cut -d" " -f4 >> ip-addresses.txt; done
```

Watch for IPs resolving to third-party providers (e.g. AWS S3) — you can't test those without their permission.

### Shodan

Feed discovered IPs into Shodan to see open ports and services without touching the target directly.

```bash
for i in $(cat ip-addresses.txt); do shodan host $i; done
```

Shodan returns: city, org, open ports, running services, SSL versions. Useful for quick triage.

### DNS Records — `dig any`

```bash
dig any inlanefreight.com
```

| Record | What it tells you |
|--------|-------------------|
| **A** | IP address for a domain/subdomain |
| **MX** | Mail servers — who handles email |
| **NS** | Name servers — often reveals hosting provider |
| **TXT** | Third-party verifications, SPF, DMARC/DKIM |
| **SOA** | Zone authority info |

### Reading TXT Records for Third-Party Intel

TXT records contain verification strings for external services. Each one tells you what tools the company uses:

| TXT value pattern | What it means |
|-------------------|---------------|
| `atlassian-domain-verification=...` | Uses Jira/Confluence — source code, tickets, wikis |
| `google-site-verification=...` | Google Workspace — potential GDrive access |
| `logmein-verification-code=...` | LogMeIn for remote access management — high-value target |
| `v=spf1 include:mailgun.org ...` | Uses Mailgun API — look for IDOR/SSRF on email endpoints |
| `MS=ms...` | Microsoft/Office365 — potential OneDrive, Azure Blob, SMB |
| `inwx...` | Domain registrar/hosting provider — reveals management platform |

### Cloud Resources

Cloud storage is often misconfigured and publicly accessible. The main targets:
- **AWS** → S3 buckets (`s3-website-<region>.amazonaws.com`)
- **Azure** → Blobs (`blob.core.windows.net`)
- **GCP** → Cloud Storage (`storage.googleapis.com`)

Cloud assets often appear directly in DNS — when resolving subdomains to IPs, watch for addresses pointing to cloud provider domains rather than company-owned IPs. Those are immediate candidates.

**Google Dorks:**
```
intext:<company> inurl:amazonaws.com
intext:<company> inurl:blob.core.windows.net
```

Also check the company's website source code — cloud URLs are often hardcoded for images, JS, CSS assets.

**Useful tools:**
- `domain.glass` — infrastructure overview, also shows Cloudflare protection status (useful for noting gateway-layer defenses)
- `GrayHatWarfare` — search and filter cloud storage by provider and file type

**Why it matters:** Misconfigured buckets/blobs can expose sensitive documents, source code, backups — or in the worst case, leaked SSH private keys that allow direct access to internal machines.

### Staff Enumeration

Employees are a goldmine of infrastructure intel — all publicly available, zero contact with the target.

**Where to look:**
- LinkedIn, Xing — employee profiles, career history, listed skills
- Job postings — companies advertise exactly what stack they run

**What job postings reveal:**
- Programming languages in use (Java, Python, PHP, etc.)
- Databases (MySQL, PostgreSQL, Oracle, MSSQL)
- Frameworks (Django, Flask, Spring, ASP.NET)
- Tools and platforms (Atlassian/Jira/Confluence, Git, Docker, Redis)
- Security posture requirements (certifications, clearances)

**What employee profiles reveal:**
- Current tech focus from recent posts and shared content
- GitHub links → public repos → potential hardcoded secrets, JWT tokens, email addresses, config files
- Framework-specific repos lead to known misconfigurations (e.g. searching "Django OWASP Top10" after finding a Django shop)

**Who to look for:**
- **Developers** → reveal the tech stack
- **Security engineers** → reveal what defenses and tools the company uses

The combination tells you both what to attack and what you'll run into.

---

## Host Enumeration

Active enumeration of individual hosts — direct interaction with the target. Each service gets its own footprinting approach.

### FTP (Port 21)

FTP (File Transfer Protocol) runs at the application layer (same as HTTP, POP). Transfers everything in **cleartext** — credentials and data both visible on the wire.

#### How it works

FTP opens **two channels**:
- **Port 21** — control channel (commands and status codes)
- **Port 20** — data channel (actual file transfers)

**Active mode:** Client tells the server which port to send data to. Fails if a firewall blocks inbound connections on the client side.

**Passive mode:** Server announces an open port, client initiates the data connection. Firewall-friendly — client always initiates.

#### TFTP (Trivial FTP)

Simpler variant — uses **UDP** instead of TCP, no authentication, no directory listing. Only works in local/protected networks. Relevant commands: `connect`, `get`, `put`, `quit`, `status`, `verbose`.

#### Anonymous Login

FTP servers can allow login without real credentials. Often misconfigured on internal servers. Username: `anonymous`, password: empty or any email-looking string.

```bash
ftp <IP>
# Name: anonymous
# Password: (empty or any@email.com)
```

Server responds with `230 Login successful` if enabled.

#### Key FTP Commands

| Command | What it does |
|---------|-------------|
| `ls` | List current directory |
| `ls -R` | Recursive listing — dumps entire directory tree at once |
| `cd <dir>` | Change directory |
| `get <file>` | Download a file |
| `put <file>` | Upload a file |
| `status` | Show connection info and current settings |
| `debug` | Enable debug output |
| `trace` | Enable packet tracing |

`ls -R` is especially useful — maps the full structure in one command. Watch for `ls_recurse_enable=YES` in the server config.

#### Download Everything at Once

```bash
wget -m --no-passive ftp://anonymous:anonymous@<IP>
```

Downloads all accessible files recursively into a local folder named after the IP. Can trigger alerts — no real user downloads everything at once.

#### Upload a File

```bash
ftp> put testupload.txt
```

If uploads are allowed and the FTP root is inside the web server's directory, you can drop a webshell and get RCE. Also exploitable via FTP log poisoning.

#### Config Files (vsFTPd — most common on Linux)

```bash
cat /etc/vsftpd.conf | grep -v "#"   # main config
cat /etc/ftpusers                     # users explicitly denied FTP access
```

**Dangerous settings to look for:**

| Setting | Risk |
|---------|------|
| `anonymous_enable=YES` | Allows anonymous access |
| `anon_upload_enable=YES` | Anonymous users can upload |
| `anon_mkdir_write_enable=YES` | Anonymous users can create directories |
| `no_anon_password=YES` | No password prompt at all |
| `write_enable=YES` | Enables STOR, DELE, MKD, RMD commands |
| `hide_ids=YES` | Hides real UIDs — shows `ftp ftp` instead of real owners |
| `ls_recurse_enable=YES` | Allows `ls -R` — full tree dump |

#### Nmap Enumeration

```bash
sudo nmap -sV -p21 -sC -A <IP>
```

Relevant NSE scripts:

| Script | What it checks |
|--------|----------------|
| `ftp-anon` | Anonymous login + lists root directory |
| `ftp-syst` | Runs STAT — shows server status, version, connection info |
| `ftp-vsftpd-backdoor` | Checks for CVE-2011-2523 (backdoor in vsFTPd 2.3.4) |
| `ftp-brute` | Brute-force credentials |
| `ftp-bounce` | Tests for FTP bounce attack |

Update NSE script database: `sudo nmap --script-updatedb`

Find all FTP scripts locally: `find / -type f -name ftp* 2>/dev/null | grep scripts`

Add `--script-trace` to see the raw network-level exchange between Nmap and the server.

#### Manual Service Interaction

```bash
nc -nv <IP> 21          # raw banner grab
telnet <IP> 21           # same, slightly more interactive
```

If FTP runs over **TLS/SSL**:

```bash
openssl s_client -connect <IP>:21 -starttls ftp
```

The SSL certificate may reveal the hostname, internal domain name, org name, location, and admin email — all useful for further enumeration.

:::info CJCA Exam — FTP Must-Know
**Ports:** 21 (control) / 20 (data)

**Anonymous login:** username `anonymous`, password empty — always try first.

**Active vs Passive:** Passive exists because firewalls block inbound connections to the client. Client always initiates in passive mode.

**Key commands:** `ls -R` (full tree), `get` (download), `put` (upload)

**Nmap scan:**
```bash
sudo nmap -sV -p21 -sC -A <IP>
```
Script `ftp-anon` confirms anonymous login and lists root directory.

**Bulk download:**
```bash
wget -m --no-passive ftp://anonymous:anonymous@<IP>
```

**Attack path:** Anonymous login → `ls -R` → `get` files → if upload works + FTP root in webroot → drop shell → RCE

**Config red flags:** `anonymous_enable=YES`, `write_enable=YES`, `hide_ids=YES`
:::

---

### SMB (Ports 139 / 445)

SMB (Server Message Block) is a client-server protocol for sharing files, directories, printers, and other network resources. Originally Windows-only — **Samba** brings it to Linux/Unix and enables cross-platform communication.

**Ports:**
- **139/tcp** — SMB over NetBIOS (legacy)
- **445/tcp** — SMB over TCP directly (modern, preferred)

#### SMB Versions

| Version | OS | Notable features |
|---------|-----|-----------------|
| CIFS (SMB 1) | Windows NT 4.0 | NetBIOS-based, outdated, vulnerable |
| SMB 1.0 | Windows 2000 | Direct TCP |
| SMB 2.0 | Vista / Server 2008 | Performance improvements, message signing |
| SMB 2.1 | Windows 7 / Server 2008 R2 | Locking mechanisms |
| SMB 3.0 | Windows 8 / Server 2012 | Multichannel, end-to-end encryption |
| SMB 3.1.1 | Windows 10 / Server 2016 | AES-128, integrity checking |

Samba v3 → can join AD domains. Samba v4 → can act as a full AD domain controller.

#### Samba Config

```bash
cat /etc/samba/smb.conf | grep -v "#\|\;"
```

**Dangerous settings to look for:**

| Setting | Risk |
|---------|------|
| `guest ok = yes` | No password required to connect |
| `browseable = yes` | Share is visible to everyone listing |
| `read only = no` / `writable = yes` | Allows file creation and modification |
| `create mask = 0777` | New files get world-readable/writable permissions |
| `directory mask = 0777` | Same for directories |
| `enable privileges = yes` | Honors SID-based privileges |
| `logon script = script.sh` | Executes a script on user login |
| `magic script = script.sh` | Executes when the script file is closed |

#### Enumeration

**Nmap:**

```bash
sudo nmap -sV -sC -p139,445 <IP>
```

**smbclient — list shares (null session):**

```bash
smbclient -N -L //<IP>
```

**smbclient — connect to a share:**

```bash
smbclient //<IP>/<share>
# anonymous: just hit enter on password prompt
```

Inside smbclient:

```bash
ls              # list directory
get <file>      # download file
put <file>      # upload file
!ls             # run local command without leaving session
!cat <file>     # read downloaded file locally
```

**rpcclient — null session RPC enumeration:**

```bash
rpcclient -U "" <IP>
```

| Command | What it returns |
|---------|----------------|
| `srvinfo` | Server info, OS version, server type |
| `enumdomains` | All domains on the network |
| `querydominfo` | Domain, server, user count |
| `netshareenumall` | All shares with paths |
| `netsharegetinfo <share>` | ACL and permissions for a share |
| `enumdomusers` | All domain users with RIDs |
| `queryuser <RID>` | Full user info (name, last login, password age) |
| `querygroup <RID>` | Group name and member count |

**Brute-force user RIDs (bash loop):**

```bash
for i in $(seq 500 1100); do rpcclient -N -U "" <IP> -c "queryuser 0x$(printf '%x\n' $i)" | grep "User Name\|user_rid\|group_rid" && echo ""; done
```

**samrdump.py (Impacket) — cleaner user dump:**

```bash
samrdump.py <IP>
```

**smbmap — permissions overview:**

```bash
smbmap -H <IP>
```

Shows each share and your access level (NO ACCESS / READ / READ,WRITE) at a glance.

**CrackMapExec — quick share enum with auth:**

```bash
crackmapexec smb <IP> --shares -u '' -p ''
```

Also shows SMB signing status — relevant for relay attacks.

**enum4linux-ng — automated all-in-one:**

```bash
./enum4linux-ng.py <IP> -A
```

Covers: SMB dialects, null session check, domain info, OS info, users, groups, shares, password policies. Use for a fast full picture, then verify interesting findings manually.

:::info CJCA Exam — SMB Must-Know
**Ports:** 139 (NetBIOS legacy) / 445 (TCP direct)

**Null session — list shares:**
```bash
smbclient -N -L //<IP>
```

**Connect to share:**
```bash
smbclient //<IP>/<share>
```

**rpcclient key commands:** `enumdomusers`, `netshareenumall`, `queryuser <RID>`

**Best all-in-one:** `enum4linux-ng -A`

**Permissions overview:** `smbmap -H <IP>`

**Dangerous config flags:** `guest ok = yes`, `writable = yes`, `create mask = 0777`

**Attack path:** Null session → list shares → connect → `ls`/`get` files → check write access → if writable share in webroot → drop shell
:::

---

### NFS (Ports 111 / 2049)

NFS (Network File System) is the Linux/Unix equivalent of SMB — shares filesystems over the network so clients can access them as if they were local. NFS only works between Linux/Unix systems; it cannot talk to SMB directly.

**Ports:**
- **111/tcp+udp** — RPC portmapper (service discovery)
- **2049/tcp+udp** — NFS data

#### NFS Versions

| Version | Key points |
|---------|-----------|
| NFSv2 | Old, UDP-based |
| NFSv3 | Variable file size, better errors, not backward compatible with v2 |
| NFSv4 | Kerberos auth, firewall-friendly (single port 2049), ACLs, stateful — first version with real user authentication |

#### Authentication Problem (NFSv2/3)

NFSv2 and NFSv3 have **no built-in authentication**. They simply trust the UID/GID the client sends. This means: if a file on the share is owned by UID 1000, any attacker who creates a local user with UID 1000 gains full access to that file. The server does no further verification.

#### Config — `/etc/exports`

```bash
cat /etc/exports
```

Format: `<path> <host/subnet>(<options>)`

Example:
```bash
/mnt/nfs  10.129.14.0/24(sync,no_subtree_check)
```

Apply changes:
```bash
sudo systemctl restart nfs-kernel-server
exportfs    # verify active exports
```

**Options:**

| Option | Description |
|--------|-------------|
| `rw` | Read and write |
| `ro` | Read only |
| `sync` | Synchronous transfer (safer) |
| `async` | Asynchronous transfer (faster) |
| `no_subtree_check` | Disables subdirectory tree checking |
| `root_squash` | Root access is mapped to anonymous UID — safe default |
| `no_root_squash` | Root on client = root on share — **dangerous** |
| `insecure` | Allows ports above 1024 — **dangerous** |
| `nohide` | Exposes nested mounts — **dangerous** |

#### Enumeration

**Nmap:**

```bash
sudo nmap -sV -sC -p111,2049 <IP>
sudo nmap --script nfs* -sV -p111,2049 <IP>
```

The `nfs*` scripts show: exported shares, file listings with permissions and UIDs, filesystem stats.

**List available shares:**

```bash
showmount -e <IP>
```

**Mount the share:**

```bash
mkdir target-NFS
sudo mount -t nfs <IP>:/ ./target-NFS/ -o nolock
cd target-NFS
```

**Inspect file ownership:**

```bash
ls -l mnt/nfs/     # shows usernames
ls -n mnt/nfs/     # shows raw UID/GID numbers
```

**Unmount:**

```bash
cd ..
sudo umount ./target-NFS
```

#### Attack Paths

**UID impersonation (NFSv2/3):**
1. Mount the share
2. Run `ls -n` to see file UID/GID
3. Create a local user with matching UID: `useradd -u 1000 <name>`
4. Switch to that user — you now own those files

**no_root_squash privilege escalation:**
1. Mount the share as root
2. If `no_root_squash` is set, files created as root on the client are root-owned on the server
3. Upload a SUID shell to the share → execute it via SSH to escalate

:::info CJCA Exam — NFS Must-Know
**Ports:** 111 (RPC) / 2049 (NFS)

**Key difference from SMB:** NFSv2/3 trusts client UID/GID with no verification — identity is trivially faked.

**List shares:** `showmount -e <IP>`

**Mount:**
```bash
sudo mount -t nfs <IP>:/ ./target-NFS/ -o nolock
```

**Dangerous settings:** `no_root_squash`, `insecure`, `rw`

**Attack path (UID spoof):** Mount → `ls -n` to get UID → create local user with same UID → access files

**Attack path (no_root_squash):** Mount as root → upload SUID shell → run via SSH → privilege escalation
:::

---

### DNS (Port 53)

DNS (Domain Name System) translates domain names into IP addresses. It runs on **port 53** — UDP for standard queries, TCP for zone transfers and large responses. DNS is **unencrypted by default** (DoT and DoH exist as encrypted alternatives).

#### DNS Server Types

| Type | Role |
|------|------|
| Root server | Top of the hierarchy, 13 globally. Last resort if nothing else resolves. |
| Authoritative nameserver | Holds the actual records for a zone. Answers are binding. |
| Non-authoritative nameserver | Collects DNS info via recursive/iterative queries but doesn't own the zone. |
| Caching server | Stores responses for a TTL period to speed up repeat queries. |
| Forwarding server | Simply forwards queries to another DNS server. |
| Resolver | Local resolution on the client or router. |

#### DNS Record Types

| Record | Description |
|--------|-------------|
| `A` | IPv4 address for a hostname |
| `AAAA` | IPv6 address for a hostname |
| `MX` | Mail server for the domain |
| `NS` | Nameservers responsible for the domain |
| `TXT` | Free-form text — SPF, DMARC, third-party verifications |
| `CNAME` | Alias pointing one name to another |
| `PTR` | Reverse lookup — IP → hostname |
| `SOA` | Zone authority info, serial number, admin email (@ replaced with .) |

#### Config Files (Bind9 — most common on Linux)

| File | Purpose |
|------|---------|
| `named.conf.local` | Zone definitions |
| `named.conf.options` | Global server options (allow-query, allow-transfer, recursion) |
| `named.conf.log` | Logging config |
| `/etc/bind/db.<domain>` | Forward zone file (name → IP) |
| `/etc/bind/db.<IP>` | Reverse zone file (IP → name, PTR records) |

**Dangerous settings:**

| Option | Risk |
|--------|------|
| `allow-query { any; }` | Anyone can query the server |
| `allow-recursion { any; }` | Anyone can use it as a recursive resolver |
| `allow-transfer { any; }` | Anyone can request a full zone transfer — **critical** |

#### Enumeration

**Query nameservers for a domain:**
```bash
dig ns <domain> @<IP>
```

**Query server version (if CHAOS record exists):**
```bash
dig CH TXT version.bind <IP>
```

**Query all records:**
```bash
dig any <domain> @<IP>
```

**Zone Transfer (AXFR) — the big one:**
```bash
dig axfr <domain> @<IP>
```

If `allow-transfer` is misconfigured, this dumps the entire zone — all hostnames, IPs, internal infrastructure laid out in one response. Also try on internal subdomains:

```bash
dig axfr internal.<domain> @<IP>
```

This can reveal internal hosts like `dc1`, `dc2`, `vpn`, `wsus`, `mail` with their IPs — instant full network map.

**Subdomain brute force (when AXFR is blocked):**

```bash
# Bash loop with SecLists
for sub in $(cat /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt); do
  dig $sub.<domain> @<IP> | grep -v ';\|SOA' | sed -r '/^\s*$/d' | grep $sub | tee -a subdomains.txt
done

# dnsenum — automated, also attempts AXFR
dnsenum --dnsserver <IP> --enum -p 0 -s 0 -o subdomains.txt \
  -f /opt/useful/seclists/Discovery/DNS/subdomains-top1million-110000.txt <domain>
```

:::info CJCA Exam — DNS Must-Know
**Port:** 53 (UDP queries / TCP zone transfers)

**Key records to know:** A, MX, NS, TXT, CNAME, PTR, SOA

**Query all records:**
```bash
dig any <domain> @<IP>
```

**Zone transfer attempt — always try:**
```bash
dig axfr <domain> @<IP>
dig axfr internal.<domain> @<IP>
```

**Why AXFR matters:** Misconfigured `allow-transfer { any; }` dumps the full internal DNS map — all hostnames and IPs in one command.

**Subdomain brute force:** `dnsenum --dnsserver <IP> --enum -f <wordlist> <domain>`

**Dangerous config:** `allow-transfer { any; }` — check this first when you find a DNS service.
:::

---

### SMTP (Ports 25 / 587 / 465)

SMTP (Simple Mail Transfer Protocol) handles sending and relaying emails. It is **unencrypted by default** — all commands, data, and credentials transmit in plaintext unless STARTTLS or SSL is used.

**Ports:**
- **25/tcp** — server-to-server mail transfer (default)
- **587/tcp** — authenticated client submission, uses STARTTLS to upgrade to encrypted
- **465/tcp** — SMTP over SSL (legacy but still seen)

#### Mail Flow

```
MUA (client) → MSA (submission agent) → MTA (transfer agent / relay) → MDA (delivery agent) → Mailbox
```

- **MUA** — Mail User Agent (e.g. Thunderbird, Outlook)
- **MSA** — validates and submits the email, acts as relay server
- **MTA** — transfers between servers, looks up recipient MX record via DNS
- **MDA** — delivers to the recipient's mailbox (then fetched via POP3/IMAP)

#### SMTP Commands

| Command | Description |
|---------|-------------|
| `HELO` / `EHLO` | Initiate session (EHLO = ESMTP, returns supported extensions) |
| `MAIL FROM:` | Set sender address |
| `RCPT TO:` | Set recipient address |
| `DATA` | Begin email body (end with a line containing only `.`) |
| `VRFY` | Check if a mailbox exists — useful for user enumeration |
| `EXPN` | Expand a mailing list or alias |
| `RSET` | Abort current message, keep connection |
| `NOOP` | Keep-alive, prevents timeout |
| `QUIT` | End session |
| `AUTH PLAIN` | Authenticate (ESMTP extension) |

#### Manual Interaction

```bash
telnet <IP> 25
```

Start session:
```
EHLO inlanefreight.htb
```

Enumerate users with VRFY:
```
VRFY root
VRFY cry0l1t3
```

Note: VRFY is **unreliable** — misconfigured servers return `252` for any username, including ones that don't exist. Don't trust it blindly.

Send a test email manually:
```
EHLO inlanefreight.htb
MAIL FROM: <attacker@inlanefreight.htb>
RCPT TO: <victim@inlanefreight.htb> NOTIFY=success,failure
DATA
From: <attacker@inlanefreight.htb>
To: <victim@inlanefreight.htb>
Subject: Test
Message body here.
.
QUIT
```

#### Dangerous Settings

| Setting | Risk |
|---------|------|
| `mynetworks = 0.0.0.0/0` | **Open relay** — any host can send mail through this server |
| `VRFY` enabled | User enumeration possible |

**Open relay** means attackers can send spoofed emails from any address using this server — phishing, spam, impersonation. The server's trusted reputation makes it harder for recipients to filter.

#### Nmap Enumeration

```bash
# Banner + supported commands via EHLO
sudo nmap -sC -sV -p25 <IP>

# Test for open relay (16 different relay tests)
sudo nmap -p25 --script smtp-open-relay -v <IP>
```

`smtp-commands` NSE script runs EHLO and lists all supported extensions. `smtp-open-relay` confirms if the server will relay to external addresses.

:::info CJCA Exam — SMTP Must-Know
**Ports:** 25 (server-to-server) / 587 (client + STARTTLS) / 465 (SSL)

**User enumeration:**
```bash
telnet <IP> 25
VRFY <username>
```
Unreliable — always verify results manually.

**Check for open relay:**
```bash
sudo nmap -p25 --script smtp-open-relay <IP>
```

**Open relay config flag:** `mynetworks = 0.0.0.0/0`

**What open relay enables:** Send spoofed emails as any address — phishing and impersonation.

**Mail flow to remember:** MUA → MSA → MTA → MDA → Mailbox
:::

---

### IMAP / POP3 (Ports 143, 993 / 110, 995)

IMAP and POP3 are the **receiving** side of email. SMTP sends — these two fetch.

| | IMAP | POP3 |
|---|------|------|
| **Port (plain)** | 143 | 110 |
| **Port (SSL)** | 993 | 995 |
| **Emails stored** | On server | Downloaded to client |
| **Folder support** | Yes | No |
| **Multi-client sync** | Yes | No |
| **Use case** | Full mailbox management | Simple download + delete |

Both are **unencrypted by default**. SSL versions run on 993/995.

#### IMAP Commands

```
1 LOGIN username password       # authenticate
1 LIST "" *                     # list all folders
1 SELECT INBOX                  # open a mailbox
1 FETCH <ID> all                # retrieve a message
1 LSUB "" *                     # list subscribed folders
1 CLOSE                         # expunge deleted messages
1 LOGOUT                        # end session
```

#### POP3 Commands

```
USER username    # identify user
PASS password    # authenticate
STAT             # number of emails on server
LIST             # list all emails with sizes
RETR <id>        # download email by ID
DELE <id>        # delete email by ID
CAPA             # show server capabilities
QUIT             # end session
```

#### Dangerous Settings (Dovecot)

| Setting | Risk |
|---------|------|
| `auth_debug=yes` | Logs all auth attempts in detail |
| `auth_debug_passwords=yes` | Logs submitted passwords in plaintext |
| `auth_verbose=yes` | Logs failed auth attempts and reasons |
| `auth_verbose_passwords=yes` | Logs truncated passwords |
| `auth_anonymous_username` | Enables anonymous login via SASL ANONYMOUS |

#### Enumeration

**Nmap:**
```bash
sudo nmap -sV -sC -p110,143,993,995 <IP>
```

SSL certificate in the output reveals: hostname, org, location, admin email address.

**cURL — list IMAP folders with credentials:**
```bash
curl -k 'imaps://<IP>' --user username:password
```

**cURL verbose — see TLS version, cert details, full IMAP handshake:**
```bash
curl -k 'imaps://<IP>' --user username:password -v
```

**OpenSSL — interactive session over SSL:**
```bash
# POP3S
openssl s_client -connect <IP>:995

# IMAPS
openssl s_client -connect <IP>:993
```

After connecting with openssl, type IMAP or POP3 commands directly. The SSL cert will show hostname and email — useful for recon even before authenticating.

**If you have credentials — read emails via IMAP:**
```bash
openssl s_client -connect <IP>:993
# then:
1 LOGIN username password
1 LIST "" *
1 SELECT INBOX
1 FETCH 1 all
```

:::info CJCA Exam — IMAP/POP3 Must-Know
**Ports:** IMAP 143 (plain) / 993 (SSL) — POP3 110 (plain) / 995 (SSL)

**Key difference:** IMAP keeps mail on server + folder sync. POP3 just downloads.

**Nmap scan:**
```bash
sudo nmap -sV -sC -p110,143,993,995 <IP>
```

**List folders with creds:**
```bash
curl -k 'imaps://<IP>' --user user:pass
```

**Interactive session:**
```bash
openssl s_client -connect <IP>:993   # IMAP
openssl s_client -connect <IP>:995   # POP3
```

**Read inbox once logged in:**
```
1 LOGIN user pass → 1 LIST "" * → 1 SELECT INBOX → 1 FETCH 1 all
```

**SSL cert leaks:** hostname, org, admin email — check it even before auth.

**Dangerous config:** `auth_debug_passwords=yes` logs plaintext passwords.
:::

---

### SNMP (UDP 161 / 162)

**Not to be confused with SMTP.** SMTP = email sending. SNMP = network device monitoring and management.

SNMP (Simple Network Management Protocol) monitors and controls routers, switches, servers, printers, IoT devices — anything network-attached. It can read device state AND push config changes remotely.

**Ports:**
- **UDP 161** — queries and commands (client → device)
- **UDP 162** — traps (device → client, unsolicited alerts on events)

#### SNMP Versions

| Version | Security |
|---------|----------|
| **v1** | No authentication, no encryption — everything in plaintext |
| **v2c** | Same security as v1, community strings still plaintext |
| **v3** | Username + password auth, pre-shared key encryption — secure but complex |

Most networks still run v2c because migrating to v3 is painful. This means community strings travel in plaintext on the wire.

#### Community Strings

Community strings are effectively plaintext passwords for v1/v2c access:
- **`public`** — read-only (default, almost never changed)
- **`private`** — read-write (default write community)

If `public` works → you can read the entire MIB tree of the device.
If `private` works → you can also write config changes.

#### MIB and OID

- **MIB** (Management Information Base) — a text file describing all queryable objects on a device. Tells you what OIDs exist, what type they are, what they mean.
- **OID** (Object Identifier) — a numeric dotted path to a specific data point (e.g. `.1.3.6.1.2.1.1.5.0` = hostname). The longer the chain, the more specific the value.

You don't need to memorize OIDs — `snmpwalk` resolves them to human-readable strings automatically.

#### Dangerous Settings

| Setting | Risk |
|---------|------|
| `rwuser noauth` | Full OID tree write access with no authentication |
| `rwcommunity <string> <IP>` | Read-write access from any IP using that community string |
| `rwcommunity6 <string> <IPv6>` | Same over IPv6 |

#### Enumeration

**snmpwalk — dump all OIDs using a community string:**
```bash
snmpwalk -v2c -c public <IP>
```

Returns: OS version, hostname, uptime, contact email, location, running processes, installed packages, network interfaces — massive intel dump from a single command.

**onesixtyone — brute-force community strings:**
```bash
onesixtyone -c /opt/useful/seclists/Discovery/SNMP/snmp.txt <IP>
```

Tries a wordlist of community strings. Returns the valid ones with the device banner.

**braa — fast OID brute-force once you have a community string:**
```bash
braa <community string>@<IP>:.1.3.6.*
# example:
braa public@<IP>:.1.3.6.*
```

Walks the entire OID subtree rapidly. Useful for large-scale enumeration.

:::info CJCA Exam — SNMP Must-Know
**Ports:** UDP 161 (queries) / UDP 162 (traps)

**Not SMTP** — SNMP monitors network devices, has nothing to do with email.

**Default community strings to always try:** `public` (read), `private` (write)

**Full device dump:**
```bash
snmpwalk -v2c -c public <IP>
```
Returns OS, hostname, uptime, contact, installed packages, processes — everything.

**Brute-force community string:**
```bash
onesixtyone -c /opt/useful/seclists/Discovery/SNMP/snmp.txt <IP>
```

**Dangerous config:** `rwcommunity public 0.0.0.0` — write access to any IP with default string.

**v1/v2c weakness:** community strings travel in plaintext — sniffable on the wire.
:::

---

### MySQL (Port 3306)

MySQL is an open-source relational database management system — data stored in tables, queried with SQL. It's the backbone of nearly every web application (WordPress, Joomla, custom apps). **MariaDB** is a direct fork and is often used interchangeably. Common stack: **LAMP** (Linux + Apache + MySQL + PHP) or **LEMP** (with Nginx).

**Port:** 3306/tcp

Web apps store everything here: usernames, password hashes, emails, session tokens, content, permissions. If you can reach this port and authenticate, you have everything the app has.

#### Config File

```bash
cat /etc/mysql/mysql.conf.d/mysqld.cnf | grep -v "#" | sed -r '/^\s*$/d'
```

**Dangerous settings:**

| Setting | Risk |
|---------|------|
| `user` / `password` in config | Credentials stored in plaintext in the config file |
| `admin_address` | If set to `0.0.0.0`, admin interface exposed externally |
| `debug` / `sql_warnings` | Verbose error output — leaks schema info to users, enables SQL injection intel-gathering |
| `secure_file_priv = ""` | No restriction on file import/export — enables `LOAD DATA` / `INTO OUTFILE` attacks |

#### Nmap Enumeration

```bash
sudo nmap -sV -sC -p3306 --script mysql* <IP>
```

Key scripts in the `mysql*` family:
- `mysql-empty-password` — checks if root has no password
- `mysql-enum` — enumerates valid usernames
- `mysql-info` — version, capabilities, auth plugin
- `mysql-brute` — brute-force credentials

Always verify nmap results manually — false positives are common with these scripts.

#### Connect and Interact

```bash
# No password
mysql -u root -h <IP>

# With password (no space between -p and the password)
mysql -u root -pP4SSw0rd -h <IP>
```

#### Key SQL Commands

| Command | What it does |
|---------|-------------|
| `show databases;` | List all databases |
| `use <database>;` | Switch to a database |
| `show tables;` | List all tables in current database |
| `show columns from <table>;` | Show table structure |
| `select * from <table>;` | Dump entire table |
| `select * from <table> where <col> = "<val>";` | Filtered query |
| `select version();` | Show MySQL version |

#### Important System Databases

| Database | What it contains |
|----------|-----------------|
| `information_schema` | Metadata about all databases, tables, columns — ANSI standard |
| `sys` | Performance and usage stats, connected hosts, active queries |
| `mysql` | User accounts, privileges, authentication data |

When you land in a MySQL shell, start with `show databases;` — the most interesting one is usually named after the application (e.g. `wordpress`, `joomla`, `app`).

:::info CJCA Exam — MySQL Must-Know
**Port:** 3306/tcp

**Connect:**
```bash
mysql -u root -p<password> -h <IP>
# no space between -p and password
```

**Enumerate with nmap:**
```bash
sudo nmap -sV -sC -p3306 --script mysql* <IP>
```
Check for `mysql-empty-password` — root with no password is an instant win.

**First commands once in:**
```sql
show databases;
use <interesting_db>;
show tables;
select * from users;
```

**Dangerous config:** `secure_file_priv = ""` enables file read/write via SQL.

**Attack path:** Port exposed → nmap scripts → empty/default password → connect → dump users table → crack hashes or reuse credentials.
:::

---

### MSSQL (Port 1433)

Microsoft SQL Server — Windows-native, closed source, tightly integrated with Active Directory. Contrast with MySQL: MSSQL uses Windows Authentication by default and runs as a domain-aware service account.

**Port:** 1433/tcp

#### Default System Databases

| Database | Purpose |
|----------|---------|
| `master` | Tracks all system info for the SQL instance |
| `model` | Template for every new database created |
| `msdb` | SQL Server Agent — jobs, alerts, scheduling |
| `tempdb` | Temporary objects, intermediate query results |
| `resource` | Read-only, contains built-in system objects |

#### Default Configuration

- Runs as `NT SERVICE\MSSQLSERVER` by default
- **Windows Authentication** — login uses local SAM or Active Directory, not a separate DB user list
- Encryption **not enforced** by default on connections

#### Dangerous Settings

| Issue | Risk |
|-------|------|
| Unencrypted client connections | Credentials and data in plaintext on the wire |
| Self-signed certificates | Can be spoofed — false sense of encryption security |
| Named pipes enabled | Additional attack vector beyond TCP |
| Weak / default `sa` credentials | `sa` = system administrator account — full DB access if compromised |
| SSMS installed with saved credentials | Client-side app may store creds attackers can reuse |

#### Nmap Enumeration

```bash
sudo nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-xp-cmdshell,ms-sql-config,ms-sql-ntlm-info,ms-sql-tables,ms-sql-hasdbaccess,ms-sql-dac,ms-sql-dump-hashes \
  --script-args mssql.instance-port=1433,mssql.username=sa,mssql.password=,mssql.instance-name=MSSQLSERVER \
  -sV -p1433 <IP>
```

Returns: hostname, instance name, SQL Server version, named pipe path, DAC port.

#### Metasploit — Quick Ping

```bash
use auxiliary/scanner/mssql/mssql_ping
set rhosts <IP>
run
```

Returns: server name, instance name, version, TCP port, named pipe.

#### Connect with Impacket

```bash
python3 mssqlclient.py Administrator@<IP> -windows-auth
# or via impacket wrapper:
impacket-mssqlclient Administrator@<IP> -windows-auth
```

`-windows-auth` tells it to use Windows/AD credentials instead of SQL auth.

#### Key SQL Commands (T-SQL)

| Command | What it does |
|---------|-------------|
| `select name from sys.databases` | List all databases |
| `use <database>` | Switch to a database |
| `select * from information_schema.tables` | List tables in current DB |
| `select * from <table>` | Dump table |
| `exec xp_cmdshell 'whoami'` | OS command execution (if enabled) |

`xp_cmdshell` is disabled by default but can be re-enabled if you have `sa` or sysadmin rights — instant RCE.

:::info CJCA Exam — MSSQL Must-Know
**Port:** 1433/tcp — Windows environments

**Nmap scan:**
```bash
sudo nmap --script ms-sql-info,ms-sql-empty-password,ms-sql-ntlm-info -sV -p1433 <IP>
```

**Connect (Impacket):**
```bash
impacket-mssqlclient Administrator@<IP> -windows-auth
```

**First command once in:**
```sql
select name from sys.databases
```

**Key difference from MySQL:** Windows Auth = AD credentials work. Check for `sa` account with empty/default password.

**`xp_cmdshell`:** Disabled by default, but if you have sysadmin → enable it → OS command execution → RCE.

**Attack path:** Port exposed → nmap scripts → try `sa` with empty password → connect → enumerate DBs → enable `xp_cmdshell` if sysadmin → RCE.
:::

---

### Oracle TNS (Port 1521)

Oracle's proprietary network protocol for communication between Oracle databases and clients. More complex to enumerate than MySQL/MSSQL — you need to know the correct **SID** before you can even connect.

**Port:** 1521/tcp

#### Key Concepts

**SID (System Identifier)** — a unique name identifying a specific Oracle database instance. Multiple instances can run on one server, each with its own SID. The client must specify the correct SID in its connection string. It is not advertised — it must be guessed or brute-forced.

**Config files** (located in `$ORACLE_HOME/network/admin/`):

| File | Side | Purpose |
|------|------|---------|
| `tnsnames.ora` | Client | Maps service names to network addresses and SIDs |
| `listener.ora` | Server | Defines listener properties — what ports, protocols, and instances it accepts |

#### Default / Known Credentials

| Account | Default password | Notes |
|---------|-----------------|-------|
| Oracle 9 install | `CHANGE_ON_INSTALL` | Often never changed |
| `DBSNMP` service | `dbsnmp` | Monitoring service account |
| `scott` | `tiger` | Classic test account — still found in production |

#### Enumeration

**Nmap — basic scan:**
```bash
sudo nmap -p1521 -sV <IP> --open
```

**Nmap — brute-force SID:**
```bash
sudo nmap -p1521 -sV <IP> --open --script oracle-sid-brute
```

Returns the valid SID(s) — required before any further interaction.

**ODAT — full enumeration (all modules):**
```bash
./odat.py all -s <IP>
```

ODAT tries all attack modules: SID guessing, credential brute-force, privilege checks, file upload, RCE attempts. Returns valid credentials if found (e.g. `scott/tiger`).

#### Connect and Interact — sqlplus

```bash
# Standard login
sqlplus scott/tiger@<IP>/XE

# Login as sysdba (try even with low-priv account)
sqlplus scott/tiger@<IP>/XE as sysdba
```

**Key SQL commands once in:**

```sql
select table_name from all_tables;          -- list all tables
select * from user_role_privs;              -- check current user's roles
select name, password from sys.user$;       -- extract password hashes (sysdba required)
```

#### Privilege Escalation — sysdba

Even a standard user can attempt `as sysdba`. If the account has been granted that privilege (or the DB is misconfigured), you land as SYS with full admin rights. Always try it.

#### File Upload → Webshell (ODAT utlfile)

If the DB server also runs a web server, you can upload files directly via Oracle:

```bash
./odat.py utlfile -s <IP> -d XE -U scott -P tiger --sysdba --putFile C:\\inetpub\\wwwroot shell.php ./shell.php
```

Verify upload:
```bash
curl -X GET http://<IP>/shell.php
```

Default web roots to try: `/var/www/html` (Linux), `C:\inetpub\wwwroot` (Windows).

#### Extract Password Hashes

```sql
select name, password from sys.user$;
```

Returns hashed passwords for all DB accounts — crack offline with Hashcat.

:::info CJCA Exam — Oracle TNS Must-Know
**Port:** 1521/tcp

**Two-step enumeration — SID first, then credentials:**
```bash
# Step 1: find the SID
sudo nmap -p1521 --script oracle-sid-brute <IP>

# Step 2: brute-force credentials
./odat.py all -s <IP>
```

**Connect:**
```bash
sqlplus <user>/<pass>@<IP>/<SID>
sqlplus <user>/<pass>@<IP>/<SID> as sysdba
```

**Default creds to always try:** `scott/tiger`, `dbsnmp/dbsnmp`, Oracle 9: `CHANGE_ON_INSTALL`

**Once in as sysdba:**
```sql
select name, password from sys.user$;   -- dump hashes
```

**File upload to webroot:** `odat.py utlfile --putFile` → webshell if web server is co-located.

**Attack path:** nmap SID brute → ODAT all → creds found → sqlplus → try sysdba → dump hashes or upload shell.
:::

---

### IPMI (UDP 623)

IPMI (Intelligent Platform Management Interface) is hardware-level remote management. It runs on a dedicated microcontroller called the **BMC (Baseboard Management Controller)**, completely independent of the host OS, BIOS, and CPU. Works even when the server is fully powered off or crashed.

**Port:** 623/UDP


Access to a BMC = near-physical access to the server. You can power on/off, reboot, reinstall the OS, read hardware event logs, monitor temperatures and voltages, and access serial console — all over the network.

**Common BMC implementations:**
- **HP iLO**
- **Dell iDRAC** (formerly DRAC)
- **Supermicro IPMI**

All three typically expose a web management console + SSH/Telnet + UDP 623.

#### Default Credentials

| Product | Username | Password |
|---------|----------|----------|
| Dell iDRAC | `root` | `calvin` |
| HP iLO | `Administrator` | Random 8-char (uppercase + digits) — but often set to something simple |
| Supermicro IPMI | `ADMIN` | `ADMIN` |

Always try defaults first — they are left unchanged far more often than they should be.

#### Enumeration

**Nmap:**
```bash
sudo nmap -sU --script ipmi-version -p 623 <IP>
```

**Metasploit — version scan:**
```bash
use auxiliary/scanner/ipmi/ipmi_version
set rhosts <IP>
run
```

Returns: IPMI version, supported auth methods, user auth details.

#### RAKP Vulnerability — Hash Dumping (IPMI 2.0)

A flaw in the IPMI 2.0 RAKP authentication protocol: the server sends the user's **salted password hash to the client before authentication completes**. This means you can request hashes for any valid username without knowing the password.

**Metasploit — dump hashes:**
```bash
use auxiliary/scanner/ipmi/ipmi_dumphashes
set rhosts <IP>
run
```

Returns HMAC-SHA1 hashes for all valid users — save them for offline cracking.

**Crack with Hashcat (mode 7300):**
```bash
hashcat -m 7300 ipmi.txt /usr/share/wordlists/rockyou.txt
```

**HP iLO factory default — mask attack (8 chars, uppercase + digits):**
```bash
hashcat -m 7300 ipmi.txt -a 3 ?1?1?1?1?1?1?1?1 -1 ?d?u
```

There is no fix for the RAKP flaw — it's baked into the IPMI 2.0 spec. Mitigations are long passwords and network segmentation only.

#### Why IPMI Matters on Internal Assessments

Cracked IPMI passwords are frequently **reused across other systems**. A single cracked BMC password has led to root SSH access across entire server fleets in real engagements. Always include IPMI in internal pentest scope.

:::info CJCA Exam — IPMI Must-Know
**Port:** 623/UDP

**What it is:** Hardware remote management — independent of OS, works even when server is off. Access = physical access.

**Enumerate:**
```bash
sudo nmap -sU --script ipmi-version -p 623 <IP>
```

**Default creds to try:** Dell `root/calvin` — Supermicro `ADMIN/ADMIN` — HP `Administrator/<try common>`

**RAKP hash dump (no password needed):**
```bash
use auxiliary/scanner/ipmi/ipmi_dumphashes
```

**Crack hashes:**
```bash
hashcat -m 7300 ipmi.txt <wordlist>
```

**Attack path:** nmap UDP 623 → try default creds → if no luck → dump RAKP hashes → crack offline → login to BMC web console or SSH → check password reuse on other systems.
:::

---

## Remote Management Protocols

Remote management protocols let you control servers over the network without physical access. On Linux, the three main ones you'll encounter are SSH (the modern standard), Rsync (file sync that can leak data), and R-Services (legacy Unix protocols that are dangerously easy to abuse).

---

### SSH (Port 22)

SSH (Secure Shell) establishes an encrypted tunnel between two hosts over TCP 22. The modern standard for remote access on Linux/macOS — it replaced everything insecure that came before it (Telnet, R-Services, FTP).

**Port:** 22/tcp

**Two protocol versions:**
- **SSH-1** — outdated, vulnerable to MITM attacks
- **SSH-2** — current standard: better encryption, speed, stability, no MITM vulnerability

#### Authentication Methods

OpenSSH supports six methods (ordered from most to least common in practice):

| Method | How it works |
|--------|-------------|
| Password | User types password — server checks hash |
| **Public key** | Client proves ownership of private key by solving a server-generated challenge |
| Host-based | Trust based on source hostname |
| Keyboard-interactive | Server sends custom prompt (MFA, OTP, etc.) |
| Challenge-response | Cryptographic challenge (e.g. TOTP) |
| GSSAPI | Kerberos/enterprise SSO integration |

**Public key authentication (most important):**
The server sends a cryptographic challenge encrypted with the client's public key. Only the holder of the matching private key can decrypt it and send back the correct response. Once authenticated, the user can connect to multiple servers in a session without re-entering credentials — only the passphrase for the local private key.

#### Dangerous Settings (`/etc/ssh/sshd_config`)

| Setting | Risk |
|---------|------|
| `PasswordAuthentication yes` | Enables brute-force against known usernames |
| `PermitEmptyPasswords yes` | Accounts with no password are directly accessible |
| `PermitRootLogin yes` | Root shell directly over SSH — no privilege escalation needed |
| `Protocol 1` | Obsolete, vulnerable to MITM |
| `X11Forwarding yes` | CVE-2016-3115 — command injection in OpenSSH 7.2p1 |
| `AllowTcpForwarding yes` | Can be used for port tunneling into internal networks |

#### Enumeration — ssh-audit

`ssh-audit` fingerprints the server's supported algorithms and flags weak/deprecated ones:

```bash
git clone https://github.com/jtesta/ssh-audit.git && cd ssh-audit
./ssh-audit.py <IP>
```

Returns: banner (version + OS build), supported key exchange algorithms, host key types, ciphers, MACs — any marked `[fail]` are weak.

**Banner reading:**
- `SSH-1.99-OpenSSH_3.9p1` → supports SSH-1 and SSH-2
- `SSH-2.0-OpenSSH_8.2p1` → SSH-2 only

**Version intel:** The OpenSSH version in the banner maps to a specific OS and patch level. Older versions carry known CVEs (e.g. CVE-2020-14145 in early SSH-2 implementations).

#### Check Available Auth Methods

```bash
ssh -v cry0l1t3@<IP>
# Look for: Authentications that can continue: publickey,password,keyboard-interactive
```

**Force password auth (for brute-force):**
```bash
ssh -v cry0l1t3@<IP> -o PreferredAuthentications=password
```

:::info CJCA Exam — SSH Must-Know
**Port:** 22/tcp

**Fingerprint the server:**
```bash
./ssh-audit.py <IP>
```
Look at: banner (version + OS), weak algorithms marked `[fail]`.

**Check available auth methods:**
```bash
ssh -v <user>@<IP>
```

**Force password auth for brute-force:**
```bash
ssh -v <user>@<IP> -o PreferredAuthentications=password
```

**Dangerous settings to check:** `PasswordAuthentication yes` + `PermitRootLogin yes` = direct root brute-force possible.

**SSH-1 vs SSH-2:** SSH-1 is MITM-vulnerable. Banner `SSH-2.0-*` = SSH-2 only. Banner `SSH-1.99-*` = both versions supported.

**Attack path:** Banner grab → ssh-audit → check for password auth enabled → brute-force (or try defaults) → if root login allowed → game over.
:::

---

### Rsync (Port 873)

Rsync is a fast file synchronisation tool used for backups and mirroring. Its **delta-transfer algorithm** only sends the changed parts of files, making it very efficient. It runs on TCP 873 by default but can also run over SSH.

**Port:** 873/tcp

The key attack angle: Rsync **shares** (named directories) can sometimes be listed and downloaded **without authentication**. Backup systems are common Rsync targets — they often contain SSH keys, config files, and credential stores.

#### Enumeration

**Nmap — detect Rsync:**
```bash
sudo nmap -sV -p 873 <IP>
```

**Netcat — list available shares:**
```bash
nc -nv <IP> 873
# After connection, type:
#list
```

Returns a list of share names with descriptions — no authentication needed.

**List contents of a specific share:**
```bash
rsync -av --list-only rsync://<IP>/<share>
```

Shows all files and directories in the share including permissions and timestamps.

**Download everything from a share:**
```bash
rsync -av rsync://<IP>/<share> ./local_copy/
```

**Over SSH (non-standard port):**
```bash
rsync -av -e "ssh -p 2222" rsync://<IP>/<share> ./
```

#### What to Look For

In directory listings, immediately check for:
- `.ssh/` directories — private keys, authorized_keys
- `*.yaml`, `*.conf`, `*.env` files — credentials, connection strings
- Backup files — database dumps, config archives

:::info CJCA Exam — Rsync Must-Know
**Port:** 873/tcp

**List shares (no auth required):**
```bash
nc -nv <IP> 873
# then type: #list
```

**List share contents:**
```bash
rsync -av --list-only rsync://<IP>/<share>
```

**Download share:**
```bash
rsync -av rsync://<IP>/<share> ./loot/
```

**Red flags in directory listing:** `.ssh/` directory → grab private keys → use for SSH access. Config/yaml files → credentials → password reuse.

**Attack path:** nmap 873 → nc list shares → rsync --list-only → spot .ssh/ or secrets → download → use credentials/keys elsewhere.
:::

---

### R-Services (Ports 512 / 513 / 514)

R-Services are a legacy suite of Unix remote management tools developed at UC Berkeley. Replaced by SSH because they transmit everything — including passwords — **in plaintext** and rely on trust files instead of real authentication.

**Ports:** 512/tcp (`rexec`), 513/tcp (`rlogin`), 514/tcp (`rsh`/`rcp`)

Still found in commercial Unix environments (Solaris, HP-UX, AIX) and occasionally on old internal Linux boxes.

#### The Commands

| Command | Daemon | Port | Description |
|---------|--------|------|-------------|
| `rlogin` | rlogind | 513 | Login to remote host — like Telnet but Unix-only |
| `rsh` | rshd | 514 | Run commands on remote host — no login prompt |
| `rcp` | rshd | 514 | Copy files bidirectionally — no overwrite warning |
| `rexec` | rexecd | 512 | Execute commands — requires username/password over **unencrypted** socket |
| `rwho` | rwhod | 513/UDP | List all logged-in users on local network |
| `rusers` | — | — | Detailed user listing across network hosts |

#### Trust Files — The Core Vulnerability

R-Services bypass password authentication entirely using two trust files:

**`/etc/hosts.equiv`** — system-wide trust (any user on a trusted host can log in):
```
# <hostname> <local username>
pwnbox cry0l1t3
```

**`~/.rhosts`** — per-user trust:
```
htb-student  10.0.17.5
+            10.0.17.10   # any user from this IP
+            +            # any user from any host — completely open
```

The `+` wildcard is the critical misconfiguration. `+ +` in `.rhosts` = anyone can log in as this user from anywhere, with no credentials.

#### Enumeration

**Nmap:**
```bash
sudo nmap -sV -p 512,513,514 <IP>
```

**Login via rlogin (no password if .rhosts allows it):**
```bash
rlogin <IP> -l <username>
```

**List logged-in users across the network:**
```bash
rwho
rusers -al <IP>
```

`rwho` periodically broadcasts user info on the network — passive sniffing can also collect this.

:::info CJCA Exam — R-Services Must-Know
**Ports:** 512/tcp (rexec) · 513/tcp (rlogin) · 514/tcp (rsh/rcp)

**Scan:**
```bash
sudo nmap -sV -p 512,513,514 <IP>
```

**Login attempt (exploits .rhosts misconfiguration):**
```bash
rlogin <IP> -l <username>
```

**Key vulnerability:** `.rhosts` and `/etc/hosts.equiv` with `+ +` entries → no password required → instant shell.

**Recon after login:**
```bash
rwho          # who's logged in on the network
rusers -al <IP>  # detailed user info
```

**Why they matter:** Transmit everything in plaintext. Trust files can grant authentication bypass with zero credentials. Rare but worth checking — instantly exploitable when found.

**Attack path:** nmap 512/513/514 → rlogin with target username → check if .rhosts grants access → shell without credentials → rwho/rusers for lateral movement targets.
:::

---

### RDP (Port 3389)

Remote Desktop Protocol — Microsoft's GUI remote access protocol. Gives you a full graphical desktop session on a remote Windows host. Built into every Windows version, enabled by default on Windows Server 2016+.

**Port:** 3389/tcp (also 3389/udp for some admin tasks)

RDP has used TLS/SSL encryption since Windows Vista. The problem: certificates are **self-signed by default**, so the client can't distinguish a real certificate from a forged one — it just warns the user. Many environments also still accept legacy RDP Security (unencrypted) even when TLS is configured.

**NLA (Network Level Authentication):** Forces authentication before the full RDP session is established. Hardens the service by reducing the attack surface — unauthenticated attackers can't get to the Windows login screen. When NLA is enabled, credential-stuffing attacks must go through CredSSP rather than the GUI login prompt.

#### Enumeration

**Nmap with RDP scripts:**
```bash
nmap -sV -sC <IP> -p3389 --script rdp*
```

Returns from the nmap output:
- NLA status (CredSSP supported = NLA enabled)
- Hostname, domain name (from NTLM negotiation)
- Windows version (`Product_Version: 10.0.17763` = Windows Server 2019)
- System time

**Note on detection:** Nmap uses `mstshash=nmap` in its RDP cookie. EDR and threat hunting tools can identify this. On hardened networks, the nmap scan itself may trigger alerts.

**rdp-sec-check — enumerate supported security protocols:**
```bash
git clone https://github.com/CiscoCXSecurity/rdp-sec-check.git && cd rdp-sec-check
./rdp-sec-check.pl <IP>
```

Returns whether the server supports PROTOCOL_RDP (legacy unencrypted), PROTOCOL_SSL (TLS), or PROTOCOL_HYBRID (NLA/CredSSP), and which encryption methods are accepted.

#### Connect from Linux

```bash
xfreerdp /u:<user> /p:"<password>" /v:<IP>
```

Self-signed certificate warning is normal — type `y` to accept and proceed. Other options: `rdesktop`, `Remmina` (GUI).

:::info CJCA Exam — RDP Must-Know
**Port:** 3389/tcp

**Enumerate:**
```bash
nmap -sV -sC <IP> -p3389 --script rdp*
```
Key intel from output: NLA enabled/disabled, hostname, Windows version.

**Security check:**
```bash
./rdp-sec-check.pl <IP>
```
If `PROTOCOL_RDP: TRUE` → legacy unencrypted RDP is accepted — weaker target.

**Connect from Linux:**
```bash
xfreerdp /u:<user> /p:"<password>" /v:<IP>
```

**NLA:** If enabled → authentication required before session starts → can't get to login screen without valid credentials. If disabled → login screen is exposed to brute-force.

**Self-signed certs:** Default RDP uses self-signed certificates — certificate warnings are normal, not an indicator of MITM.

**Attack path:** nmap rdp* → check NLA → brute-force if password auth enabled → xfreerdp to connect → full GUI desktop.
:::

---

### WinRM (Ports 5985 / 5986)

Windows Remote Management — Microsoft's command-line remote management protocol. Based on WS-Management (SOAP over HTTP/HTTPS). Primarily used for PowerShell remoting, remote script execution, and event log management.

**Ports:**
- **5985/tcp** — HTTP (most common in practice)
- **5986/tcp** — HTTPS

Must be explicitly enabled on Windows 10 and older servers. **Enabled by default from Windows Server 2012 onward.**

#### Enumeration

**Nmap:**
```bash
nmap -sV -sC <IP> -p5985,5986 --disable-arp-ping -n
```

A response on 5985 confirms WinRM is active. The service banner (`Microsoft HTTPAPI httpd 2.0`) also reveals the OS.

**PowerShell (internal network — check reachability):**
```powershell
Test-WsMan <hostname>
```

#### Connect with evil-winrm (Linux)

```bash
evil-winrm -i <IP> -u <user> -p <password>
```

Drops you into a PowerShell prompt on the remote host:
```
*Evil-WinRM* PS C:\Users\<user>\Documents>
```

From here you have a full interactive PowerShell session — enumerate, execute commands, upload/download files.

:::info CJCA Exam — WinRM Must-Know
**Ports:** 5985/tcp (HTTP) · 5986/tcp (HTTPS)

**Enumerate:**
```bash
nmap -sV -sC <IP> -p5985,5986
```

**Connect (Linux):**
```bash
evil-winrm -i <IP> -u <user> -p <password>
```

**What you get:** Interactive PowerShell session on the remote host.

**Default on:** Windows Server 2012+. Must be enabled manually on Windows 10 and older servers.

**Attack path:** nmap 5985/5986 → credentials found elsewhere (password reuse, dump) → evil-winrm → PowerShell shell.
:::

---

### WMI (Port 135 + dynamic)

Windows Management Instrumentation — Microsoft's primary interface for reading and writing almost any configuration on a Windows system. Runs on every Windows machine. Accessed via PowerShell, VBScript, or WMIC locally; over the network via port 135 (initial connection) + a random high port (actual communication).

**Port:** 135/tcp (initial), then random high port for data transfer

WMI gives read/write access to processes, services, registry, hardware state, event logs, users, network config, installed software — nearly everything. For a pentester with valid credentials, it's a direct path to command execution.

#### Remote Execution with wmiexec.py

```bash
impacket-wmiexec <user>:"<password>"@<IP> "<command>"

# Example:
impacket-wmiexec Cry0l1t3:"P455w0rD!"@10.129.201.248 "hostname"
```

Returns the command output directly. Uses SMBv3 under the hood. Useful for single-command execution when you have credentials but don't need a full interactive shell.

:::info CJCA Exam — WMI Must-Know
**Port:** 135/tcp initial, then random port

**Remote command execution:**
```bash
impacket-wmiexec <user>:"<password>"@<IP> "<command>"
```

**What it gives you:** Authenticated command execution on any Windows host where WMI is reachable and credentials are valid.

**Why it matters:** No dedicated service to enable — WMI runs on every Windows machine. If you have credentials + network access to port 135, you have remote code execution.

**Attack path:** Credentials found → wmiexec.py → command execution → enumerate/escalate.
:::

---
