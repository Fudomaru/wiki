---
title: SMB - Server Message Block
description: Sharing files and printers. The protocol that connects Windows systems and exposes resources.
---

# SMB - Server Message Block

Some protocols move data.  
SMB shares it.  
It is not about browsing or messaging. 
It is about accessing files, printers, and services across a network.

---

## What this page covers

- What SMB is and what it does  
- How it fits into the TCP/IP stack  
- Where its data comes from  
- How it is structured and used  
- How it can be abused or defended  
- Tools I use to explore it  

This page is my reference for understanding SMB 
as a sharing protocol, a legacy surface, and a common target.

---

## What SMB Actually Is

SMB is a protocol used to share files, printers, and other resources between systems.  
It is heavily used in Windows environments 
and supports authentication, access control, and remote management.

SMB is used by:

- Windows clients and servers  
- Network-attached storage  
- Domain controllers  
- Pentesters and attackers

It is often exposed in internal networks and sometimes externally.

---

## How SMB Lives in the TCP/IP Stack

- **OSI Layer**: Application Layer (Layer 7)  
- **Transport**: TCP (port 445)  
- **Flow**:
  - Client connects to server  
  - Authenticates and requests resources  
  - Server responds with access or denial

Older versions used NetBIOS over port 139.  
Modern SMB uses direct TCP on port 445.

---

## Where SMB Data Comes From

SMB shares:

- User files and folders  
- System configuration and logs  
- Printer jobs and device info  
- Authentication tokens and metadata

The data is often user-generated or system-managed.

---

## How SMB Works

- **Authentication**:
  - NTLM or Kerberos  
  - Guest access (optional)

- **Features**:
  - File and printer sharing  
  - Remote procedure calls  
  - Named pipes and inter-process communication

SMB is complex and deeply integrated into Windows.

---

## SMB and Security

SMB can be abused in several ways:

- **Anonymous access**: exposing sensitive shares  
- **Credential reuse**: using stolen hashes  
- **Remote code execution**: via vulnerabilities like EternalBlue  
- **Lateral movement**: pivoting across systems

Defenses include:

- Disabling SMBv1  
- Restricting share permissions  
- Using strong authentication  
- Monitoring for unusual access

---

## Tools I Use to Explore SMB

### `smbclient`
- Access SMB shares from Linux  
- Example: `smbclient //host/share -U user`

### `enum4linux`
- Enumerate SMB shares and user info  
- Example: `enum4linux -a host`

### `nmap`
- Scan for SMB and test for vulnerabilities  
- Example: `nmap -p 445 --script smb-enum-shares,smb-os-discovery host`

These tools help me understand 
how SMB shares are exposed, 
how they can be accessed, 
and how they can be secured or abused.

---

## Final Thought

SMB is a window.  
It does not serve content, but it opens access.  
It is the protocol of sharing, of authentication, and of exposure.

This page is my study of that window.  
Not just how SMB works, but how it can be hardened, abused, and understood.
