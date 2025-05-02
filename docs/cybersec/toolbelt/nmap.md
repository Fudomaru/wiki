---
title: Nmap
description: Tool of choice for portscanning.
---

# Nmap

## What it is

Network mapper used for host descovery and port scanning. 

## Core Usage

- `-sS`: SYN scan
- `-p-`: all ports
- `-A` : aggressive mode

## Examples

`nmap -sS -p- -T4 TARGET`

### Used in

- [Recon](/wiki/cybersec/playbooks/recon)