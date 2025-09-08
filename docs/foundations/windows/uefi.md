---
title: UEFI Deep Dive
Description: This is a deep dive into what UEFI is, where it comes from, and what to do with it. 
---

# UEFI Deep Dive

## What is UEFI?

UEFI (Unified Extensible Firmware Interface) is the interface 
between your PC’s hardware and your Windows operating system.  
It is not actually part of Windows itself.  
Instead, it ensures that the OS can cleanly interact 
with the wide variety of hardware that makes up your PC.  
It is the modern replacement for the legacy BIOS, 
although the term "BIOS" is still commonly used.  

Main advantages over BIOS include:

- 32/64-bit execution, allowing richer pre-boot environments
- Graphical UI support for firmware settings
- Secure Boot, which verifies signed boot components
- GPT disk support, enabling disks larger than 2TB and more than four partitions

> GPT vs MBR:  
GPT (GUID Partition Table) is a modern disk layout that supports redundancy and larger drives.  
MBR (Master Boot Record) is older, limited to 2TB and four primary partitions.  
UEFI requires GPT for full functionality, especially Secure Boot.

## UEFI Boot Flow

Here is what happens from power-on to OS handoff:

1. **Power-On & POST**  
   The system powers up and performs a POST (Power-On Self Test).  
   This checks basic hardware like CPU, RAM, and GPU to ensure the system is stable enough to boot.

2. **Firmware Scan**  
   UEFI firmware scans connected devices for bootable media.  
   It looks for `.efi` executables in the EFI System Partition (ESP) on GPT disks.

3. **Boot Manager Launch**  
   The firmware loads the boot manager from the ESP.  
   For Windows, this is usually `/EFI/Microsoft/Boot/bootmgfw.efi`.

4. **OS Selection & Handoff**  
   The boot manager reads the Boot Configuration Data (BCD) and selects the OS loader.  
   Once selected, control is handed off to `winload.efi`, which begins loading Windows.

## ESP – EFI System Partition

The ESP is a small, hidden FAT32 partition on your disk.  
It is where UEFI firmware looks for bootloaders and boot-related files.

Typical contents include:

- `/EFI/Microsoft/Boot/bootmgfw.efi`  
  The Windows Boot Manager. It reads the BCD store and launches `winload.efi`.

- `/EFI/Boot/bootx64.efi`  
  A fallback bootloader used if no specific boot entry is found.

- `/EFI/Microsoft/Boot/BCD`  
  The Boot Configuration Data store. Contains boot entries and settings.

- `/EFI/Microsoft/Boot/memtest.efi`  
  Windows Memory Diagnostic tool.

- `/EFI/Microsoft/Recovery/`  
  Recovery environment files, if present.

> Note: The ESP does not get a drive letter in Windows by default.  
You can mount it manually using `diskpart` or access it via recovery tools.


## UEFI Variables & NVRAM

UEFI firmware doesn’t just boot the system, 
it also stores persistent configuration data in something called **NVRAM** (non-volatile RAM).  
This is where UEFI variables live: 
tiny pieces of data that survive reboots and power cycles.

These variables are used for things like:

- Boot order and boot entries
- Secure Boot keys and state
- Firmware settings (like enabling/disabling devices)
- OS handoff flags and diagnostics

They’re stored on the motherboard, not the disk.  
Even if you wipe your drive, these variables stick around, 
which is both useful and a little spooky.

> Think of NVRAM as the firmware’s own little registry.  
It’s not huge, but it’s powerful — and it can be abused.

### How to View and Edit UEFI Variables

On Windows, you can use:

- `bcdedit` → to inspect boot entries stored in NVRAM
- `powershell` → with `GetFirmwareEnvironmentVariable`
- Third-party tools like **UEFI Tool**, **efibootmgr** (on Linux), or even UEFI Shell

Example:

```powershell
GetFirmwareEnvironmentVariable -Name "BootOrder" -Namespace "{8BE4DF61-93CA-11D2-AA0D-00E098032B8C}"
```

### Security Implications

This is where things get interesting:

- **Persistence**: Malware can store flags or payload triggers in NVRAM.  
  Even if the OS is reinstalled, the variable stays.

- **Boot Hijacking**: A rogue boot entry can point to a malicious .efi binary.  
  If Secure Boot is off, it might run silently.

- **Data Exfiltration**: In theory, small bits of data (like a key or timestamp) 
  could be hidden in unused variables.

- **Detection Evasion**: Since NVRAM isn’t scanned by most AV tools, 
  it’s a stealthy place to hide indicators.

Tip: Always check for unexpected boot entries or strange firmware variables.  
They might be leftovers from a previous operation or breadcrumbs from someone else.

---

This part of UEFI is often overlooked, but it’s where the firmware gets personal.  
It remembers things. And if you know how to talk to it, it can tell you a lot.




