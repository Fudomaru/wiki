---
title: CCNA Training
description: This page I made to have an overview to my CCNA Training.  
---

# CCNA Training

This is going to be my training for the CCNA.  
I want the cert for the knowledge, the recognizion of my knowledge comes last.  
The best way to show you knowledge, is by knowing.  

---

    Since I don't want to scip anything important, I am going to write a paragraphe about every topic mentioned: 

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

#### 1.4 Identify interface and cable issues (collisions, errors, mismatch duplex, and/or speed)

Interface and cable issues can cripple network performance. 
Collisions occur in half-duplex environments when devices transmit simultaneously. 
Errors like CRC mismatches suggest physical damage or interference. 
Duplex mismatches, where one end is full-duplex and the other is half, 
cause severe throughput problems. 
Speed mismatches can prevent links from forming or degrade performance. 
Diagnosing these requires careful interface monitoring and configuration checks.

#### 1.5 Compare TCP to UDP

TCP is a connection-oriented protocol that ensures reliable delivery 
through acknowledgments, retransmissions, and sequencing—perfect for applications 
like web browsing and email. UDP is connectionless, faster, and lightweight, 
but lacks reliability mechanisms. It’s ideal for real-time applications 
like video streaming or DNS, where speed matters more than guaranteed delivery.

#### 1.6 Configure and verify IPv4 addressing and subnetting

IPv4 addressing assigns unique identifiers to devices on a network. 
Subnetting divides a larger network into smaller segments, 
improving efficiency and security. 
Configuration involves setting IP addresses, subnet masks, and gateways. 
Verification uses tools like 'ping', 'ipconfig', or 
'show ip interface' to confirm connectivity and correct setup.

### 1.7 Describe private IPv4 addressing

Private IPv4 addresses are reserved for internal use 
and not routable on the public internet. 
Ranges include 10.0.0.0/8, 172.16.0.0–172.31.255.255, and 192.168.0.0/16. 
These addresses require NAT (Network Address Translation) to communicate externally. 
They’re essential for conserving public IP space and securing internal networks.

### 1.8 Configure and verify IPv6 addressing and prefix

IPv6 uses 128-bit addresses and eliminates the need for NAT 
by providing a vast address space. 
Configuration includes assigning addresses and prefixes, often using SLAAC or DHCPv6. 
Verification involves commands like 'ping6', 'show ipv6 interface', and checking prefix delegation. 
Understanding IPv6 is key to future-proofing your network skills.


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

### 1.10 Verify IP parameters for Client OS (Windows, Mac OS, Linux)

Verifying IP settings ensures proper network connectivity. 
On Windows, use 'ipconfig'; 
on Mac, 'ifconfig' or 'networksetup'; 
on Linux, 'ip' a or 'nmcli'. 
Check IP address, subnet mask, gateway, and DNS settings to troubleshoot connectivity issues across platforms.


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


### 1.12 Explain virtualization fundamentals (server virtualization, containers, and VRFs)

Virtualization abstracts physical resources. 
Server virtualization runs multiple OS instances on one machine using hypervisors. 
Containers isolate applications with shared OS kernels—lightweight and portable. 
VRFs (Virtual Routing and Forwarding) allow multiple routing tables on one device, 
enabling network segmentation and multi-tenancy.


### 1.13 Describe switching concepts

##### 1.13.a MAC learning and aging

Switches learn MAC addresses by examining incoming frames and associating them with ports. 
Aging removes inactive entries to keep the table current and efficient.

##### 1.13.b Frame switching

Frame switching forwards Ethernet frames based on MAC address lookup. 
It’s the core function of Layer 2 switches, enabling fast, targeted delivery.

##### 1.13.c Frame flooding

When a switch doesn’t know the destination MAC, 
it floods the frame to all ports except the source. 
This helps discover unknown devices but can cause temporary congestion.

##### 1.13.d MAC address table

The MAC address table maps MAC addresses to switch ports. 
It’s built dynamically and used to make forwarding decisions. 
A well-maintained table ensures efficient traffic flow.


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


### 2.3 Configure and verify Layer 2 discovery protocols (Cisco Discovery Protocol and LLDP)

Discovery protocols allow devices to advertise and learn information 
about directly connected neighbors.
Cisco Discovery Protocol (CDP) is Cisco-proprietary, 
while LLDP is an open standard.
Both can reveal details like device ID, IP address, platform, and port ID.
They’re useful for troubleshooting and documentation, 
but in secure environments, administrators may disable them 
to avoid leaking network details to attackers.

### 2.4 Configure and verify (Layer 2/Layer 3) EtherChannel (LACP)

EtherChannel bundles multiple physical links into one logical connection, 
increasing bandwidth and providing redundancy.
Layer 2 EtherChannel groups switch ports, 
while Layer 3 EtherChannel creates a routed link.
LACP (Link Aggregation Control Protocol, IEEE 802.3ad) 
is the open standard that negotiates and maintains these bundles.
EtherChannel prevents loops 
because the bundled ports are treated as a single logical interface by STP.


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


