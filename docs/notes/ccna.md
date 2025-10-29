---
title: CCNA Training
description: This page I made to have an overview to my CCNA Training.  
---

# CCNA Training

This is going to be my training for the CCNA.  
I want the cert for the knowledge, the recognition of my knowledge comes last.  
The best way to show you knowledge, is by knowing.  

Since I don't want to skip anything important, I am going to write a paragraph about every topic mentioned: 

---

## 1.0 Network Fundamentals

### 1.1 Explain the role and function of network components

#### 1.1.a Routers

Routers are network devices that connect different networks together, 
typically acting as the gateway between a local network 
and the wider internet. 
They operate at Layer 3 of the OSI model, 
using IP addresses to determine the best path for forwarding data packets. 
By analyzing routing tables and protocols, 
routers ensure that traffic reaches 
its correct destination across multiple networks. 
In most setups, 
the router serves as the default gateway 
that all outbound traffic must pass through to reach external networks.

#### 1.1.b Layer 2 and Layer 3 switches

**Layer 2 switch**

A Layer 2 switch is a smarter alternative to a hub, 
operating at the Data Link layer (Layer 2) of the OSI model. 
It uses a MAC address table to learn which devices 
are connected to which ports, 
allowing it to forward Ethernet frames directly to the correct destination. 
This reduces unnecessary traffic and improves network efficiency. 
If the switch doesn’t yet know the destination MAC address, 
it temporarily acts like a hub by broadcasting the frame 
to all ports to discover where the device is located.

**Layer 3 switch**

A Layer 3 switch combines the high-speed switching of Layer 2 devices 
with the routing capabilities of a router, 
operating at the Network layer of the OSI model. 
It’s designed to route traffic between different VLANs 
or subnets within a LAN, using IP addresses to make forwarding decisions. 
Unlike traditional routers, Layer 3 switches use hardware-based routing, 
which makes them faster and more efficient for internal network traffic. 
While routers are ideal for connecting different networks 
across the internet, Layer 3 switches are optimized for managing complex, 
segmented networks within large organizations.

#### 1.1.c Next-generation firewalls and IPS

**NGFWs**

A Next-Generation Firewall (NGFW) 
is a more advanced version of a traditional firewall. 
While regular firewalls filter traffic 
based on IP addresses, ports, and protocols, 
NGFWs perform deep packet inspection to identify 
which application the traffic belongs to, 
allowing them to block or allow traffic at the application layer. 
This makes them much more effective 
against sophisticated threats in enterprise environments. 
NGFWs often include built-in intrusion prevention systems (IPS), 
and they support more flexible filtering based on applications, 
user identities, and cloud-based threat intelligence.

**IPS**

An Intrusion Prevention System (IPS) 
is a network security tool designed to detect 
and block malicious activity in real time. 
Unlike traditional firewalls that rely on static rules, 
an IPS analyzes traffic patterns and packet contents to identify known threats, 
suspicious behavior, or vulnerabilities being exploited. 
It uses threat intelligence, signatures, and behavioral analysis 
to dynamically stop attacks before they reach their target. 
IPS can be a standalone device or integrated into a Next-Generation Firewall, 
adding an extra layer of protection by actively inspecting and responding to threats.
not just filtering traffic, but preventing intrusions as they happen.

#### 1.1.d Access points

An Access Point (AP) is the part of a home router 
that enables wireless connectivity, 
even though we often forget it’s there. 
It acts as a bridge between wired Ethernet signals 
and wireless 802.11 radio frequency signals, 
allowing devices like phones 
and laptops to connect to the network without cables. 
By converting data from the physical layer into a wireless format, 
the AP makes Wi-Fi possible and keeps us connected 
to the local network and the internet.

#### 1.1.e Controllers (Cisco DNA Center and WLC)

A network controller is a centralized system 
that manages and automates the configuration of multiple network devices. 
Instead of logging into each switch, router, or access point manually, 
the controller pushes settings, monitors performance, 
and enforces policies across the network. 
This makes large environments easier to manage and more secure. 
Controllers like Cisco DNA Center handle wired and wireless infrastructure, 
while Wireless LAN Controllers (WLCs) focus on managing access points. 
They communicate with devices using protocols like CAPWAP or APIs, 
allowing for real-time control and visibility. 
In CCNA, understanding that controllers simplify network operations 
and are key to modern, scalable network design.

#### 1.1.f Endpoints

Endpoints are the devices at the edge of the network 
that actually use the services provided by the infrastructure. 
These include laptops, phones, servers, IoT devices, 
and anything else that sends or receives data.
They connect through switches, routers, and access points, 
and are identified by IP and MAC addresses. 
While they don’t forward traffic like network devices, 
they are the origin and destination of all communication. 
In CCNA, it’s important to understand 
how endpoints behave on the network, 
how they get their IPs, and why securing them is critical 
since they’re often the most vulnerable part of any setup.

