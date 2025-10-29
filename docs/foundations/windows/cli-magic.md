---
title: Windows CLI Magic
description: This is a page to gather all the most used Windows CLI tools to know in Windows.
--- 

# Windows CLI Magic

These are the commands I reach for when Windows gets real.
Not a reference manual, more a survival kit. 
Split into CMD and PowerShell, 
because each has its own quirks, strengths, and use cases.

---

##  CMD Essentials

Old-school, still useful. 
Especially when scripting in constrained environments 
or dealing with legacy systems.

### Navigation & Discovery

- `cd` : Change directory.
- `dir` : List contents of a directory. Use `/A` to show hidden files.
- `tree` : Visualize folder structure.
- `echo %USERNAME%` : Show current user.

### System Info & Control

- `tasklist` : List running processes.
- `taskkill /PID 1234 /F` : Kill a process by PID.
- `systeminfo` : Dump OS version, uptime, hotfixes.
- `set` : View or set environment variables.

### Networking

- `ipconfig` : Show IP config. Use `/all` for full detail.
- `ping`, `tracert`, `netstat` : Basic network diagnostics.
- `nslookup` : DNS queries.
- `net use` : Map network drives.
- `net user` : Manage local users.

### File & Disk

- `copy`, `xcopy`, `robocopy` : File copying tools.
- `del`, `erase` : Delete files.
- `attrib` : View/set file attributes.
- `chkdsk` : Check disk health.
- `diskpart` : Partition manager.

### Misc

- `cls` : Clear screen.
- `type` : View file contents.
- `findstr` : Search inside files.
- `fc` : Compare two files.
- `shutdown /r /t 0` : Reboot instantly.

---

## ⚡ PowerShell Essentials

Modern, object-oriented, and scriptable. 
This is where Windows gets powerful.

### Navigation & Discovery

- `Get-Location` : Like `pwd`.
- `Set-Location` : Like `cd`.
- `Get-ChildItem` : Like `ls`. Use `-Recurse` to go deep.
- `Resolve-Path` : Like `readlink`.

### System Info & Control

- `Get-Process` : List processes.
- `Stop-Process -Id 1234` : Kill process.
- `Get-Service` : List services.
- `Restart-Service` : Restart a service.
- `Get-EventLog` : View logs.

### Networking

- `Test-Connection` : Like `ping`.
- `Resolve-DnsName` : Like `nslookup`.
- `Get-NetIPAddress` : IP config.
- `New-PSSession` : Remote PowerShell session.
- `Invoke-WebRequest` : Like `curl`.

### File & Text

- `Get-Content` : Like `cat`.
- `Set-Content`, `Add-Content` : Write to files.
- `Select-String` : Like `grep`.
- `Out-File` : Redirect output.
- `Compare-Object` : Compare data sets.

### Security & Identity

- `Get-LocalUser`, `Get-LocalGroup` : Manage users/groups.
- `Get-Credential` : Prompt for secure credentials.
- `Get-Acl`, `Set-Acl` : View/set permissions.

### Misc

- `Get-Help` : Built-in docs.
- `Get-History` : Command history.
- `Start-Job`, `Receive-Job` : Background tasks.
- `$env:USERNAME` : Environment variables.
- `Measure-Command` : Time execution.

---

##  Tips & Real Use Cases

- `Get-Content large.log | Select-String "error"`  Search logs for errors.
- `Invoke-WebRequest -Uri "http://target" -OutFile "page.html"` : Grab a webpage.
- `Get-Process | Sort-Object CPU -Descending | Select-Object -First 5` : Top CPU hogs.
- `Get-ChildItem -Recurse | Where-Object { $_.Length -gt 1MB }` : Find big files.

---