### 2.6 Describe Cisco Wireless Architectures and AP modes

Cisco wireless networks can be deployed in autonomous or controller-based architectures.
In controller-based designs, lightweight APs 
connect to a Wireless LAN Controller (WLC), 
which centralizes management and policies.
AP modes include local mode (serving clients), 
monitor mode (scanning for rogue APs), 
and flexconnect (remote branch deployments 
where APs keep working even if the controller link is down).


### 2.7 Describe physical infrastructure connections of WLAN components (AP, WLC, access/trunk ports, and LAG)

Access points typically connect to switch access ports (for client VLANs) 
or trunk ports (if multiple SSIDs/VLANs are required).
The WLC usually connects via a trunk port, aggregating WLAN traffic from many APs.
Link Aggregation Groups (LAG) can be used 
between controllers and switches for higher bandwidth and redundancy.


### 2.8 Describe network device management access (Telnet, SSH, HTTP, HTTPS, console, TACACS+/RADIUS, and cloud managed)

Devices can be managed through different channels:

- **Console:** physical, out-of-band access for initial setup.

- **Telnet:** plaintext, insecure, rarely used today.

- **SSH:** encrypted, standard for CLI-based management.

- **HTTP/HTTPS:** GUI-based management (HTTPS preferred for security).

- **TACACS+ / RADIUS:** centralized authentication, authorization, and accounting, integrating with enterprise identity systems.

- **Cloud management:** modern controllers allow devices to be managed via cloud dashboards, reducing on-premise overhead.


### 2.9 Interpret the wireless LAN GUI configuration for client connectivity, such as WLAN creation, security settings, QoS profiles, and advanced settings

Wireless LAN controllers provide a GUI for creating and managing SSIDs (WLANs).
Admins configure SSID names, 
security policies (WPA2, WPA3, enterprise authentication with RADIUS), 
and QoS profiles to prioritize traffic types like voice or video.
Advanced settings include client isolation, band steering, and load balancing across APs.
Interpreting these correctly ensures clients connect securely and receive appropriate quality of service.


## 3.0 IP Connectivity 

3.1 Interpret the components of routing table
3.1.a Routing protocol code
3.1.b Prefix
3.1.c Network mask
3.1.d Next hop
3.1.e Administrative distance
3.1.f Metric
3.1.g Gateway of last resort

3.2 Determine how a router makes a forwarding decision by default
3.2.a Longest prefix match
3.2.b Administrative distance
3.2.c Routing protocol metric

3.3 Configure and verify IPv4 and IPv6 static routing
3.3.a Default route
3.3.b Network route
3.3.c Host route
3.3.d Floating static

3.4 Configure and verify single area OSPFv2
3.4.a Neighbor adjacencies
3.4.b Point-to-point
3.4.c Broadcast (DR/BDR selection)
3.4.d Router ID

3.5 Describe the purpose, functions, and concepts of first hop redundancy protocols


## 4.0 IP Services

4.1 Configure and verify inside source NAT using static and pools

4.2 Configure and verify NTP operating in a client and server mode

4.3 Explain the role of DHCP and DNS within the network

4.4 Explain the function of SNMP in network operations

4.5 Describe the use of syslog features including facilities and levels

4.6 Configure and verify DHCP client and relay

4.7 Explain the forwarding per-hop behavior (PHB) for QoS, such as classification, marking, queuing, congestion, policing, and shaping

4.8 Configure network devices for remote access using SSH

4.9 Describe the capabilities and functions of TFTP/FTP in the network

## 5.0 Security Fundamentals

5.1 Define key security concepts (threats, vulnerabilities, exploits, and mitigation techniques)

5.2 Describe security program elements (user awareness, training, and physical access control)

5.3 Configure and verify device access control using local passwords

5.4 Describe security password policies elements, such as management, complexity, and password alternatives (multifactor authentication, certificates, and biometrics)

5.5. Describe IPsec remote access and site-to-site VPNs

5.6 Configure and verify access control lists

5.7 Configure and verify Layer 2 security features (DHCP snooping, dynamic ARP inspection, and port security)

5.8 Compare authentication, authorization, and accounting concepts

5.9 Describe wireless security protocols (WPA, WPA2, and WPA3)

5.10 Configure and verify WLAN within the GUI using WPA2 PSK


## 6.0 Automation and Progammability 

6.1 Explain how automation impacts network management

6.2 Compare traditional networks with controller-based networking

6.3 Describe controller-based, software defined architecture (overlay, underlay, and fabric)
6.3.a Separation of control plane and data plane
6.3.b Northbound and Southbound APIs

6.4 Explain AI (generative and predictive) and machine learning in network operations

6.5 Describe characteristics of REST-based APIs (authentication types, CRUD, HTTP verbs, and data encoding)

6.6 Recognize the capabilities of configuration management mechanisms, such as Ansible and Terraform

6.7 Recognize components of JSON-encoded data

---

So this are all the topics. If I know about all of them, I am ready to move to the next phase. 
