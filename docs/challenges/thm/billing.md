---
title: Billing
description: TryHackMe room focused on exploiting MagnusBilling through unauthenticated remote command execution and privilege escalation via Fail2Ban.
---

# Billing

Some mistakes can be costly.  
This room explores a vulnerable MagnusBilling instance and demonstrates how misconfigured services can lead to full system compromise.

## Summary

The target was a web server running MagnusBilling, an open-source VoIP billing platform.  
I discovered an unauthenticated remote command execution vulnerability and escalated from the `asterisk` user to root using a misconfigured Fail2Ban setup.

## Enumeration

Initial Nmap scan revealed four open ports:

- Port 80 — HTTP web server  
- Port 3306 — MariaDB  
- Port 5038 — Asterisk Call Manager  
- One additional unspecified port

The `robots.txt` file disclosed a hidden `/mbilling` directory.  
Accessing it revealed a login page with the title "MagnusBilling".

MagnusBilling is known to be vulnerable to CVE-2023-30258, which allows unauthenticated remote command execution.

## Exploitation

Using Metasploit, I loaded the `magnusbilling_unauth_rce_cve_2023_30258` module.  
I configured the payload as `php/meterpreter/reverse_tcp` and set the target to `billing.thm`.

After executing the exploit, I received a shell as the `asterisk` user.  
To improve shell stability, I set up a second listener and upgraded to a fully interactive TTY.

## Post-Exploitation

While exploring the system, I found another user named `magnus`.  
I had access to their home directory and retrieved the user flag.

Checking sudo privileges for `asterisk`, I saw that I could run `/usr/bin/fail2ban-client` as root without a password.  
Fail2Ban runs as root and executes predefined actions when certain patterns are matched in log files.

I confirmed the fail2ban-server process was active and that there were eight jails configured.  
One of them, `asterisk-iptables`, monitored the `/var/log/asterisk/messages` log file and used the `iptables-allports` action.

To escalate privileges, I modified the `actionban` command of the `iptables-allports-ASTERISK` action.  
Instead of banning an IP, I configured it to set the setuid bit on `/bin/bash`.

After confirming the change, I manually banned a fake IP address to trigger the action.  
This successfully modified the permissions on `/bin/bash`.

I then executed `/bin/bash -p` and spawned a root shell using Python.  
From there, I confirmed root access and retrieved the root flag from `/root/root.txt`.

## Reflection

This room taught me how powerful misconfigured services can be when paired with overly permissive sudo rules.  
The initial exploit was straightforward, but the privilege escalation required understanding how Fail2Ban works under the hood and how its configuration can be manipulated.

It also reinforced the importance of checking for known CVEs during enumeration and thinking creatively about how to turn limited access into full compromise.

This was a solid challenge for chaining vulnerabilities and practicing real-world escalation techniques.


