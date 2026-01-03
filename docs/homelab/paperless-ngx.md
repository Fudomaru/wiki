---
title: Paperless-ngx
description: Bringing order to my personal digital documents.
---

# Paperless-ngx

Paperless-ngx is my solution for tackling personal document sprawl. 
It's a self-hosted document management system 
designed to scan, index, and archive my personal letters and correspondences, 
turning chaotic piles of paper and 
disorganized digital files into an easily searchable and well-structured archive. 
It serves as a crucial step towards digitalizing 
and organizing parts of my life that extend beyond 
the homelab's infrastructure itself.

---

## Why Paperless-ngx?

My primary motivation for adopting Paperless-ngx 
was a need to bring order to my personal documentation.
Being a bit unorganized in this area, 
I recognized the significant value in having 
an accessible, searchable repository 
for all personal letters and correspondences. 
I specifically chose Paperless-ngx for several key reasons:

*   **Community Support:** 
Its widespread adoption within the homelab community 
provides a valuable resource for troubleshooting and new ideas.
*   **Intuitive UI:** 
I found the user interface to be straightforward and effective, 
allowing for an easy entry point into document management.
*   **Data Ownership & Portability:** 
Crucially, Paperless-ngx stores documents separately from its database, 
ensuring that I retain direct access to all my files 
even without the application running. 
This aligns perfectly with my philosophy 
of control and data independence.

---

## Implementation & Integration

To integrate Paperless-ngx into my homelab, 
I deployed it within a dedicated, small LXC container. 
This container runs Paperless-ngx via Docker, 
allowing for efficient resource usage and easy management.

### Storage and Backup Architecture

A core design principle for this service was robust data handling:

*   **Direct Mounted Storage:** 
All Paperless-ngx data (documents and database) 
has storage mounted directly onto the LXC container.
*   **Proxmox Host Storage:** 
This mounted storage resides on the Proxmox host 
where the LXC is running.
*   **PBS Integration:** 
Proxmox Backup Server (PBS) flawlessly backs up the entire LXC container, 
including its mounted storage.
*   **Redundancy:** 
These PBS backups are then duplicated 
to a second physical machine for local redundancy.
*   **Off-site Backup:** 
For ultimate disaster recovery, a complete backup of this data 
is performed via BorgBackup to a private NAS located at another physical location. 
This multi-layered approach ensures the longevity and safety of my digital archives.

### NGINX Integration: A Standard Operating Procedure

Integrating a new service like Paperless-ngx 
into my network follows a repeatable and disciplined procedure, 
using NGINX as the central gateway. 
This serves as a perfect example of that process:

1.  **DNS Entry:** 
First, a new DNS record is created in my Pi-hole instance. 
A subdomain (e.g., `paperless.voidex.me`) is set to point 
to the static IP address of my NGINX container. 
This ensures that all traffic for this service is directed to the reverse proxy.
2.  **Configuration from Template:** 
I maintain a base template for my NGINX proxy configurations. 
I create a new configuration file for Paperless-ngx (e.g., `paperless.conf`) 
inside `/etc/nginx/sites-available/` based on this template, 
updating the `server_name` and the `proxy_pass` URL 
to point to the internal IP and port of the Paperless-ngx LXC container.
3.  **Enabling the Site:** 
Once the configuration file is saved, 
I create a symbolic link to it in the `/etc/nginx/sites-enabled/` directory. 
This adheres to the standard NGINX practice 
of cleanly enabling and disabling sites without deleting the core configuration.
4.  **Testing and Reloading:** 
Before committing the changes, I run `nginx -t` to test 
the configuration for any syntax errors. 
Upon success, a quick `systemctl reload nginx` applies the new configuration, 
making the Paperless-ngx instance securely accessible via its subdomain.

This standardized workflow makes adding new services predictable and secure, 
reinforcing NGINX's role as the disciplined front door to my homelab.

### Installation Approach

While the installation of Paperless-ngx was facilitated 
by the official script (`bash -c "$(curl --location --silent --show-error https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/main/install-paperless-ngx.sh)"`), 
my focus was on integrating its functionality and data management, 
rather than the procedural steps of installation.

---

## Lessons Learned

The deployment of Paperless-ngx provided an interesting case study in my homelab:

*   **Docker in LXC Efficiency:** 
I was pleasantly surprised by the minimal overhead 
involved in running Docker inside an LXC container. 
This reinforced my preference for separating services into individual LXCs, 
offering a balance between isolation and efficiency.
*   **Control vs. VM Monolith:** 
This experience solidified my decision 
to favor separated LXCs for single services (each potentially running Docker) 
over a larger VM consolidating multiple Docker containers. 
This approach offers greater control, 
easier restoration points, and better isolation for individual services.

---

## Value in My Lab

Paperless-ngx marks a significant milestone in my homelab journey. 
It's the first tangible service that I am actively using 
for a personal, non-homelab-infrastructure purpose. 
This direct application of my homelab's capabilities 
to streamline a real-world personal need 
is incredibly satisfying and motivates further exploration.

---

## Future Plans

*   Further exploration of Paperless-ngx's advanced features, such as workflows and custom document types.
*   Integration with other personal systems or automation tools, potentially leveraging its API.
*   Continuous refinement of my document tagging and organizational structure to maximize searchability and efficiency.
