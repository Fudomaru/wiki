---
title: Windows Overview
description: General explaination of how Windows is build up.
---

# Overview


## Introduction

This page is not a manual and not an expert’s lecture.  
It is my learning map — an outline of how Windows comes alive,  
from firmware to desktop.  

Each phase is written in broad strokes, with one-liners that keep the 
scope small but leave room to expand later.  
It’s a reference for me when I get lost, a checklist when I troubleshoot, 
and a reminder that nothing in Windows is “magic” once you trace it 
back to its roots.  

I’m still learning, and this page shows where I am in that process.  
It doesn’t mean I know every corner of Windows — only that I’ve started 
to chart the territory.  



## Phase 1 - Firmware & Boot Manager

### UEFI frimware 

Initializes hardware, reads the EFI System Partition,
and launches Windows Boot Manager 
(\EFI\Microsoft\Boot\bootmgfw.efi).

### Boot Configuration (BCD)

A registry-like store on the ESP 
that tells Boot Manager which Windows to load 
and how (debug flags, Safe Mode, etc.).

### Secure Boot (optional)

UEFI verifies Microsoft-signed boot components 
so nothing unsigned runs before the kernel.

### BitLocker pre-boot (optional)

If the OS volum is encrypted, 
TPM/pin/unlock happens here so the loader 
can read \windows\System32\drivers\... .

### winload.efi

The OS loader that pulls ntoskrnl.exe,
the HAL and BOOT_START drivers from 
\Windows\System32\drivers\ into memory.

### Early driver class

Only minial storage, filesystem, 
and bus drivers load now, 
just enough to mount the system volume.

### Kernel handoff

Control transfers to the kernel 
with hardware tables (ACPI, memory map)
and loader parameters.


## Phase 2 – Kernel & HAL

### ntoskrnl.exe

The Windows kernel itself. 
Schedules threads, manages memory, 
handles interrupts, and enforces security boundaries.  

### HAL (Hardware Abstraction Layer)

Sits between kernel and raw hardware. 
Normalizes differences across CPUs, chipsets, 
and boards so higher layers don’t care 
about vendor quirks.  

### SYSTEM registry hive

Loaded from disk early, 
contains driver/services config (HKLM\SYSTEM). 
Without this, the kernel has no roadmap.  

### BOOT_START drivers

Critical drivers (storage, filesystem, low-level bus) 
that must load before the OS volume is usable. 
Examples: disk filter drivers, NTFS.  

### Kernel-mode initialization

Core managers spin up:

- **Memory Manager** → virtual memory, paging  
- **Process Manager** → basic process/thread structures  
- **I/O Manager** → unified device I/O model  
- **Security Reference Monitor** → enforces permissions and access checks  

### Transition to session init

When kernel space is stable, 
control is passed to **smss.exe** (Session Manager), 
which marks the boundary into user space.  



## Phase 3 – Session Initialization (User Space)


### smss.exe (Session Manager Subsystem)

First user-mode process. 
Creates Session 0 (system) 
and Session 1+ (interactive users).  
Launches core subsystems and sets up paging files, 
environment variables, 
and handles the transition to user sessions.  

### csrss.exe (Client/Server Runtime Subsystem)

Responsible for console windows, thread creation, 
and parts of the Windows graphical subsystem.  
Critical process — if it dies, the system blue-screens.  

### wininit.exe (Windows Initialization)

Spawns essential system processes:

- **services.exe** (Service Control Manager)  
- **lsass.exe** (Local Security Authority)  
- **lsm.exe** (Local Session Manager)  

### services.exe (Service Control Manager)

Starts and manages Windows services. 
Loads AUTO_START drivers and background services 
that are not kernel-level.  

### lsass.exe (Local Security Authority Subsystem)

Handles authentication (logons, password changes) 
and enforces local security policies.  
Works with SAM (Security Accounts Manager) 
and Active Directory in domain setups.  

### lsm.exe (Local Session Manager)

Coordinates sessions (system vs. user), 
fast user switching, and the framework 
used by Remote Desktop / Terminal Services.  

Note: Remote Desktop itself is optional 
and only starts if enabled 
through services.exe in later phases.

### Transition to logon

At this stage, the system is alive 
enough for a user to authenticate.  
Control passes to **winlogon.exe**, 
which handles secure logon.  


## Phase 4 – Logon & Shell Startup


### winlogon.exe

Handles the secure attention sequence (Ctrl+Alt+Del), 
spawns the logon UI, and passes credentials to LSASS 
for authentication.  

### logonui.exe

The graphical logon screen. Collects username/password, 
or PIN/biometrics, and hands them off securely 
through Winlogon to LSASS.  

### userinit.exe

Runs after successful authentication.  
Initializes the user profile, applies logon scripts, 
and finally launches the shell.  

### explorer.exe

The Windows shell: desktop, Start menu, taskbar, 
and file explorer. Defines the “Windows experience” 
for interactive users.  

### Group Policy Client (gpsvc)

If the system is domain-joined, applies computer and user 
policies at logon. Can control startup scripts, security 
settings, network mappings, and more.  

### Network services

At this point, network connectivity is established through 
`svchost.exe`-hosted services such as:

- **DHCP Client** (auto-configure IP)  
- **DNS Client** (name resolution)  
- **Workstation Service** (network shares, SMB client)  

### System ready

With the kernel, services, and shell running, the system 
is now in a usable state. Optional roles and features 
(IIS, RDP, Hyper-V, etc.) are loaded as services 
on top of this foundation.  



## Phase 5 – Core Foundations

### Registry

A hierarchical database of system and application settings.  
Key hives include:

- **HKLM** (HKEY_LOCAL_MACHINE) → system-wide settings  
- **HKCU** (HKEY_CURRENT_USER) → user-specific settings  
- **SYSTEM** hive → driver and service configuration  

### File system layout

Windows relies on a few critical directories:

- **\Windows\System32** → core executables and DLLs  
- **\Windows\SysWOW64** → 32-bit binaries on 64-bit systems  
- **WinSxS** (Side-by-Side store) → keeps multiple versions of system libraries for compatibility  

### svchost.exe

A generic host process that loads many Windows services 
from DLLs. Multiple instances run, each hosting a group 
of related services.  

### Windows subsystems

Compatibility layers that define what kind of applications can run:

- **Win32** → the main API for modern Windows applications  
- **WOW64** → runs 32-bit apps on 64-bit Windows  
- **Legacy POSIX / OS/2 layers** (historical) → no longer default, but once provided compatibility  

### Authentication & Security

- **LSASS** enforces policies, credentials, and tokens  
- **SAM (Security Accounts Manager)** holds local accounts  
- **Active Directory support** when domain-joined  

### System services

Beyond kernel and drivers, Windows depends on background services 
(networking, print spooler, Windows Update, etc.) managed by 
the Service Control Manager.  

---

## Closing note

By walking the startup phases and these core foundations, 
Windows is no longer a black box: every layer, from firmware 
to shell, sits on knowable structures.  
This page is both a map and a checklist — a reminder of 
where to look when something breaks, or when you want to 
dig deeper into the machinery that makes Windows run.  


