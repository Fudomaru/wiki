---
title: Linux Internals
description: Describtion of the inner workings of a Linux systems. 
---

# Prcesses & Signals 

??? warning
    This page is a placeholder


## Why this?

This is a core Linux topic.  
It is always relevant and opens the door for advanced topics like scripting, scheduling and system recovery.  
If you don't know how Linux handles processes and how you see and handle them, it is very hard to do anything.  

## What is a Process? 

A process is a running instance of a program, identified by a PID.  

## Basic Commands: 

`ps aux` list all running prcesses  
`top` / `htop` live monitoring  
`kill <PID>` kill process by PID  
 `pmap <PID>` showes memory usage  

## Common Signals

| Signal | Explaination |
|-|-|
| **SIGTERM** | polite kill |
| **SIGKILL** | brute-force, can't be caught |
| **SIGINT** | interrupt |
| **SIGSTOP** | pause |
| **SIGCONT** | resume |