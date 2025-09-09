---
title: Linux Internals
description: Notes on how Linux handles processes and signals — the building blocks of system control.
---

# Processes & Signals

This page is about how Linux manages running programs — how they’re created, monitored, and controlled.  
It’s a core topic that connects directly to scripting, scheduling, service management, and system recovery.

## What is a Process?

A process is a running instance of a program.  
Each process has a unique PID (Process ID) and runs in its own memory space.  
Processes can spawn other processes, communicate with each other, and respond to signals.

## Basic Commands

- `ps aux`  
  Lists all running processes with details like PID, CPU usage, and command.

- `top` / `htop`  
  Live monitoring of system resources and active processes.

- `kill <PID>`  
  Sends a signal to a process — usually to terminate it.

- `pmap <PID>`  
  Shows memory usage of a specific process.

## Common Signals

| Signal      | Description                       |
|-------------|-----------------------------------|
| **SIGTERM** | Graceful termination request      |
| **SIGKILL** | Forceful kill, cannot be caught   |
| **SIGINT**  | Interrupt from keyboard (Ctrl+C)  |
| **SIGSTOP** | Pause the process                 |
| **SIGCONT** | Resume a stopped process          |

## What’s Next

This page will grow to include:

- Process states and lifecycle  
- Foreground vs background jobs  
- Daemons and service management  
- Signal handling in scripts  
- Scheduling with `cron` and `at`

This is one of the leaves under my Linux branch.  
It’s where I collect the tools and concepts that help me understand what’s running — and how to control it.
|