#### 1.1.g Servers

Servers are specialized endpoints 
that provide resources or services to other devices on the network. 
Unlike regular user devices, servers are designed to handle requests 
from multiple clients, whether it's hosting websites, managing files, 
or running applications. 
They often run continuously and are optimized for reliability, scalability, and performance. 
In a network, servers are key targets and critical assets, 
identified by static IPs and often protected by firewalls and access controls. 
For CCNA, it's important to understand how servers fit into the client-server model, 
how they communicate over TCP/IP, and how they’re accessed and secured.

#### 1.1.h PoE

Power over Ethernet (PoE) is a technology 
that allows network cables to carry electrical power along with data. 
This means devices like access points, IP cameras, and VoIP phones 
can be powered directly through the Ethernet cable, 
without needing a separate power supply. 
PoE simplifies installation and reduces cable clutter, 
especially in places where running electrical wiring is difficult. 
For CCNA, you should know that PoE is defined by standards 
like IEEE 802.3af and 802.3at, 
and that switches can be PoE-enabled to deliver power to connected devices.

---

### 1.2 Describe characteristics of network topology architectures

#### 1.2.a Two-tier

The two-tier architecture is a simple and efficient network design 
used mostly in smaller environments. 
It consists of an access layer, where endpoints connect, 
and a distribution layer, which aggregates traffic and applies policies 
before sending it to the core or external networks. 
This setup reduces complexity and cost, 
while still allowing for basic scalability and segmentation. 
For CCNA, it’s important to know 
that two-tier designs are common in small to medium-sized networks 
where performance and simplicity are key.

#### 1.2.b Three-tier

The three-tier architecture adds a core layer on top of the access and distribution layers. 
The core layer handles high-speed backbone traffic 
and interconnects multiple distribution blocks. 
This design is used in larger enterprise networks 
to improve scalability, redundancy, and performance. 
Each layer has a clear role: 
access connects devices, 
distribution enforces policies, 
and core ensures fast, reliable transport. 
For CCNA, understanding the separation of roles 
and traffic flow between layers is essential.

#### 1.2.c Spine-leaf

Spine-leaf is a modern topology used in data centers and high-performance environments. 
It consists of leaf switches that connect to endpoints 
and spine switches that interconnect all leaf switches. 
Every leaf connects to every spine, 
creating a non-blocking fabric with predictable latency and bandwidth. 
This design supports east-west traffic and scales horizontally. 
For CCNA, you should know that spine-leaf replaces traditional hierarchies 
in environments where speed, scalability, and redundancy are critical.

#### 1.2.d WAN

A Wide Area Network (WAN) connects geographically separated networks, 
like branch offices to headquarters or cloud services. 
It uses technologies like MPLS, VPNs, and leased lines 
to transmit data over long distances. 
WANs are slower and more complex than LANs, 
but they’re essential for global connectivity. 
For CCNA, you need to understand how WAN links are provisioned, 
what protocols are used, and how routing adapts 
to different bandwidth and latency conditions.

#### 1.2.e Small office/home office (SOHO)

SOHO networks are compact setups designed for homes or small businesses. 
They typically use a single router that combines 
routing, switching, wireless access, and sometimes firewall functions. 
Devices connect via Ethernet or Wi-Fi, 
and internet access is usually through a broadband connection. 
For CCNA, it’s important to recognize 
how SOHO networks simplify infrastructure, 
and how basic security and configuration principles 
still apply even in small environments.

#### 1.2.f On-premise and cloud

On-premise networks run entirely on local infrastructure: 
switches, routers, servers are managed by the organization. 
Cloud networks, on the other hand, 
use remote infrastructure hosted by providers like AWS or Azure. 
Many modern setups are hybrid, combining both. 
Cloud offers scalability and flexibility, 
while on-premise gives control and performance. 
For CCNA, you should understand the trade-offs, 
how connectivity works between cloud and local networks, 
and how services like VPNs and SD-WAN bridge the gap.

---

### 1.3 Compare physical interface and cabling types

#### 1.3.a Single-mode fiber, multimode fiber, copper

Single-mode fiber uses a narrow core 
and laser light to transmit data over long distances 
with minimal signal loss, ideal for WAN links. 
Multimode fiber has a wider core and uses LED light, 
making it suitable for shorter distances like within buildings. 
Copper cabling, such as twisted-pair Ethernet, 
is cost-effective and widely used for short-range connections 
but is more susceptible to interference and signal degradation.

#### 1.3.b Connections (Ethernet shared media and point-to-point)

Ethernet shared media refers to older network setups 
where multiple devices share the same transmission medium, 
often leading to collisions. 
Point-to-point connections, on the other hand, link two devices directly, 
eliminating contention and improving performance. 
Modern networks favor point-to-point for reliability and speed.

