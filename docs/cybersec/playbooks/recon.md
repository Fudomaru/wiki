---
title: Recon
description: Easy to follow Rulesets, helping me to go through security processes setp by step, without missing anything. 
---

## Basic Nmap Recon

### Objective:

Perform a full reconnaissance scan on a target host with minimal noise. 

### Tools Needed: 

- [Nmap](/wiki/cybersec/toolbelt/nmap)
- Basic shell access

### Steps:

1. Identify target IP: `whois`, `dnsrecon`, or `host`
2. Run stealth scan:  
    `nmap -sS -Pn -T2 -p- TARGET`
3. Service version detection:  
    `nmap -sV -sC -p PORTS_DETECTED TARGET`
4. Analyze output

### Results:

Gain an actionable map of the exposed services without triggering IDS.
