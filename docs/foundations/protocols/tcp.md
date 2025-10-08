---
title: TCP - Transmission Control Protocol
description: Reliable, ordered, and connected. The protocol that turns packets into conversations.
---

# TCP - Transmission Control Protocol

Some protocols send data.  
TCP makes sure it arrives.  
It is not about speed. It is about reliability, order, and connection.  
TCP is the foundation beneath many application protocols, from HTTP to SSH.

---

## What this page covers

- What TCP is and what it does  
- How it fits into the TCP/IP stack  
- How it handles reliability and flow  
- How it is structured and used  
- How it can be abused or defended  
- Tools I use to explore it  

This page is my reference for understanding TCP 
as a transport protocol, a security surface, and a design model.

---

## What TCP Actually Is

TCP is a connection-oriented transport protocol.  
It ensures that data sent between two devices arrives reliably, in order, and without duplication.  
It handles retransmissions, acknowledgments, and flow control.

TCP is one of two protocols that almost all others 
on higher levels of the OSI Model use. 
It is foundametal to the core funktionallity of the internet. 

---

## How TCP Lives in the TCP/IP Stack

- **OSI Layer**: Transport Layer (Layer 4)  
- **Encapsulation**:
  - TCP segments are wrapped in IP packets  
  - IP packets are sent across the network  
- **Ports**: TCP uses port numbers to identify services  
  - Example: Port 80 for HTTP, Port 22 for SSH

TCP is the layer between IP and application protocols.  
It provides a reliable channel for higher-level communication.

---

## How TCP Works

- **Three-way handshake**:
  - SYN → SYN-ACK → ACK  
  - Establishes a connection before data is sent
- **Sequence numbers**:
  - Track the order of bytes  
  - Ensure correct reassembly
- **Acknowledgments**:
  - Confirm receipt of data  
  - Trigger retransmission if missing
- **Flow control**:
  - Adjusts data rate based on receiver capacity
- **Congestion control**:
  - Detects and reacts to network congestion

TCP is designed to be robust, even over unreliable networks.

---

## TCP and Security

TCP can be abused in several ways:

- **Port scanning**: attackers probe open TCP ports  
- **Session hijacking**: intercepting or injecting into active connections  
- **SYN floods**: overwhelming a server with half-open connections  
- **Reset attacks**: sending forged RST packets to kill connections

Defenses include:

- Firewalls and intrusion detection  
- Rate limiting and SYN cookies  
- Encryption at higher layers (TLS over TCP)

---

## Tools I Use to Explore TCP

### `netstat`
- View active TCP connections  
- Example: `netstat -tn`

### `tcpdump`
- Capture and analyze TCP traffic  
- Example: `tcpdump tcp port 80`

### `nmap`
- Scan for open TCP ports  
- Example: `nmap -sT 10.10.10.1`

These tools help me understand how TCP behaves, how it connects, and how it can be monitored or attacked.

---

## Final Thought

TCP is a conversation.  
It listens, responds, and adapts.  
It is the protocol that turns raw packets into meaningful exchange.

This page is my study of that exchange.  
Not just how TCP works, but how it builds trust, handles failure, and supports the protocols above it.