---

### 1.4 Identify interface and cable issues (collisions, errors, mismatch duplex, and/or speed)

Interface and cable issues can cripple network performance. 
Collisions occur in half-duplex environments when devices transmit simultaneously. 
Errors like CRC mismatches suggest physical damage or interference. 
Duplex mismatches, where one end is full-duplex and the other is half, 
cause severe throughput problems. 
Speed mismatches can prevent links from forming or degrade performance. 
Diagnosing these requires careful interface monitoring and configuration checks.

---

### 1.5 Compare TCP to UDP

TCP is a connection-oriented protocol that ensures reliable delivery 
through acknowledgments, retransmissions, and sequencing—perfect for applications 
like web browsing and email. UDP is connectionless, faster, and lightweight, 
but lacks reliability mechanisms. It’s ideal for real-time applications 
like video streaming or DNS, where speed matters more than guaranteed delivery.

---

### 1.6 Configure and verify IPv4 addressing and subnetting

IPv4 addressing assigns unique identifiers to devices on a network. 
Subnetting divides a larger network into smaller segments, 
improving efficiency and security. 
Configuration involves setting IP addresses, subnet masks, and gateways. 
Verification uses tools like 'ping', 'ipconfig', or 
'show ip interface' to confirm connectivity and correct setup.

---

### 1.7 Describe private IPv4 addressing

Private IPv4 addresses are reserved for internal use 
and not routable on the public internet. 
Ranges include 10.0.0.0/8, 172.16.0.0–172.31.255.255, and 192.168.0.0/16. 
These addresses require NAT (Network Address Translation) to communicate externally. 
They’re essential for conserving public IP space and securing internal networks.

---

### 1.8 Configure and verify IPv6 addressing and prefix

IPv6 uses 128-bit addresses and eliminates the need for NAT 
by providing a vast address space. 
Configuration includes assigning addresses and prefixes, often using SLAAC or DHCPv6. 
Verification involves commands like 'ping6', 'show ipv6 interface', and checking prefix delegation. 
Understanding IPv6 is key to future-proofing your network skills.

---

### 1.9 Describe IPv6 address types

#### 1.9.a Unicast (global, unique local, and link local)

Unicast addresses identify a single interface. 
Global unicast is routable across the internet. 
Unique local is similar to private IPv4—used internally. 
Link-local is automatically assigned and used for communication within the same link.

#### 1.9.b Anycast

Anycast assigns the same address to multiple devices. 
The network routes traffic to the nearest device, 
improving performance and redundancy—commonly used in DNS and content delivery networks.

#### 1.9.c Multicast

Multicast sends traffic to multiple devices subscribed to a group, 
conserving bandwidth compared to broadcasting. 
It’s used in streaming and routing protocols like OSPF.

#### 1.9.d Modified EUI 64

Modified EUI-64 generates an IPv6 interface ID 
from a device’s MAC address, automating address assignment. 
It ensures uniqueness but can raise privacy concerns, 
so temporary addresses are often preferred.

---

### 1.10 Verify IP parameters for Client OS (Windows, Mac OS, Linux)

Verifying IP settings ensures proper network connectivity. 
On Windows, use 'ipconfig'; 
on Mac, 'ifconfig' or 'networksetup'; 
on Linux, 'ip' a or 'nmcli'. 
Check IP address, subnet mask, gateway, and DNS settings to troubleshoot connectivity issues across platforms.

---

### 1.11 Describe wireless principles

#### 1.11.a Nonoverlapping Wi-Fi channels

In 2.4 GHz Wi-Fi, channels 1, 6, and 11 are nonoverlapping—using them avoids interference. 
In 5 GHz, more channels are available with less overlap, improving performance.

#### 1.11.b SSID

The Service Set Identifier (SSID) is the network name broadcast by an access point. 
Devices use it to identify and connect to the correct wireless network.

#### 1.11.c RF

Radio Frequency (RF) signals carry wireless data. 
Factors like frequency band, signal strength, and interference affect performance. 
Understanding RF behavior is crucial for Wi-Fi design.

#### 1.11.d Encryption

Wireless encryption protects data from eavesdropping. 
WPA2 and WPA3 are current standards, 
using strong algorithms to secure communication between clients and access points.

---

### 1.12 Explain virtualization fundamentals (server virtualization, containers, and VRFs)

Virtualization abstracts physical resources. 
Server virtualization runs multiple OS instances on one machine using hypervisors. 
Containers isolate applications with shared OS kernels—lightweight and portable. 
VRFs (Virtual Routing and Forwarding) allow multiple routing tables on one device, 
enabling network segmentation and multi-tenancy.

---

### 1.13 Describe switching concepts

#### 1.13.a MAC learning and aging

Switches learn MAC addresses by examining incoming frames and associating them with ports. 
Aging removes inactive entries to keep the table current and efficient.

