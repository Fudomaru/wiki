---
title: "Linux Fundamentals – From Firmware to Userspace"
description: "A high-level learning map of the Linux startup process — covering the kernel and common early userspace until distribution-specific layers take over."
---

# **Overview**

## **Introduction**
This is not a distro war or a kernel hacker’s whitepaper.  
It’s my **learning map** — an outline of how Linux comes alive, from firmware to the point where distributions layer on their own systems.

Each phase is in broad strokes: concise enough to fit in my head, but ready to be expanded when I dive deeper.  
This is my navigation aid when troubleshooting, my checklist when something breaks, and my reminder that while the word “Linux” often means “a whole OS,” the kernel is just one — very important — piece.

---

## **Phase 1 – Firmware & Bootloader**

**Firmware (BIOS/UEFI)**  
- Runs POST, initializes hardware, and finds the bootloader.  
- On UEFI systems, reads EFI System Partition to locate bootloader `.efi` file.  

**Secure Boot (optional)**  
- Verifies bootloader signatures before handing off control (varies by distro config).

**Bootloader**  
- Common: GRUB, systemd‑boot, LILO (rare now).  
- Presents boot menu, chooses kernel/initramfs, passes kernel parameters.  
- Loads Linux kernel and initial RAM disk (initrd/initramfs) into memory.

---

## **Phase 2 – Kernel Initialization**

**Decompression & Start**  
- Kernel binary unpacks itself into memory and begins executing `start_kernel()`.

**Hardware Detection & Drivers**  
- Initializes CPU, memory, timers.  
- Detects buses (PCI, USB, etc.) and loads built‑in or initramfs‑supplied drivers.

**Mount root (temporary)**  
- Mounts initramfs as the initial root filesystem.  
- Provides space for early userspace tools before the “real” root is mounted.

**Initramfs Tasks**  
- Loads extra drivers/modules needed to access the real root filesystem.  
- Sets up device nodes via `udev` or a minimal equivalent.  
- Handles disk decryption (LUKS), RAID assembly, or filesystem checks if needed.

**Switch Root**  
- Mounts the actual root filesystem and pivots away from the initramfs.

---

## **Phase 3 – Early Userspace (Kernel → Init Process)**

**Init Process Start**  
- Kernel executes the first process (`/sbin/init` by default).  
- Can be `systemd`, `SysV init`, `OpenRC`, `runit`, `s6`, etc., depending on the distro.

**Responsibilities here**  
- Mount essential pseudo‑filesystems: `/proc`, `/sys`, `/dev`.  
- Start early daemons required for the system to function.  
- Configure basic networking (if set to start this early).

---

## **Phase 4 – Distribution Layer**

From here, the **shared “Linux” story** branches into **distro‑specific policy**:

**Init System & Service Management**  
- `systemd` (Debian, Fedora, Arch, etc.)  
- `OpenRC` (Gentoo, Alpine)  
- `runit` (Void Linux)  
- `s6` (specialized/minimalist setups)  

**What the Distro Adds on Top**  
- Default services, daemons, and configuration defaults.  
- Package manager (APT, DNF, pacman, apk, nix, etc.).  
- Userland tools and shells (Bash, Zsh, dash).  
- Graphical stack: X11, Wayland, desktop environments (GNOME, KDE, etc.) or minimal WM.

This is the point where two systems both “running Linux” can behave very differently.

---

## **Phase 5 – Where I Go From Here**

1. **Make a Distro List**  
   - Example: Debian, Arch, Void, NixOS, Fedora, Alpine, Gentoo.  

2. **Per‑Distro Pages**  
   - What’s the same?  
   - What’s different (init system, package manager, filesystem layout, service defaults)?  
   - What you can expect when troubleshooting or securing the system.

---

## **Closing Note**
By separating the **universal Linux startup** from the **distro layer**, I keep one clean mental model for everything the kernel does — and avoid mixing it up with the policies and tools each distro bolts on.  
From firmware to init, the process is surprisingly consistent; after that, it’s all about the choices the distribution makes.

