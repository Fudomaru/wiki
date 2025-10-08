---
title: SNMP - Simple Network Management Protocol
description: Monitoring and managing devices through structured queries. A protocol that speaks the language of infrastructure.
---

# SNMP - Simple Network Management Protocol

Some protocols move data.  
SNMP moves insight.  
It is not about streaming content or loading websites. It is about asking devices how they are doing, and sometimes telling them what to do.

---

## What this page covers

- What SNMP is and what it does  
- How it fits into the TCP/IP stack  
- Where its data comes from  
- How it is structured and queried  
- How it can be misconfigured or abused  
- Tools I use to explore it  

This page is my reference for understanding SNMP as a protocol, a security risk, and a tool for visibility.

---

## What SNMP Actually Is

SNMP is a protocol used to monitor and manage network-connected devices.  
It allows administrators to query system information, receive alerts, and even change configuration remotely.  
Devices that support SNMP include routers, switches, servers, printers, and IoT hardware.

SNMP is designed to be lightweight and extensible.  
It uses a structured database called the Management Information Base (MIB) to expose internal data.

---

## How SNMP Lives in the TCP/IP Stack

- **OSI Layer**: Application Layer (Layer 7)  
- **Transport Protocol**: UDP  
- **Ports**:  
  - Port 161 for queries  
  - Port 162 for traps (unsolicited alerts)

SNMP data is wrapped in a UDP datagram, which is then encapsulated in an IP packet.  
The protocol does not encrypt data by default in versions 1 and 2c.  
SNMPv3 adds authentication and encryption, but is more complex to configure.

---

## Where SNMP Data Comes From

SNMP agents collect data from the device itself.  
This includes:

- System uptime  
- Installed software  
- Interface status  
- CPU and memory usage  
- Configuration values

The data is system-generated and exposed through the MIB structure.  
Attackers can send crafted SNMP requests to extract or manipulate this data.

---

## How SNMP Is Structured

### MIB - Management Information Base

- A standardized tree of readable device data  
- Written in ASN.1 format  
- Each data point is identified by an Object Identifier (OID)

### OID - Object Identifier

- A numeric path to a specific data point  
- Example: `.1.3.6.1.2.1.1.1.0` might point to system description  
- Longer OIDs represent deeper or more specific data

---

## SNMP Versions and Security

| Version | Security | Notes |
|--------|----------|-------|
| SNMPv1 | None | Plaintext, no authentication or encryption |
| SNMPv2c | None | Adds features, still plaintext |
| SNMPv3 | Strong | Adds authentication and encryption, more complex setup |

SNMPv1 and v2c use **community strings** as access tokens.  
These are often set to defaults like `public` or `private` and transmitted in plaintext.  
SNMPv3 uses usernames, passwords, and encryption keys.

---

## Dangerous Configurations

- `rwuser noauth`: full access without authentication  
- `rwcommunity <string> <IP>`: unrestricted access from any IP  
- These settings expose the full MIB tree and allow remote configuration

Misconfigured SNMP can leak sensitive system data or allow unauthorized changes.

---

## Tools I Use to Explore SNMP

### `snmpwalk`
- Recursively queries OIDs from a target  
- Example: `snmpwalk -v2c -c public 10.10.10.1`

### `onesixtyone`
- Brute-forces community strings  
- Example: `onesixtyone -c community.txt -i targets.txt`

### `braa`
- Brute-forces OIDs once a valid community string is known  
- Example: `braa public@10.10.10.1:.1.3.6.*`

These tools help me enumerate SNMP services, discover misconfigurations, and understand device internals.

---

## Final Thought

SNMP is quiet.  
It does not stream or sync.  
It listens, reports, and sometimes reacts.  
When configured well, it is a powerful tool for visibility.  
When configured poorly, it is a window into the system for anyone who knows how to ask.

This page is my study of that window.  
Not just how to open it, but how to secure it, and how to understand what it reveals.