#### 1.13.b Frame switching

Frame switching forwards Ethernet frames based on MAC address lookup. 
It’s the core function of Layer 2 switches, enabling fast, targeted delivery.

#### 1.13.c Frame flooding

When a switch doesn’t know the destination MAC, 
it floods the frame to all ports except the source. 
This helps discover unknown devices but can cause temporary congestion.

#### 1.13.d MAC address table

The MAC address table maps MAC addresses to switch ports. 
It’s built dynamically and used to make forwarding decisions. 
A well-maintained table ensures efficient traffic flow.


---

## 2.0 Network Access

### 2.1 Configure and verify VLANs (normal range) spanning multiple switches

#### 2.1.a Access ports (data and voice)

Access ports are switch interfaces configured to carry traffic for a single VLAN.
Devices like PCs, printers, or IP phones typically connect to access ports.
In a voice-enabled setup, the switch can assign one VLAN 
for voice traffic (for the phone) and 
another for data traffic (for the computer connected through the phone).
This separation improves QoS and keeps different traffic types logically isolated.

#### 2.1.b Default VLAN

By default, all switch ports belong to VLAN 1.
This “default VLAN” carries control traffic 
such as CDP or STP by default, but in production, 
it’s considered a best practice to avoid using VLAN 1 for user traffic.
Moving management interfaces and user ports away 
from VLAN 1 helps reduce attack surfaces.

#### 2.1.c InterVLAN connectivity

Switches segment networks into VLANs, 
but by themselves, VLANs can’t talk to each other.
For inter-VLAN communication, a Layer 3 device is required.
Usually a router (“router-on-a-stick”) or a Layer 3 switch is used.
This setup allows devices in different VLANs to exchange traffic 
while still maintaining logical segmentation.

---

### 2.2 Configure and verify interswitch connectivity

#### 2.2.a Trunk ports

Trunk ports are switch ports that carry traffic for multiple VLANs simultaneously.
They use tagging (like 802.1Q) to mark which VLAN each frame belongs to.
This allows switches to extend VLANs across multiple devices, 
keeping network segmentation consistent.

#### 2.2.b 802.1Q

802.1Q is the IEEE standard for VLAN trunking.
It inserts a small tag (4 bytes) into Ethernet frames to identify the VLAN ID.
Only trunk ports add and interpret these tags, 
while access ports deliver untagged traffic to end devices.

#### 2.2.c Native VLAN

On an 802.1Q trunk, one VLAN is designated as the “native VLAN.”
Traffic from this VLAN is sent untagged across the trunk.
By default, VLAN 1 is native, but administrators often change it for security reasons.
Misconfigurations between switches (mismatched native VLANs) 
can cause VLAN leakage and connectivity issues.

---

### 2.3 Configure and verify Layer 2 discovery protocols (Cisco Discovery Protocol and LLDP)

Discovery protocols allow devices to advertise and learn information 
about directly connected neighbors.
Cisco Discovery Protocol (CDP) is Cisco-proprietary, 
while LLDP is an open standard.
Both can reveal details like device ID, IP address, platform, and port ID.
They’re useful for troubleshooting and documentation, 
but in secure environments, administrators may disable them 
to avoid leaking network details to attackers.

---

### 2.4 Configure and verify (Layer 2/Layer 3) EtherChannel (LACP)

EtherChannel bundles multiple physical links into one logical connection, 
increasing bandwidth and providing redundancy.
Layer 2 EtherChannel groups switch ports, 
while Layer 3 EtherChannel creates a routed link.
LACP (Link Aggregation Control Protocol, IEEE 802.3ad) 
is the open standard that negotiates and maintains these bundles.
EtherChannel prevents loops 
because the bundled ports are treated as a single logical interface by STP.

---

### 2.5 Interpret basic operations of Rapid PVST + Spanning Tree Protocol

#### 2.5.a Root port, root bridge (primary/secondary), and other port names

Spanning Tree Protocol prevents loops by electing 
a root bridge as the central point of the topology.
Each non-root switch identifies one root port (its best path to the root bridge) 
and assigns roles to its other ports (designated or alternate).
A backup root bridge can be configured for redundancy in case the primary fails.

#### 2.5.b Port states (forwarding/blocking)

Ports in STP move through several states: 
blocking, listening, learning, and forwarding.
In Rapid PVST+, convergence is much faster, 
with ports transitioning directly to forwarding when conditions are safe.
Blocked ports exist to prevent loops 
by intentionally disabling redundant paths.

#### 2.5.c PortFast

PortFast allows access ports (like those connecting to PCs) 
to skip the normal STP states and go directly to forwarding.
This avoids delays during host boot-up and DHCP processes.
It should only be enabled on ports facing end devices, never on switch-to-switch links.

