---
title: IP - Internet Protocol
description: The global addressing system. The protocol that gives every packet a destination.
---

# IP - Internet Protocol

Some protocols build conversations.  
IP builds the roads they travel on.  
It is not about the message. 
It is about the address on the envelope.

---

## What this page covers

- What IP is and what it does
- How it fits into the TCP/IP stack
- Where its data comes from
- How it is structured and used
- How it can be abused or defended
- Tools I use to explore it

This page is my reference for understanding IP 
as the internet's postal service, a routing mechanism, and a fundamental layer of communication.

---

## What IP Actually Is

The Internet Protocol is the principal communications protocol for relaying datagrams across network boundaries. 
Its primary function is to deliver packets from a source host to a destination host based on their addresses.

IP is the core of the internet. 
It’s what makes inter-networking possible, 
allowing different networks to connect and exchange data globally.

---

## How IP Lives in the TCP/IP Stack

- **OSI Layer**: Network Layer (Layer 3)
- **Encapsulation**:
  - IP wraps segments from the Transport Layer (like TCP or UDP).
  - It is, in turn, wrapped by frames from the Data Link Layer (like Ethernet).
- **Flow**:
  - The IP layer takes a data segment and adds a header containing source and destination IP addresses.
  - Routers across the internet read this header to forward the packet to its final destination.

IP is connectionless, meaning it sends packets without first creating a connection. 
It offers no guarantees of delivery, order, or integrity; 
that is the job of higher-level protocols like TCP.

---

## Where IP Data Comes From

The data payload of an IP packet comes from the Transport Layer (Layer 4). 
IP itself does not generate user data. 
It simply takes the segments provided by TCP or UDP 
and attaches the necessary addressing information to route them.

---

## How IP Is Structured

- **IP Header**: This contains all the routing information, including:
  - **Source IP Address**: Where the packet came from.
  - **Destination IP Address**: Where the packet is going.
  - **Time To Live (TTL)**: A counter that prevents packets from looping endlessly.
  - **Protocol**: A number that identifies the next-level protocol (e.g., 6 for TCP, 17 for UDP).
- **Versions**:
  - **IPv4**: The legacy 32-bit addressing scheme (e.g., `192.168.1.1`).
  - **IPv6**: The modern 128-bit addressing scheme, created to solve IPv4 address exhaustion.

IP works on a "best-effort" delivery model. It does its best to deliver the packet but doesn't handle retransmissions for lost packets.

---

## IP and Security

IP itself offers no encryption or authentication, which exposes it to several risks:

- **IP Spoofing**: An attacker forges the source IP address of a packet to hide their identity or impersonate another system.
- **Packet Sniffing**: An attacker on the same local network can intercept and read unencrypted IP packets.
- **Denial of Service (DoS)**: Attackers can use fragmentation attacks or IP address spoofing to overwhelm a target system.

Defenses include:

- **IPsec**: A suite of protocols that provides encryption and authentication at the IP layer (often used in VPNs).
- **Firewalls**: To filter incoming and outgoing packets based on IP addresses and ports.
- **Ingress/Egress Filtering**: Network edge routers check if packets have a legitimate source IP address, helping to prevent spoofing.

---

## Tools I Use to Explore IP

### `ping`
- Sends ICMP packets to an IP address to test reachability and latency.
- Example: `ping 8.8.8.8`

### `traceroute`
- Traces the route that packets take to a destination IP, showing each router (hop) along the way.
- Example: `traceroute 1.1.1.1`

### `tcpdump` / `wireshark`
- Powerful packet analyzers that can capture and display IP packet headers and payloads for deep inspection.
- Example: `tcpdump host 8.8.8.8`

These tools help me see how IP packets move, where they go, and what information they carry.

---

## Final Thought

IP is the postal service of the internet.  
It doesn't care what is in the envelope, only that it has an address to deliver to.  
It is the protocol of addressing, of routing, and of global connection.

This page is my study of that system.  
Not just how IP works, but how it routes the world's data and where its trust can be broken.
