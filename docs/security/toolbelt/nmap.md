---
title: Nmap
description: Tool of choice for portscanning.
---

# Nmap

Nmap (Network Mapper) is one of the most widely used tools in cybersecurity and networking. 
It is primarily used for host discovery, port scanning, 
service enumeration, and vulnerability detection. 
Understanding it deeply is crucial 
because it represents the foundation of reconnaissance, 
both in offensive (red team, penetration testing, bug bounty) 
and defensive (blue team, monitoring, threat hunting) contexts.

---

## Why Nmap Matters

- **Red Teaming / Pentesting:** First step in mapping the attack surface.
- **Blue Teaming / Defense:** Helps simulate what attackers see, validate firewall rules, and detect exposures.
- **Bug Bounties:** Identifies open ports and services that may lead to exploitable targets.
- **Network Ops:** Troubleshooting connectivity, inventorying assets, verifying configurations.

Nmap is essentially a *flashlight in the dark network*. 
It doesn’t break in, but it shows you the doors, windows, and weak spots.

---

## Core Functions of Nmap

### 1. Host Discovery

- Identifying live systems in a network.
- Techniques: ICMP echo requests, TCP SYN/ACK, ARP scanning, etc.
- Command example: `nmap -sn 192.168.1.0/24` (ping sweep)

### 2. Port Scanning

- Determining which ports are open/closed/filtered.
- Supports TCP connect, TCP SYN (stealth), UDP scans, etc.
- Example: `nmap -sS -p- target.com` (stealth scan all ports)

### 3. Service & Version Detection

- Identifies what service is running and its version.
- `nmap -sV target.com`

### 4. OS Detection

- Fingerprinting OS based on TCP/IP stack behavior.
- `nmap -O target.com`

### 5. Scripting Engine (NSE)

- Extends Nmap with scripts for discovery, brute force, vulnerability detection, etc.
- Example: `nmap --script vuln target.com`

### 6. Timing & Performance

- Balances stealth and speed.
- `-T0` (paranoid, very slow) → `-T5` (insane, very fast).
- Adjusts retries, parallelism, delays.

### 7. Output Options

- Normal, grepable, XML, JSON (with tools).
- Example: `nmap -oN scan.txt -oX scan.xml target.com`

---

## How to Think About Nmap

### Offensive Perspective (Red Team)

- *Before exploitation comes discovery.*  
- Nmap tells you which targets are worth attention.  
- Combine with other tools (e.g., Gobuster for directories, Nikto for web scanning) after ports/services are known.  

### Defensive Perspective (Blue Team)

- Use Nmap against your own network: *“If I scan like an attacker, what do I see?”*  
- Detect weak firewall rules or unintended exposures.  
- Schedule recurring scans to ensure configurations hold.  

### Bug Bounty Perspective

- Running `nmap -sV --open -p-` against a scope can reveal forgotten services.  
- Combine with service-specific checks (e.g., default creds, outdated versions).  
- Often the bridge between blind reconnaissance and actionable attack vectors.  

---

## Integration with Workflow

- Feed results into SIEM for context.
- Export into formats consumable by tools (Metasploit, Nessus).
- Script automation: run scans nightly or integrate with CI/CD pipelines for devsecops.

---

## Key Takeaway

Nmap isn’t just a scanner—it’s the **first lens** into any unknown network.  
If you don’t master Nmap, you’re blind in both attack and defense.  
Every serious engagement starts with *“What’s alive? What’s open? What’s running?”*  
That is the foundation on which everything else in cybersecurity is built.

## Integration

- [Recon](../playbooks/recon.md)
