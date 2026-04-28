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
