---
title: Pi-hole
description: My DNS sinkhole and first step into network-wide control.
---


# Pi-hole

Pi-hole runs as an LXC on my Proxmox host. 
It’s tiny—just 512 MB RAM, but it has been running without issues. 
The container is Ubuntu 22.04 with kernel 6.8.12-13-pve, 
updated and managed mostly over SSH rather than the Web UI.  

## Purpose

Pi-hole is my single DNS server. 
pfSense points to it and hands it out over DHCP, 
making it the authoritative DNS for every device on my network. 
It also resolves the internal names of my homelab machines, 
giving my lab the feel of a self-contained network 
rather than just a collection of boxes.  

This was my first deliberate “production” service in the lab. 
Initially, it was mostly an exercise, adblocking was familiar territory, 
and I wanted a stepping stone toward something bigger. 
My plan is to pair it with **Unbound**, 
so I can move away from forwarding to Cloudflare 
and instead perform my own recursive DNS resolution.  

## Operation

- Pi-hole does not handle DHCP, only DNS.  
- Default blocklist is active, but I don’t spend time tweaking it, since that isn’t the focus.  
- Updates are performed over SSH. I’ve begun automating this process.  
- I almost never touch the Web UI.  

Longer term, Pi-hole will feed into a **logging/analytics pipeline**. 
Owning my DNS means I own the query data, 
which is invaluable for monitoring, research, and building detection capabilities.  

## Lessons Learned

Running Pi-hole taught me how DNS actually behaves at scale. 
I’ve seen firsthand how much traffic flows through DNS 
and how caching layers propagate changes. 
I now understand how records move through the hierarchy 
until consistency is reached, 
and how modern DNS resolvers deal with latency and reliability.  

I also dug into DNS record types, 
name server delegation, and the subtle mechanics of resolution. 
One surprising realization: 
much of so-called *“geo-blocking”* is simply DNS manipulation.
There’s no deeper enforcement, just traffic pointed elsewhere.  

Pi-hole made DNS real, not just theoretical. 
It turned an abstract system into something I can bend, test, and own.  

