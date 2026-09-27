---
title: Schtasks
description: A deep dive into the Windows Task Scheduler from the command line — anatomy, core operations, why it is abused, and the events that give it away.
---

# Schtasks

`schtasks.exe` is the command-line front end to the Windows Task Scheduler. It creates, queries, changes, runs, ends, and deletes scheduled tasks on a local or remote machine. Every Windows box ships with it, every administrator relies on it, and it shows up constantly in incident reports.

That last point is why it earns a page here. `schtasks` is a textbook **LOLBAS** — Living Off The Land Binary. It is signed, trusted, and already present, so a task it launches blends into the noise of normal administration. Understanding it in depth means understanding one of the most common persistence primitives on Windows — and, more usefully for the defender, knowing exactly where it leaves fingerprints.

| | |
|---|---|
| **Type** | Built-in Windows utility (LOLBAS) |
| **Binary** | `C:\Windows\System32\schtasks.exe` |
| **ATT&CK** | [T1053.005 — Scheduled Task](https://attack.mitre.org/techniques/T1053/005/) |
| **Task store** | `C:\Windows\System32\Tasks\` + registry |

---

## Why Schtasks Matters

- **Persistence:** A task that fires at logon, at boot, or on a timer survives reboots without touching a service or an autorun key everyone already watches. This is the single most common reason it appears in intrusions.
- **Privilege context:** Tasks can be registered to run as `SYSTEM`, so an admin-level foothold can schedule work at the highest privilege on the box.
- **Remote reach:** `schtasks /s` targets another host, which is why it turns up in lateral-movement chains alongside tools like PsExec.
- **Detection:** Task creation and execution are logged, and every task lands on disk and in the registry. Knowing where to look turns this from a blind spot into a hunting surface — the heart of this page.

`schtasks` doesn't break anything on its own. It is a scheduler. The security weight is entirely in *what* gets scheduled and *as whom* — which is precisely what a defender inspects.

---

## Anatomy of a Task

Most of the power lives in a handful of flags on `/create`. These are the ones worth knowing on sight — as much for reading a suspicious task as for writing a legitimate one:

| Flag | Meaning |
|------|---------|
| `/tn` | **T**ask **n**ame (can include a folder path, e.g. `\Backups\Nightly`) |
| `/tr` | **T**ask **r**un — the program or command line to execute |
| `/sc` | **Sc**hedule type: `MINUTE`, `HOURLY`, `DAILY`, `ONLOGON`, `ONSTART`, `ONIDLE` |
| `/mo` | **Mo**difier — the interval (e.g. `/sc MINUTE /mo 5` = every 5 minutes) |
| `/st` | **S**tart **t**ime (`HH:MM`) |
| `/ru` | **R**un as **u**ser — a named account, a service account, or `SYSTEM` |
| `/rp` | **R**un **p**assword for that user |
| `/rl` | **R**un **l**evel — `LIMITED` or `HIGHEST` |
| `/s` | Target **s**ystem — a remote host |
| `/u` `/p` | Credentials to authenticate to the remote `/s` host |
| `/f` | **F**orce — overwrite an existing task without prompting |

### Where tasks actually live

A registered task is not just an abstract entry — it exists in two concrete places, and both matter for triage and cleanup:

- **On disk:** an XML file at `C:\Windows\System32\Tasks\<TaskName>` (subfolders map to the task's folder path).
- **In the registry:** under
  `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\`
  with the task definition mirrored under `\Tasks\{GUID}`.

A task present in one location but not the other is a broken — and suspicious — state. See the [Windows Registry deep dive](../../foundations/windows/winregistry.md) for how these keys are laid out.

---

## Core Operations

### Create

```cmd
schtasks /create /sc DAILY /st 02:00 /tn "Backups\Nightly" /tr "C:\scripts\backup.cmd"
```

### Query

Listing every task is noisy; the flags that make it useful:

```cmd
schtasks /query /fo LIST /v                 :: verbose, one block per task
schtasks /query /tn "Backups\Nightly" /xml  :: dump the task's full XML definition
```

`/v` reveals the fields that matter in triage: **Run As User**, **Task To Run**, **Schedule**, and **Last/Next Run Time** — exactly what you check when a task looks out of place.

### Run, Change, Delete

```cmd
schtasks /run    /tn "Backups\Nightly"                          :: fire it now
schtasks /change /tn "Backups\Nightly" /tr "C:\scripts\new.cmd" :: repoint the target
schtasks /delete /tn "Backups\Nightly" /f                       :: remove it (/f = no prompt)
```

`/change` is worth flagging: it repoints the `/tr` of an *existing* task. From a defender's view this means a long-lived, trusted task quietly starting to run something new is just as worth investigating as a brand-new one — the creation event is not the only signal.

---

## Offensive Practice

!!! warning "Lab context"
    The points below describe *why* attackers reach for `schtasks`, at a conceptual level, so you can recognise the pattern in a lab or an investigation. They are not a deployment recipe. Practise only on machines you own or are explicitly authorised to test.

Three properties make the scheduler attractive to an attacker, and each maps to something a defender can watch for:

- **Run at a trigger.** `ONLOGON` and `ONSTART` schedules re-launch something automatically after a reboot — the mechanical basis of persistence. The tell is a task whose action is a script, a LOLBin, or a binary in a user-writable path rather than a signed program under `Program Files`.
- **Run as SYSTEM.** With admin rights a task can be registered under the SYSTEM account. The tell is any non-Microsoft task whose *Run As User* is `SYSTEM`.
- **Repoint an existing task.** As noted above, `/change` alters what a trusted task runs, which is stealthier than a new task. The tell is a modification to a task's action long after it was created.

### Proof of mechanism (harmless)

To *see* persistence fire without any payload, register a task that simply appends a timestamp to a marker file at each logon, then inspect it and clean up:

```cmd
schtasks /create /sc ONLOGON /tn "LabDemo\Marker" ^
  /tr "cmd /c echo %DATE% %TIME% >> C:\Temp\lab-marker.txt"

schtasks /query  /tn "LabDemo\Marker" /fo LIST /v
:: log off and back on, then check C:\Temp\lab-marker.txt

schtasks /delete /tn "LabDemo\Marker" /f
```

That is enough to internalise the create → trigger → verify loop. The marker file stands in for whatever an attacker would schedule; the value here is understanding the mechanism and, more importantly, what it leaves behind — which the next section reads back.

---

## Defensive Practice

This is where the tool pays off. Every operation above is observable.

### Event log

The Security log records the lifecycle of a task (audit policy permitting):

| Event ID | Meaning |
|----------|---------|
| **4698** | A scheduled task was **created** |
| **4699** | A scheduled task was **deleted** |
| **4700 / 4701** | A task was **enabled / disabled** |
| **4702** | A scheduled task was **updated** (the `/change` signal) |

Richer detail sits in the dedicated operational channel:
`Microsoft-Windows-TaskScheduler/Operational` — task registration, every run, and completion, with the action and account attached.

### Hunt the task store directly

Events can be cleared; the task itself has to exist to run. Enumerate and read the definitions:

```cmd
schtasks /query /fo LIST /v > C:\Temp\tasks.txt
```

Then sort for the tells from the offensive section: a `Run As User` of `SYSTEM` on a non-Microsoft task, an action pointing at a script or a user-writable directory, a `\Tasks\` XML file with no matching registry entry, or a recent write time on an old task. Cross-reference disk (`C:\Windows\System32\Tasks\`) against the registry `TaskCache` tree — a mismatch is a strong lead.

### Harden

- Restrict who may register tasks via Group Policy (`Log on as a batch job` / task-scheduler rights).
- Turn on **auditing of object access / other policy change** so 4698-family events are actually written.
- Forward the Security and `TaskScheduler/Operational` logs to your SIEM and alert on 4698 for `SYSTEM`-context tasks. See the [Event Viewer deep dive](../../foundations/windows/eventviewer.md) for working with these channels.

---

## Key Takeaway

`schtasks` is dual-use by nature: the same command that schedules a nightly backup can plant persistence that outlives a reboot. There is no patch for that — the scheduler is *supposed* to run programs on triggers. The leverage for a defender is that the tool is loud when you know where it speaks: two files (disk + registry), a handful of Event IDs, and a dedicated operational log. Learn to read a task's *Run As User*, *action*, and *trigger* at a glance, and a suspicious one stops hiding.

---

## Integration

- [Windows CLI Magic](../../foundations/windows/cli-magic.md)
- [Windows Registry](../../foundations/windows/winregistry.md)
- [Windows Event Log](../../foundations/windows/eventviewer.md)
- [Privilege Escalation](../privilege-escalation.md)
- [Metasploit](metasploit.md)
