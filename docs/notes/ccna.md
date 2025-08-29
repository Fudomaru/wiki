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


### 1.7 Describe private IPv4 addressing

### 1.8 Configure and verify IPv6 addressing and prefix

### 1.9 Describe IPv6 address types
#### 1.9.a Unicast (global, unique local, and link local)
#### 1.9.b Anycast
#### 1.9.c Multicast
#### 1.9.d Modified EUI 64

### 1.10 Verify IP parameters for Client OS (Windows, Mac OS, Linux)

### 1.11 Describe wireless principles
#### 1.11.a Nonoverlapping Wi-Fi channels
#### 1.11.b SSID
#### 1.11.c RF
#### 1.11.d Encryption

### 1.12 Explain virtualization fundamentals (server virtualization, containers, and VRFs)

### 1.13 Describe switching concepts
##### 1.13.a MAC learning and aging
##### 1.13.b Frame switching
##### 1.13.c Frame flooding
##### 1.13.d MAC address table

## 2.0 Network Access

2.1 Configure and verify VLANs (normal range) spanning multiple switches
2.1.a Access ports (data and voice)
2.1.b Default VLAN
2.1.c InterVLAN connectivity

2.2 Configure and verify interswitch connectivity
2.2.a Trunk ports
2.2.b 802.1Q
2.2.c Native VLAN

2.3 Configure and verify Layer 2 discovery protocols (Cisco Discovery Protocol and LLDP)

2.4 Configure and verify (Layer 2/Layer 3) EtherChannel (LACP)

2.5 Interpret basic operations of Rapid PVST+ Spanning Tree Protocol
2.5.a Root port, root bridge (primary/secondary), and other port names
2.5.b Port states (forwarding/blocking)
2.5.c PortFast
2.5.d Root guard, loop guard, BPDU filter, and BPDU guard

2.6 Describe Cisco Wireless Architectures and AP modes

2.7 Describe physical infrastructure connections of WLAN components (AP, WLC, access/trunk ports, and LAG)

2.8 Describe network device management access (Telnet, SSH, HTTP, HTTPS, console, TACACS+/RADIUS, and cloud managed)

2.9 Interpret the wireless LAN GUI configuration for client connectivity, such as WLAN creation, security settings, QoS profiles, and advanced settings

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
