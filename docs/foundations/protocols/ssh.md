---
title: SSH - Secure Shell
description: Remote control with encryption. The protocol that opens a secure terminal across the network.
---

# SSH - Secure Shell

Some protocols send data.  
SSH sends control.  
It is not about browsing or messaging. 
It is about securely accessing and managing remote systems.

---

## What this page covers

- What SSH is and what it does  
- How it fits into the TCP/IP stack  
- Where its data comes from  
- How it is structured and used  
- How it can be abused or defended  
- Tools I use to explore it  

This page is my reference for understanding SSH 
as a remote access protocol, a secure channel, and a command interface.

---

## What SSH Actually Is

SSH is a protocol used to securely access remote systems over a network.  
It provides encrypted terminal sessions, file transfers, and tunneling capabilities.

SSH is used by:

- System administrators  
- Developers  
- Automation scripts  
- Security professionals

It replaces insecure protocols like Telnet and rlogin.

---

## How SSH Lives in the TCP/IP Stack

- **OSI Layer**: Application Layer (Layer 7)  
- **Transport**: TCP (port 22)  
- **Flow**:
  - Client initiates a connection to port 22  
  - Authentication and key exchange occur  
  - Encrypted session is established

SSH uses asymmetric cryptography for authentication and symmetric encryption for session data.

---

## Where SSH Data Comes From

SSH transmits:

- User commands and input  
- File transfers via SCP or SFTP  
- Tunneling data for port forwarding  
- System responses and logs

The data is user-generated and interactive.

---

## How SSH Works

- **Authentication**:
  - Password-based  
  - Public key-based  
  - Multi-factor options

- **Features**:
  - Remote shell access  
  - Secure file transfer  
  - Port forwarding and tunneling

SSH is flexible and secure, but depends on proper configuration.

---

## SSH and Security

SSH can be abused in several ways:

- **Brute-force attacks**: guessing passwords  
- **Key theft**: stolen private keys  
- **Misconfigured access**: overly permissive logins  
- **Tunneling misuse**: hiding malicious traffic

Defenses include:

- Using key-based authentication  
- Disabling root login  
- Enforcing strong passwords  
- Monitoring login attempts

---

## Tools I Use to Explore SSH

### `ssh`
- Connect to remote systems  
- Example: `ssh user@host`

### `nmap`
- Scan for SSH and test for weak configurations  
- Example: `nmap -p 22 --script ssh-auth-methods host`

### `hydra`
- Brute-force SSH credentials  
- Example: `hydra -l user -P wordlist.txt ssh://host`

These tools help me understand how SSH connects, 
how it authenticates, and how it can be hardened or attacked.

---

## Final Thought

SSH is a doorway.  
It does not serve content, but it opens control.  
It is the protocol of access, of encryption, and of trust.

This page is my study of that doorway.  
Not just how SSH works, but how it can be secured, abused, and understood.
