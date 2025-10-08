---
title: DNS - Domain Name System
description: Names into numbers. The protocol that translates human-friendly addresses into machine-routable destinations.
---

# DNS - Domain Name System

Some protocols move data.  
DNS tells them where to go.  
It is not about content. 
It is about resolution. 
Turning names like `example.com` into IP addresses that machines can understand.

---

## What this page covers

- What DNS is and what it does  
- How it fits into the TCP/IP stack  
- Where its data comes from  
- How it is structured and queried  
- How it can be abused or defended  
- Tools I use to explore it  

This page is my reference for understanding DNS 
as a resolution protocol, a security target, and a visibility tool.

---

## What DNS Actually Is

DNS is a distributed naming system that maps domain names to IP addresses.  
It allows users to access websites, services, and resources 
using readable names instead of numeric addresses.

DNS is used by:

- Web browsers  
- Email clients  
- Command-line tools  
- Applications and scripts

It is essential for almost every internet-connected action.

---

## How DNS Lives in the TCP/IP Stack

- **OSI Layer**: Application Layer (Layer 7)  
- **Transport**: Usually UDP (port 53), sometimes TCP for large queries  
- **Flow**:
  - Client sends a DNS query to a resolver  
  - Resolver contacts authoritative servers  
  - Response is returned with the resolved IP

DNS is often the first protocol used in a connection.  
It determines where the rest of the traffic should go.

---

## Where DNS Data Comes From

DNS queries are triggered by:

- User actions (typing a URL, clicking a link)  
- Applications requesting resources  
- System services checking for updates  
- Malware attempting to beacon or exfiltrate

The data is system-generated, but often initiated by user or application behavior.

---

## How DNS Works

- **Query types**:
  - A (IPv4 address)  
  - AAAA (IPv6 address)  
  - MX (mail server)  
  - CNAME (alias)  
  - TXT (miscellaneous data)

- **Resolution flow**:
  - Recursive resolver → Root server → TLD server → Authoritative server  
  - Response is cached for future use

DNS is fast, lightweight, and distributed.  
It relies on caching and hierarchy for performance.

---

## DNS and Security

DNS can be abused in several ways:

- **DNS spoofing**: forging responses to redirect traffic  
- **DNS tunneling**: hiding data in DNS queries for exfiltration  
- **Typosquatting**: registering similar domains to trick users  
- **Cache poisoning**: injecting false records into resolvers

Defenses include:

- DNSSEC for integrity  
- Monitoring and logging queries  
- Blocking known malicious domains  
- Using secure resolvers (DoH, DoT)

---

## Tools I Use to Explore DNS

### `dig`
- Query DNS records manually  
- Example: `dig A example.com`

### `nslookup`
- Resolve domain names and view DNS info  
- Example: `nslookup example.com`

### `dnsenum`
- Enumerate DNS records and subdomains  
- Example: `dnsenum example.com`

These tools help me understand how DNS resolves, 
how it can be manipulated, and how it reveals network structure.

---

## Final Thought

DNS is a map.  
It does not carry data, but it tells data where to go.  
It is the protocol of resolution, of naming, and of direction.

This page is my study of that map.  
Not just how DNS works, but how it can be trusted, abused, and understood.
