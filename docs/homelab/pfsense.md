---
title: pfSense
description: My virtual firewall – where networking theory meets practice.
---

# pfSense

## Purpose

A dedicated firewall is essential for any secure environment. Since I don’t yet run a separate physical box, I deployed pfSense as a VM on Proxmox. It might not be the “perfect” option, but it gave me a starting point—and more importantly, a lot of lessons in networking, virtualization, and operational resilience.

## Lessons Learned

- **Networking fundamentals**: Clear separation of WAN vs. LAN, NAT in practice, and the difference between stateful and stateless firewalls.  
- **Firewall rules**: How small misconfigurations can break all connectivity, and how careful planning is required to avoid accidental lockouts.  
- **Troubleshooting**: Handling numerous connectivity issues while learning the pfSense interface.  
- **Proxmox passthroughs**: Experimenting with PCI passthrough for network cards, including painful lockouts that taught the importance of backup access methods.  
- **Operational insight**: Understanding why enterprises often keep “temporary” insecure access paths—because they’re left behind during setup and never removed.  

## Setup

- Running pfSense as a FreeBSD VM inside Proxmox.  
- Access redundancy: Proxmox web UI console serves as a fallback when network access fails.  
- Snapshots provide basic resilience, though no dedicated backup system is yet in place.  

## Value

Right now, pfSense provides a baseline of security and—just as importantly—valuable logs to analyze. The real power will come once VLANs are implemented and logs are aggregated into a centralized system for deeper analysis. For me, pfSense is both a protective layer and a training tool.  

## Next Steps

- Implement centralized logging and visualization (Grafana or similar).  
- Build towards a full intrusion detection setup.  
- Eventually replace the VM with a dedicated hardware firewall for improved reliability and performance.  

## Resilience

Snapshots allow quick rollbacks, but long-term, I need to establish a proper backup and recovery strategy. pfSense is training wheels for my network security—but strong enough to carry me forward.  
