---
title: FTP - File Transfer Protocol
description: Moving files across networks. The protocol that sends and receives data without a browser.
---

# FTP - File Transfer Protocol

Some protocols move messages.  
FTP moves files.  
It is not about content negotiation or rendering. 
It is about uploading, downloading, and managing files between systems.

---

## What this page covers

- What FTP is and what it does  
- How it fits into the TCP/IP stack  
- Where its data comes from  
- How it is structured and used  
- How it can be abused or defended  
- Tools I use to explore it  

This page is my reference for understanding FTP 
as a file protocol, a legacy surface, and a transfer mechanism.

---

## What FTP Actually Is

FTP is a protocol used to transfer files between a client and a server.  
It supports uploading, downloading, renaming, deleting, and listing files on remote systems.

FTP is used by:

- Web developers  
- System administrators  
- Automated scripts  
- Legacy applications

It is one of the oldest and most widely supported file transfer protocols.

---

## How FTP Lives in the TCP/IP Stack

- **OSI Layer**: Application Layer (Layer 7)  
- **Transport**: TCP (port 21 for control, dynamic ports for data)  
- **Flow**:
  - Client connects to server on port 21  
  - Commands are sent over the control channel  
  - Files are transferred over a separate data channel

FTP can operate in active or passive mode, depending on how connections are initiated.

---

## Where FTP Data Comes From

FTP transfers:

- User-uploaded files  
- System-generated logs or backups  
- Web content and assets  
- Configuration files

The data is often user-controlled, but can also be automated or scripted.

---

## How FTP Works

- **Authentication**:
  - Username and password  
  - Anonymous access (optional)

- **Commands**:
  - `LIST`, `RETR`, `STOR`, `DELE`, `MKD`, `RMD`

- **Modes**:
  - Active: server connects back to client  
  - Passive: client initiates both connections

FTP is simple but lacks modern security features.

---

## FTP and Security

FTP can be abused in several ways:

- **Credential sniffing**: passwords sent in plaintext  
- **Anonymous access**: unintended public exposure  
- **Directory traversal**: accessing restricted paths  
- **Data interception**: unencrypted file transfers

Defenses include:

- Using FTPS or SFTP instead  
- Disabling anonymous access  
- Restricting directory permissions  
- Monitoring and logging activity

---

## Tools I Use to Explore FTP

### `ftp`
- Basic command-line FTP client  
- Example: `ftp ftp.example.com`

### `nmap`
- Scan for FTP and test for anonymous login  
- Example: `nmap -p 21 --script ftp-anon example.com`

These tools help me understand how FTP behaves, 
how it transfers files, and how it can be secured or abused.

---

## Final Thought

FTP is a courier.  
It does not interpret files, but it moves them.  
It is the protocol of transfer, of commands, and of exposure.

This page is my study of that courier.  
Not just how FTP works, but how it can be hardened, replaced, and understood.