#### 2.5.d Root guard, loop guard, BPDU filter, and BPDU guard

- **Root guard** prevents a port from becoming the root port, protecting the current root bridge.

- **Loop guard** keeps redundant links from accidentally moving into forwarding state if BPDUs stop being received.

- **BPDU filter** blocks STP BPDUs from being sent or received on specific ports.

- **BPDU guard** immediately shuts down a port if it receives a BPDU, protecting access ports from rogue switches.

---

### 2.6 Describe Cisco Wireless Architectures and AP modes

Cisco wireless networks can be deployed in autonomous or controller-based architectures.
In controller-based designs, lightweight APs 
connect to a Wireless LAN Controller (WLC), 
which centralizes management and policies.
AP modes include local mode (serving clients), 
monitor mode (scanning for rogue APs), 
and flexconnect (remote branch deployments 
where APs keep working even if the controller link is down).

---

### 2.7 Describe physical infrastructure connections of WLAN components (AP, WLC, access/trunk ports, and LAG)

Access points typically connect to switch access ports (for client VLANs) 
or trunk ports (if multiple SSIDs/VLANs are required).
The WLC usually connects via a trunk port, aggregating WLAN traffic from many APs.
Link Aggregation Groups (LAG) can be used 
between controllers and switches for higher bandwidth and redundancy.

---

### 2.8 Describe network device management access (Telnet, SSH, HTTP, HTTPS, console, TACACS+/RADIUS, and cloud managed)

Devices can be managed through different channels:

- **Console:** physical, out-of-band access for initial setup.

- **Telnet:** plaintext, insecure, rarely used today.

- **SSH:** encrypted, standard for CLI-based management.

- **HTTP/HTTPS:** GUI-based management (HTTPS preferred for security).

- **TACACS+ / RADIUS:** centralized authentication, authorization, and accounting, integrating with enterprise identity systems.

- **Cloud management:** modern controllers allow devices to be managed via cloud dashboards, reducing on-premise overhead.

---

### 2.9 Interpret the wireless LAN GUI configuration for client connectivity, such as WLAN creation, security settings, QoS profiles, and advanced settings

Wireless LAN controllers provide a GUI for creating and managing SSIDs (WLANs).
Admins configure SSID names, 
security policies (WPA2, WPA3, enterprise authentication with RADIUS), 
and QoS profiles to prioritize traffic types like voice or video.
Advanced settings include client isolation, band steering, and load balancing across APs.
Interpreting these correctly ensures clients connect securely and receive appropriate quality of service.


---

## 3.0 IP Connectivity

### 3.1 Interpret the components of routing table

#### 3.1.a Routing protocol code
Each entry in the routing table starts with a code that identifies how the route was learned.  
Examples: **C** (connected), **S** (static), **R** (RIP), **O** (OSPF), **D** (EIGRP).  
This makes it easy to see the source of routing information at a glance.  

#### 3.1.b Prefix
The prefix shows the destination network or subnet that the route applies to.  
It defines the “where” — the range of IP addresses reachable through this entry.  

#### 3.1.c Network mask
The network mask (or prefix length, e.g., `/24`) tells how specific the route is.  
Smaller masks (like `/8`) cover bigger ranges, while larger masks (like `/32`) identify exact hosts.  

#### 3.1.d Next hop
The next hop is the IP address of the device that should receive the packet to forward it further.  
If the destination is directly connected, the routing table shows the outgoing interface instead.  

#### 3.1.e Administrative distance
Administrative distance (AD) is a trust rating assigned to routing sources.  
Lower values are preferred (e.g., 0 = connected, 1 = static, 110 = OSPF).  
AD only matters when multiple routing sources know about the same network.  

#### 3.1.f Metric
The metric is the “cost” assigned by a routing protocol to reach a network.  
It can be based on hop count (RIP), bandwidth (OSPF/EIGRP), or other factors.  
If multiple paths exist with the same AD, the one with the lowest metric wins.  

#### 3.1.g Gateway of last resort
This is the default route used when no more specific match exists.  
It acts as the “catch-all” — like saying: *if you don’t know, send it here.*  

---

### 3.2 Determine how a router makes a forwarding decision by default

#### 3.2.a Longest prefix match
Routers always prefer the most specific route.  
For example, a `/32` host route will be chosen over a `/24` subnet route for the same destination.  

#### 3.2.b Administrative distance
If two routing protocols advertise the same prefix, the router compares administrative distance.  
The protocol with the lowest AD value is selected.  

#### 3.2.c Routing protocol metric
If multiple routes exist from the same protocol, the metric decides.  
The path with the lowest cost (best metric) becomes the active route.  

---

### 3.3 Configure and verify IPv4 and IPv6 static routing

