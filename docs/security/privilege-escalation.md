---
title: Privilege Escalation
description: From user to root — the art of climbing the permission ladder.
---

# Privilege Escalation

!!! abstract
    Privilege Escalation is the art of exploiting a bug, design flaw, or configuration oversight in an operating system or software application to gain elevated access to resources that are normally protected from an application or user. The result is that an application with more privileges than intended by the developer or system administrator can perform unauthorized actions.

---

## The Goal

The goal is simple: start as a low-level user, and end up with the highest possible privileges on a system. On Linux, this is `root`. On Windows, this is `NT AUTHORITY\SYSTEM`.

This phase of an attack is often the difference between seeing a small part of a system and owning it completely.

---

## Core Concepts

Before hunting for exploits, it’s crucial to understand the underlying mechanics of privilege.

### Vertical vs. Horizontal Escalation

- **Vertical Privilege Escalation:** The most common form, where a lower-privilege user or application gains higher privileges. This is our focus.
- **Horizontal Privilege Escalation:** When a user gains access to the resources of another user with the same level of privileges.

### The Principle of Least Privilege

This is the defensive principle we seek to exploit. It states that a user or process should only have the minimum privileges necessary to perform its function. When this principle is violated, we find our opportunities.

---

## The Methodology

A structured approach is more effective than running random exploits.

1.  **Enumerate:** Collect as much information about the system as possible. Kernel version, running services, scheduled tasks, user permissions, etc. This is the most critical step.
2.  **Identify Vectors:** Based on the enumeration, identify potential paths to escalation.
3.  **Exploit:** Execute the chosen exploit, carefully.
4.  **Stabilize & Document:** Secure your new access and document the path you took.

---

## Common Vectors

### Linux

- **Kernel Exploits:** Leveraging vulnerabilities in the OS kernel itself. Often risky, but powerful.
- **Misconfigured Services:** Services running as `root` that can be manipulated.
- **SUID/GUID Binaries:** Executables that run with the permissions of the owner (e.g., `root`) rather than the user who is running them.
- **Weak File Permissions:** Being able to read or write files you shouldn't have access to, like `/etc/shadow`.
- **Cron Jobs:** Hijacking scripts that are scheduled to run as a higher-privileged user.

### Windows

- **Unquoted Service Paths:** If a service path is not wrapped in quotes and contains spaces, Windows may execute a malicious binary placed in a parent directory.
- **Insecure Service Permissions:** Services where a low-privilege user has been granted permissions to modify or restart the service.
- **Registry Abuse:** Finding weak permissions in the registry that allow for modification of service binaries or other system components.
- **AlwaysInstallElevated:** A policy that, if enabled, allows any user to install `.msi` packages with elevated privileges.
- **DLL Hijacking:** Placing a malicious DLL in a location where an application will load it with high privileges.

---

## Defense & Mitigation

Understanding the attack is only half the battle.

- **Patch Regularly:** The simplest defense against kernel exploits.
- **Enforce Least Privilege:** Don't run services as `root` if they don't need to be. Use dedicated service accounts.
- **Monitor:** Look for anomalous behavior, such as a user suddenly gaining new privileges.
- **Harden Configurations:** Use tools to audit your systems for common misconfigurations.

!!! tip
    From a defensive perspective, your goal is to make the enumeration phase as difficult as possible for an attacker. The less they know, the harder it is for them to find a path to escalation.
