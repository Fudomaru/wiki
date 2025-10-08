---
title: ARP - Address Resolution Protocol
description: Translating IP into MAC. The protocol that bridges logical addressing with physical delivery.
---

# ARP - Address Resolution Protocol

Some protocols route packets.  
ARP finds where to send them.  
It is not about moving data across the internet. 
It is about finding the next hop inside a local network.

---

## What this page covers

- What ARP is and what it does  
- How it fits into the TCP/IP stack  
- Where its data comes from  
- How it is structured and used  
- How it can be abused or defended  
- Tools I use to explore it  

This page is my reference for understanding ARP 
as a protocol, a local mechanism, and a security concern.

---

## What ARP Actually Is

ARP is a protocol used to map IP addresses to MAC addresses on a local network.  
When a device wants to send data to another device 
on the same subnet, it needs the recipient’s MAC address.  
ARP asks the question: “Who has this IP?” and 
waits for the answer: “I do. Here’s my MAC.”

It is essential for local delivery.  
Without ARP, IP packets would not know where to go on Ethernet.

---

## How ARP Lives in the TCP/IP Stack

- **OSI Layer**: Data Link Layer (Layer 2)  
- **Transport**: ARP is not encapsulated in TCP or UDP  
- **Flow**:
  - Device sends an ARP request as a broadcast frame  
  - All devices on the subnet receive it  
  - The device with the matching IP replies with its MAC address  
  - The sender stores the result in its ARP cache

ARP is used only within local networks.  
Routers handle IP routing between networks, but ARP handles delivery inside them.

---

## Where ARP Data Comes From

ARP requests are triggered by:

- Operating systems when sending packets to a new IP  
- Applications that initiate network connections  
- Manual commands like `ping`, `curl`, or `ssh`  
- Network tools that scan or probe devices

The data is system-generated.  
It is not user input, but it can be influenced by user actions that cause network traffic.

---

## How ARP Is Structured

- ARP messages contain:
  - Sender IP and MAC  
  - Target IP and MAC (empty in requests)  
- ARP replies fill in the missing MAC address  
- Devices maintain an **ARP cache** to avoid repeated lookups

---

## ARP and Security

ARP has no authentication.  
Any device can send ARP replies, even if unsolicited.  
This makes it vulnerable to:

- **ARP Spoofing**: attacker sends fake replies to poison caches  
- **Man-in-the-Middle**: attacker intercepts traffic by impersonating gateway  
- **Denial of Service**: attacker redirects traffic to invalid MACs

Defenses include:

- Static ARP entries  
- ARP inspection on switches  
- VLAN segmentation  
- Monitoring tools to detect anomalies

---

## Tools I Use to Explore ARP

### `arp`
- View and manage the local ARP cache  
- Example: `arp -a`

### `arpspoof` (from dsniff)
- Send forged ARP replies to redirect traffic  
- Example: `arpspoof -i eth0 -t victimIP gatewayIP`

### `ettercap`
- Perform ARP poisoning and MITM attacks  
- Example: GUI or CLI-based targeting

These tools help me understand how ARP works, how it fails, and how it can be manipulated.

---

## Final Thought

ARP is simple.  
That is what makes it powerful — and dangerous.  
It is a protocol of trust, assuming that every reply is honest.  
But in security, trust without verification is a risk.

This page is my study of that risk.  
Not just how ARP works, but how it can be abused, defended, and understood.