#### 3.3.a Default route
A static default route points to a next hop or exit interface for all unknown destinations.  
Syntax: `ip route 0.0.0.0 0.0.0.0 <next-hop>` (IPv4) or `ipv6 route ::/0 <next-hop>` (IPv6).  

#### 3.3.b Network route
A network route points to an entire subnet.  
Example: `ip route 192.168.10.0 255.255.255.0 10.1.1.1` tells the router where to forward that whole /24.  

#### 3.3.c Host route
A host route is the most specific entry possible — a /32 in IPv4 or /128 in IPv6.  
It directs traffic to exactly one IP address.  

#### 3.3.d Floating static
A floating static route has a higher administrative distance than the primary route.  
It remains inactive until the main route disappears, acting as a backup path.  

---

### 3.4 Configure and verify single area OSPFv2

#### 3.4.a Neighbor adjacencies
OSPF routers must form neighbor adjacencies to exchange LSAs (Link-State Advertisements).  
This requires matching settings like area ID, hello/dead timers, and authentication.  

#### 3.4.b Point-to-point
On point-to-point links, OSPF forms a direct adjacency with the single neighbor.  
This simplifies operation since no DR/BDR election is needed.  

#### 3.4.c Broadcast (DR/BDR selection)
On multi-access networks (like Ethernet), OSPF elects a Designated Router (DR) and Backup DR.  
This reduces the number of adjacencies by having all routers communicate through the DR.  

#### 3.4.d Router ID
Each OSPF router has a unique Router ID (RID), chosen from the highest IP on a loopback or active interface, unless manually set.  
The RID identifies the router in the OSPF domain.  

---

### 3.5 Describe the purpose, functions, and concepts of first hop redundancy protocols

First Hop Redundancy Protocols (FHRPs) ensure that hosts on a LAN always have a working default gateway.  
Instead of pointing to a single router IP, hosts use a *virtual IP* shared by multiple routers.  

If the active router fails, another takes over seamlessly.  
Common examples:  
- **HSRP** (Cisco proprietary)  
- **VRRP** (open standard)  
- **GLBP** (Cisco, supports load balancing)  

This protects against gateway failure and improves network availability.  


---


## 4.0 IP Services

### 4.1 Configure and verify inside source NAT using static and pools

Network Address Translation (NAT) maps private IP addresses to public ones for internet access.  

- **Static NAT** creates a one-to-one mapping between an inside local (private) address and an inside global (public) address. Useful for hosting servers that need predictable external access.  
- **NAT Pools** allow many internal devices to share a range of public IPs. When sessions are created, addresses are dynamically assigned from the pool.  

Verification: use `show ip nat translations` to see current mappings, and `show ip nat statistics` for usage details.  

---

### 4.2 Configure and verify NTP operating in a client and server mode

Network Time Protocol (NTP) synchronizes device clocks across the network.  
Consistent time is critical for logs, security, and authentication.  

- **Client mode**: a device syncs its clock with an upstream NTP server.  
- **Server mode**: a device provides time to other clients in the network.  

Verification: `show ntp status` and `show ntp associations` confirm synchronization.  

---

### 4.3 Explain the role of DHCP and DNS within the network

- **DHCP (Dynamic Host Configuration Protocol)** automatically assigns IP addresses, subnet masks, gateways, and DNS servers to hosts. It simplifies network management and reduces manual errors.  
- **DNS (Domain Name System)** translates human-readable hostnames into IP addresses. Instead of remembering `192.168.1.10`, clients can reach devices using names like `server.local`.  

Together, DHCP and DNS enable easy, scalable, and user-friendly connectivity.  

---

### 4.4 Explain the function of SNMP in network operations

Simple Network Management Protocol (SNMP) is used to monitor and manage devices.  
Agents on devices expose management data, while SNMP managers collect it.  
This allows administrators to gather statistics (like interface utilization), set configuration parameters, and receive alerts (traps).  

SNMP is widely supported, but must be secured — SNMPv1/v2 use plaintext community strings, while SNMPv3 adds authentication and encryption.  

---

### 4.5 Describe the use of syslog features including facilities and levels

Syslog centralizes logging from network devices.  
Each log entry has:  
- **Facility**: the source subsystem (e.g., auth, daemon, local7).  
- **Level**: the severity (0 = emergencies, 7 = debugging).  

Logs can be sent to a remote syslog server for centralized storage and analysis, improving troubleshooting and security monitoring.  

---

### 4.6 Configure and verify DHCP client and relay

- **DHCP Client**: a router or switch interface can act as a DHCP client to get its own IP from a DHCP server.  
- **DHCP Relay**: when clients and servers are on different subnets, a relay agent forwards DHCP requests across routers. This is configured with the `ip helper-address` command.  

Verification: `show ip dhcp binding` (on server) or `show running-config` (on relay).  

---

### 4.7 Explain the forwarding per-hop behavior (PHB) for QoS, such as classification, marking, queuing, congestion, policing, and shaping

