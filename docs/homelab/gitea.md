---
title: Gitea
description: My personal Git server and DevOps training ground.
---

# Gitea

Gitea runs inside a lightweight LXC container in my Proxmox cluster.  
It serves as my self-hosted Git server, a place where I can version-control projects, experiment with workflows, and practice enterprise-style DevOps setups. While I also use GitHub, Gitea gives me the independence to run my own infrastructure and build muscle memory for real-world scenarios.

---

## Why Gitea?

At first, I just wanted a safe place to store and manage code without relying solely on third-party services. Over time, I realized Gitea offered much more:  

- **Enterprise training ground** — It allows me to practice CI/CD pipelines, access control, and repo management like an internal development team would.  
- **Redundancy with GitHub** — Even without a full backup strategy yet, GitHub mirrors provide a safety net while I learn proper backup discipline.  
- **Snapshots for recovery** — Proxmox snapshots give me a fallback if something goes wrong, though I plan to move to a more robust backup system in the future.

---

## Access and Security

I’ve set up **SSH key authentication only**, no passwords, across all my machines. My Void Linux laptop and Fedora workstation are both authorized, giving me flexible access.  
If things ever break badly, I can still reach the container directly through the Proxmox web UI console — a safety hatch that ensures I’m never locked out.

---

## Value in My Lab

While I treat it like production in daily use, I view this Gitea instance as a **learning environment** first. It lets me:  

- Build habits for **self-hosted version control**  
- Test real-world practices for **developer collaboration**  
- Gain confidence in **infrastructure management** without risking external systems  

Running Gitea in my lab is less about hosting for others and more about proving to myself that I can run, maintain, and secure such a service — skills directly transferable to enterprise DevOps and cybersecurity work.
