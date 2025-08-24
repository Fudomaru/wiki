---
title: Proxmox Hypervisor
description: The machine that carries my entire lab on its back.
---

# Proxmox Hypervisor

I run my homelab on a single Proxmox hypervisor. 
It’s not glamorous, but it works, 
and that balance between budget, efficiency, 
and ambition feels a lot like running a small company. 
Every decision costs something, and I have to make it count.

## Why Proxmox?

When I started, I knew I didn’t want to base my lab on Windows. 
My goal is to live in a Linux world, 
and Proxmox gave me a way to build on that foundation. 
It’s open-source, free for my use case, and backed by a strong community. 
More importantly: it forced me to *choose*. 
At some point you stop researching and commit to a tool, and Proxmox became mine.

## Hardware

- **CPU**: Intel N95, 4 cores @ 3.40GHz  
- **RAM**: 16GB  

Nothing fancy, but it’s more than enough to virtualize multiple systems at once. 
I’m still amazed at how much I can run on this single box.

## Networking

One of the decisions I’m proud of was giving this machine dual physical NICs. 
I wanted WAN and LAN to be separated in hardware, not just in configuration. 
Proxmox itself doesn’t touch those NICs directly, 
but instead, I pass them through via PCI passthrough to my pfSense VM. 
Proxmox lives on a virtual NIC connected to the LAN side, 
which keeps management traffic isolated and feels like a proper enterprise setup.

## Administration

My administrative practices are still developing, 
but I already try to keep things disciplined:

- **Snapshots**: I take weekly snapshots of the important VMs. 
                 Nothing changes much week to week, so this keeps me covered.  

- **Backups**: I’m still working on a real backup strategy. 
               Snapshots are not backups, and I know I need more resilience.  
               
- **Philosophy**: Virtualization-first. 
                  No single-use machines, no hardware locked into one function 
                  if I can help it.  

## Reflections

This setup is both a struggle and a triumph. 
On one hand, everything rests on a single box, 
but if it goes down, my entire lab goes dark. 
On the other, the fact that this one little machine can run so much is incredible. 
It’s taught me to think like a business: 
stretch every resource, make trade-offs, and keep moving forward.