Quality of Service (QoS) manages how packets are treated under congestion.  

- **Classification**: identify traffic (voice, video, bulk data).  
- **Marking**: tag packets with values (DSCP, CoS) for handling priority.  
- **Queuing**: organize packets into queues, often prioritizing voice/video.  
- **Congestion management**: scheduling algorithms (like weighted fair queuing) decide who gets bandwidth.  
- **Policing**: drops or re-marks traffic exceeding a rate limit.  
- **Shaping**: buffers traffic to smooth bursts and enforce bandwidth limits.  

Together, these ensure critical traffic (like voice) gets priority over best-effort data.  

---

### 4.8 Configure network devices for remote access using SSH

Secure Shell (SSH) is the standard for encrypted CLI management.  
Configuration requires:  
1. Defining domain and generating RSA/EDSA keys.  
2. Enabling SSH on VTY lines (`transport input ssh`).  
3. Setting user authentication (local or remote).  

Verification: connect with an SSH client and check with `show ip ssh`.  

---

### 4.9 Describe the capabilities and functions of TFTP/FTP in the network

- **TFTP (Trivial File Transfer Protocol)**: lightweight, no authentication, uses UDP. Common for transferring IOS images or configs during initial setup.  
- **FTP (File Transfer Protocol)**: more feature-rich, supports authentication, uses TCP. Better for larger or more secure transfers.  

Both are used to move configuration files, backups, and software images between devices and servers.  


---


## 5.0 Security Fundamentals

### 5.1 Define key security concepts (threats, vulnerabilities, exploits, and mitigation techniques)

- **Threats**: potential dangers to assets (e.g., malware, phishing, insider abuse).  
- **Vulnerabilities**: weaknesses that could be exploited (e.g., unpatched software, weak passwords).  
- **Exploits**: the actual use of a vulnerability to carry out an attack.  
- **Mitigation techniques**: steps to reduce risk (patching, firewalls, IDS/IPS, least-privilege access).  

Security is not about eliminating all threats but about minimizing the chance of success and impact.  

---

### 5.2 Describe security program elements (user awareness, training, and physical access control)

Technical defenses are only part of security.  

- **User awareness**: teaching staff to recognize phishing, social engineering, and unsafe practices.  
- **Training**: ongoing skill-building so users and admins know how to respond properly to threats.  
- **Physical access control**: locks, badges, cameras, and secure server rooms to prevent unauthorized physical access.  

A strong program blends people, process, and technology.  

---

### 5.3 Configure and verify device access control using local passwords

Routers and switches can be secured with local passwords:  
- **Console password**: restricts direct physical CLI access.  
- **VTY line passwords**: control remote access (Telnet/SSH).  
- **Enable/secret password**: protects privileged EXEC mode.  

Verification: use `show running-config` to confirm password settings.  
Best practice: always use `enable secret` (encrypted) instead of `enable password` (cleartext).  

---

### 5.4 Describe security password policies elements, such as management, complexity, and password alternatives (multifactor authentication, certificates, and biometrics)

- **Management**: regular rotation, avoiding reuse, secure storage.  
- **Complexity**: enforce length, variety of characters, and avoidance of dictionary words.  
- **Alternatives**:  
  - **Multifactor authentication (MFA)**: combines something you know (password), have (token), and are (biometric).  
  - **Certificates**: authenticate devices/users without manual passwords.  
  - **Biometrics**: fingerprint, face ID, etc., increasingly common.  

Password policy is about balancing usability with security.  

---

### 5.5 Describe IPsec remote access and site-to-site VPNs

- **Remote access VPN**: allows individual users to connect securely to the network over the internet, typically with client software.  
- **Site-to-site VPN**: connects entire sites/networks securely, router-to-router or firewall-to-firewall.  
- **IPsec**: provides confidentiality (encryption), integrity (hashing), and authentication (keys) to secure VPN traffic.  

---

### 5.6 Configure and verify access control lists

ACLs (Access Control Lists) filter traffic by permitting or denying packets based on criteria like source/destination IP, port, or protocol.  

- **Standard ACLs**: filter only by source IP, usually applied close to the destination.  
- **Extended ACLs**: filter by source, destination, protocol, and port, usually applied close to the source.  

Verification: `show access-lists` and `show running-config`.  

---

### 5.7 Configure and verify Layer 2 security features (DHCP snooping, dynamic ARP inspection, and port security)

- **DHCP Snooping**: prevents rogue DHCP servers by only allowing responses from trusted ports.  
- **Dynamic ARP Inspection (DAI)**: stops ARP spoofing/poisoning attacks by validating ARP packets against DHCP snooping bindings.  
- **Port Security**: limits the number of MAC addresses allowed on a port; can block or shut down ports if violations occur.  

These protect against common LAN-based attacks.  

---

