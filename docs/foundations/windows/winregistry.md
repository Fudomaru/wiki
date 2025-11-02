---
title: Windows Registry
description: A deep dive into the Windows Registry — the central nervous system of the OS.
---

# Windows Registry

## Introduction

The Windows Registry is not just a configuration database. It is the operating system’s central nervous system. It dictates how Windows starts, what hardware it trusts, what software is installed, and who can do what. To understand the Registry is to understand how Windows thinks.

This is my map of that territory. It is not a complete reference, but a guide to the key structures, concepts, and locations that matter for system administration, security analysis, and troubleshooting.

## Core Concepts

### Hives

The Registry is not a single monolithic file. It is a collection of files called **hives**. Each hive is a self-contained database that corresponds to a top-level key. Hives are loaded into memory at boot or when a user logs in.

- **SYSTEM:** `\Windows\System32\config\SYSTEM` - Critical system settings, services, and boot configuration.
- **SOFTWARE:** `\Windows\System32\config\SOFTWARE` - Software and application settings for all users.
- **SAM:** `\Windows\System32\config\SAM` - Local user account and group information (Security Accounts Manager).
- **SECURITY:** `\Windows\System32\config\SECURITY` - Security policies and user rights assignments.
- **DEFAULT:** `\Windows\System32\config\DEFAULT` - Default settings for new user profiles.
- **NTUSER.DAT:** `\Users\<username>\NTUSER.DAT` - User-specific settings for a logged-in user.

### Root Keys

The Registry is organized into a hierarchical structure of keys, subkeys, and values. There are several root keys, each providing a different view into the hives.

- **HKEY_LOCAL_MACHINE (HKLM):** Contains machine-specific settings that apply to all users. This is a view into the SAM, SECURITY, SOFTWARE, and SYSTEM hives.
- **HKEY_CURRENT_USER (HKCU):** Contains the settings for the currently logged-in user. This is a view into the `NTUSER.DAT` file of the current user.
- **HKEY_USERS (HKU):** Contains the `NTUSER.DAT` for all loaded user profiles, including the default profile.
- **HKEY_CLASSES_ROOT (HKCR):** Provides a view of file associations and COM object registrations. It's a merged view of `HKLM\Software\Classes` and `HKCU\Software\Classes`.
- **HKEY_CURRENT_CONFIG (HKCC):** Contains information about the current hardware profile. This is a view of `HKLM\System\CurrentControlSet\Hardware Profiles\Current`.

### Values

Each key can contain values, which store the actual configuration data. There are several types of values:

- **REG_SZ:** A fixed-length string.
- **REG_EXPAND_SZ:** A variable-length string that can contain environment variables.
- **REG_BINARY:** Raw binary data.
- **REG_DWORD:** A 32-bit number.
- **REG_QWORD:** A 64-bit number.
- **REG_MULTI_SZ:** A multi-line string.

## Key Registry Paths

Certain Registry paths are critical for understanding system behavior.

### Persistence

- **Run Keys:** These keys are a common place for programs to register themselves to run at startup.
    - `HKLM\Software\Microsoft\Windows\CurrentVersion\Run`
    - `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`
    - `HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce`
    - `HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce`
- **Services:** The configuration for all system services.
    - `HKLM\System\CurrentControlSet\Services`

### System Information

- **Operating System:** Information about the OS version, build, and installation date.
    - `HKLM\Software\Microsoft\Windows NT\CurrentVersion`
- **Hardware:** Information about the system's hardware.
    - `HKLM\HARDWARE`

### User Activity

- **TypedURLs:** A history of URLs typed into Internet Explorer.
    - `HKCU\Software\Microsoft\Internet Explorer\TypedURLs`
- **UserAssist:** A record of programs launched by the user.
    - `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist`

## Security Implications

The Registry is a primary target for both attackers and defenders.

- **Attackers:** Use the Registry for persistence, privilege escalation, and to store malicious configuration data.
- **Defenders:** Monitor the Registry for unauthorized changes, hunt for malware, and harden system configurations.

Understanding the Registry is not optional for serious security work on Windows. It is a fundamental skill.

## Closing Note

The Registry is vast and complex, but it is not unknowable. By focusing on the core concepts and key locations, I can build a mental model that allows me to navigate it effectively. This page is the start of that model. It is a map that I will continue to refine as I explore this critical part of the Windows operating system.
