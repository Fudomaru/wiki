--- 
title: Schtasks
description: A deep dive into the Windows Task Scheduler.
---

# Schtasks

`schtasks.exe` is a Windows command-line utility used to manage scheduled tasks on a local or remote computer. It allows users to create, delete, query, change, run, and end scheduled tasks. 

While it is a legitimate and powerful tool for system administration, it is also frequently abused by malicious actors for persistence, privilege escalation, and lateral movement. This dual-use nature makes it a critical tool to understand for both offensive and defensive security practitioners.

??? info "Note on spelling"
    The term "schtaks" was used in the warboard, which is a common misspelling of `schtasks`. This page uses the correct spelling.

---

## Why Schtasks Matters

- **Red Teaming / Pentesting:** `schtasks` is a go-to tool for establishing persistence on a compromised host. A reverse shell can be scheduled to run at regular intervals, ensuring continued access.
- **Blue Teaming / Defense:** Monitoring `schtasks` usage is crucial for detecting malicious activity. Unusual task creation or modification can be an indicator of compromise.
- **Living Off The Land (LOLBAS):** As a built-in Windows utility, `schtasks` is a prime example of a LOLBAS. Attackers can use it to blend in with normal administrative activity, making detection more difficult.

---

## Core Functions of Schtasks

### 1. Create a Task
- Creates a new scheduled task.
- Command example: `schtasks /create /sc minute /mo 1 /tn "My Task" /tr "C:\path\to\my.exe"`

### 2. Query Tasks
- Displays all scheduled tasks on the system.
- Command example: `schtasks /query`

### 3. Run a Task
- Manually runs a scheduled task.
- Command example: `schtasks /run /tn "My Task"`

### 4. Delete a Task
- Deletes a scheduled task.
- Command example: `schtasks /delete /tn "My Task"`

### 5. Change a Task
- Modifies the properties of a task, such as the program it runs or the schedule.
- Command example: `schtasks /change /tn "My Task" /tr "C:\new\path\to\my.exe"`

---

## How to Think About Schtasks

### Offensive Perspective (Red Team)

- **Persistence:** Create a scheduled task to run a payload at system startup or on a recurring basis.
- **Privilege Escalation:** If you have administrative privileges, you can create tasks that run with `SYSTEM` privileges.
- **Lateral Movement:** Use `schtasks` to create tasks on remote systems, allowing you to execute code and spread through a network.

### Defensive Perspective (Blue Team)

- **Monitor Task Creation:** Look for suspicious task creation events in the Windows Event Logs (Event ID 4698).
- **Analyze Task Properties:** Regularly review scheduled tasks for suspicious names, executables, or run times.
- **Harden Configurations:** Use Group Policy to restrict who can create scheduled tasks.

---

## Integration with Workflow

- **SIEM:** Forward `schtasks` related events to your SIEM for correlation and alerting.
- **Automation:** Use scripts to automate the review of scheduled tasks across your environment.

---

## Key Takeaway

`schtasks` is a powerful and versatile tool that can be used for both good and evil. Understanding its capabilities and how it can be abused is essential for any security professional. Whether you are on the offensive or defensive side, `schtasks` is a tool that you need to have in your arsenal.

---

## Integration

- [Windows CLI Magic](../../foundations/windows/cli-magic.md)
- [Privilege Escalation](../privilege-escalation.md)
