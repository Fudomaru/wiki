---
title: Recon
description: Easy to follow Rulesets, helping me to go through Recon processes step by step, without missing anything. 
---


# Inital Target Scope

Define what the target is. Find the domains, subdomains, IP range. What Infrastructure do they use, what company profiles are attackable and in scope. This sets the boundaries and makes sure it is clear where the recon begins and where it ends.  

### Engagement Type

First it is essential to clearly define what are you doing your recon for. What is the goal. 
You need to define if you are doing a CTF, a Pentest or if you are going for a bug bounty.

### Rules of Engagement (RoE)

Take a detailed look in the rules you are to follow. If something is not clear, it needs to be adressed.  
Is social engineering in scope?  
Are descrutive payloads prohibited?  
Can you fuzz login forms?  
What are the time restrictions?  
It is important that everything is documented and everyone involved understands the rules.  

### In Scope

It need to be clearly defined. What domains, subdomains, etc. can be attackt. What about third-party services? You have to be very clear. 

### Out of Scope

You also need to define specific services, IPs, domains that are not to be touched. Partners, shared infrastructure or production critical services.  

### Success Criteria

Also really important to define. You want to know when you are done, when you have done your job. It should be clear, that no system is ever completly save, it always depends a multitude of things if and when it will be owned. But what is actually needed to count it as success. 

### Logistics & Authorization

Which accounts are authorized. What about VPN, access tokes. You need a explicit permission to go through with it. What is your point of contact if anything happens. Do you have a "get out of jail" card? 

!!! warning
    No moving forward until this part is airtight. 

---

---
# Passis Recon

!!! info "Definition"

    Collecting information without touching the target. Stay a ghost by watching, not touching. The rule is: No traffic hits their servers. 

## OSINT (Open-Source Intelligence)

Tool and techniques:  

- crt.sh, CertSpotter, Censys, Shodan, ZoomEye, Hunter.io
- Employee footprinting  (LinkedIn, GitHub, Twitter)
- WHOIS & DNS history
- Archive.org (Wayback Machine)

Trying to extract all public data about the target without making direct contact. 
Your Building the dossier befor stepping on the field. 

## Subdomain Enumeration

Tools: 

- Amass (passive mode), Subfinder, Assetfinder, Findomain 

Sources:

- Certificate Transparency Logs
- Public DNS data aggregation (VirusTotal, dns.bufferover.run) 

This is to find potentail subdomains without touching the target. Create a list of possiblities to make the next stepps easier for yourself. 

## DNS Enumeration 

- Passis DNS record discovery 
- Zone history (SecurityTrails, PassiveTotal)

Helps to understand the infrastruture layout and potentail service endpoints. 

## Technologie Figerprinting

Tools: 

- Wappalyzer
- BuiltWith
- Netcraft
- WhatWeb

You can start to understand the stack with the used languages, frameworks, CMS and libraries used. 

## Codebase & Asset Hunting

- You can look for public GitHub repos by target name 
- Identify exposed .git, .env, .bak, etc. in the Waybackmashine 
- also looking for though Pastbin, Gist or leaks from your target can be helpful 

Here it is not unlikly to come across old credentials, forgotten endpoints or internal code what helps you extract how things are done to find the logic and structure behind it. 

## Thrid-Party Enumeration 

Figuring out about third partries they use. 

- SSO provider
- Marketing tools
- used CDN
- Library dependencies

Mapping dependencies and weak links can help you find differenct attack vectors. 

## Notes to take:

You need to start building you documentation here.  
Here is what you write down:  
- Domains
- Subdomains
- Tech stacks
- Notable files/ leaks

Also you should start making a inital map about the internal sturcture.  
This helps you to fit everything else you find into its place.  

## Outcome

By the end of this stage this is what you should have:  

- A list of target domains/ subdomains
- Public known infrastructure
- Highlevel service stack
- Potentail weak links from external assets
- Initail attack surface mindmap


---
# Active Recon 

!!! info "Definition"
    
    Here you are interacting with the target's Infrastructure directly. You are scanning and probing. Since you are sending packages, here you are leaving fingerprints and should be aware of that. 


## Port scanning

- Discovering open ports and determine their state
- Understanding exposed surface area
- Tools: [nmap](/wiki/cybersec/toolbelt/nmap/), rustscan, masscan

## Service Enumation

- Idenfy running services and versions
- Fingerprint protocols, grab banners, test endpoints
- Tools: nmap, netcat, telnet, whatweb, httpx

## Authentication & Access Points

- Scan for login portals acreoss services: SSH, FTP, RDP, Telnet
- Identify entry points that may lead to further attack vectors
- Tools: hydra, ncrack, meduse 

## Info Leaks

- Interact with services to provoke behavior to test for leaks, misconfigs, or sloppy responses 
- Think SMPT, VRFY, FTP misconfigs or SSH MOTD leaks
- Tools: netcat, curl, openssl

## Notes to take: 

Document everything you find. Put the new finds in the old documentation, marke the still active subdomains, fill out your map of the infrastructure. Complete with where you find which ports and services. 

## Outcome

By the endof this stage this is what you should have: 

- List of reachable hosts with open ports and active services
- Serivce versions with potential weak configs
- Authentication endpoints and any possible misconfigurations
- A prioritized attack surface with targets worth deeper inspection 
- Clear specification what need Web Recon to start the next phase with. 

---
# Web Recon 

Digging deep into web services. There is normal a lot to find. From hidden dirctories, files, over headers used. Find the login portals. Specifiy where attack surface is. 

#### Tools to use:

- ffuf
- dirsearch
- robots.txt
- headers
- wappalyzer
- endpoints

---
# Enumeration

Here you want to see what is used. Finding every service and protocol they use. You need to provoke, record and understand every response. 

#### Tools to use:

- SMB shares
- HTTPS services
- FTP
- DNS zone transfer attempts
- SNMP


---
# Vulnerability Enumeration

Now that you have loads of information, it is time to look where you can actually get somewhere. Look for known vulnerabilities for services they use, use vuln scanner and look though CVEs. Match exposed services with weaknesses. 

#### Tools to use:

- Nikto
- Searchsploit
- CVE search

---
# Documentation 

Most underated weapon. Espacially for reacon. With down everything you have. Go over your notes. Make them usefull. You need to be able to find everything you wrote down in an instand. 