### 5.8 Compare authentication, authorization, and accounting concepts

- **Authentication**: verifying identity (who you are).  
- **Authorization**: determining what actions you can perform (what you’re allowed to do).  
- **Accounting**: logging actions for auditing and tracking (what you did).  

Together, these form AAA, often implemented with TACACS+ or RADIUS.  

---

### 5.9 Describe wireless security protocols (WPA, WPA2, and WPA3)

- **WPA (Wi-Fi Protected Access)**: replaced insecure WEP, introduced TKIP encryption.  
- **WPA2**: standardized on AES-based CCMP encryption; widely used.  
- **WPA3**: improves security with SAE (Simultaneous Authentication of Equals) for stronger key exchange and better protection against brute-force attacks.  

Each new version strengthens wireless encryption and authentication.  

---

### 5.10 Configure and verify WLAN within the GUI using WPA2 PSK

In the WLAN controller GUI:  
1. Create a new SSID.  
2. Choose WPA2 as the security method.  
3. Configure a Pre-Shared Key (PSK).  
4. Apply QoS or VLAN mappings if needed.  

Verification: connect a client device and confirm authentication.  
The WLAN should encrypt traffic using WPA2 with the configured key.  


---


## 6.0 Automation and Programmability

### 6.1 Explain how automation impacts network management

Automation reduces repetitive manual tasks, speeds up configuration, and minimizes human error.  
- Faster deployment of consistent changes across devices.  
- Easier troubleshooting with automated data collection.  
- Enables large-scale management that manual CLI could never handle efficiently.  

Impact: admins shift from typing commands to designing policies and workflows.  

---

### 6.2 Compare traditional networks with controller-based networking

- **Traditional networking**: devices are configured individually via CLI; control plane and data plane are tightly coupled inside each device.  
- **Controller-based networking**: a central controller programs and manages devices, abstracting the complexity.  
  - Benefits: faster provisioning, global policy enforcement, and better visibility.  

Traditional = device-by-device. Controller-based = centralized intent and automation.  

---

### 6.3 Describe controller-based, software-defined architecture (overlay, underlay, and fabric)

- **Underlay**: the physical network (switches, routers, links) that provides connectivity.  
- **Overlay**: virtual networks built on top of the underlay (e.g., tunnels, VXLAN).  
- **Fabric**: the combined architecture that unifies control and data forwarding, often managed by a controller.  

Key concepts:  
- **Separation of control plane and data plane**: controller makes decisions (control), devices forward packets (data).  
- **Northbound APIs**: connect the controller to higher-level applications (e.g., automation tools, orchestration).  
- **Southbound APIs**: connect the controller to network devices (e.g., OpenFlow, NETCONF).  

---

### 6.4 Explain AI (generative and predictive) and machine learning in network operations

- **Predictive AI/ML**: analyzes patterns in traffic, performance, and logs to forecast issues before they occur (e.g., link failures, congestion).  
- **Generative AI**: creates insights, reports, or even config recommendations based on data.  
- **Use cases**: anomaly detection, root cause analysis, proactive capacity planning.  

AI in networking shifts operations from reactive troubleshooting to proactive optimization.  

---

### 6.5 Describe characteristics of REST-based APIs (authentication types, CRUD, HTTP verbs, and data encoding)

- **Authentication types**: API keys, basic auth, OAuth.  
- **CRUD operations**: Create, Read, Update, Delete.  
- **HTTP verbs**:  
  - `POST` → Create  
  - `GET` → Read  
  - `PUT/PATCH` → Update  
  - `DELETE` → Delete  
- **Data encoding**: most often JSON or XML.  

REST APIs let automation tools interact programmatically with network devices and controllers.  

---

### 6.6 Recognize the capabilities of configuration management mechanisms, such as Ansible and Terraform

- **Ansible**: agentless, YAML-based tool for configuration management and automation. Great for pushing configs and running playbooks across devices.  
- **Terraform**: declarative Infrastructure as Code (IaC) tool; manages infrastructure provisioning across multiple platforms (cloud + network).  
- Both reduce manual CLI usage and enable repeatable, version-controlled deployments.  

---

### 6.7 Recognize components of JSON-encoded data

JSON (JavaScript Object Notation) is lightweight, human-readable, and commonly used for APIs.  

Key components:  
- **Objects**: key-value pairs inside `{ }`  
- **Arrays**: ordered lists inside `[ ]`  
- **Keys**: strings (e.g., `"hostname"`)  
- **Values**: can be strings, numbers, booleans, arrays, or nested objects  

Example:  

```json
{
  "device": "router1",
  "interfaces": [
    {"name": "Gig0/0", "ip": "192.168.1.1"},
    {"name": "Gig0/1", "ip": "10.0.0.1"}
  ]
}

```

JSON is the lingua franca of modern APIs. 


---

