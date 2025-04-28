---
title: Linux CLI
description: Common linux CLI, what they do and how to use them.
---

# CLI Magic

These are the commands I reach for when things get real.

## Navigation & Discovery

- [`cd`](#cd)
- [`ls`](#ls)
- [`find`](#find) 
- [`tree`](#tree)
- [`du`](#du) 
- `df` 
- `pwd` 
- `readlink` 

## System Info & Process Control

- [`top`](#top) 
- [`htop`](#htop)
- [`ps`](#ps)
- `lsof`
- `uptime`
- `free`
- `vmstat` 
- `dmesg`

## File & Text Manipulation

- [`cat`](#cat)
- `less`
- `head`
- `tail`
- `cut`
- `sort`
- [`uniq`](#uniq)
- `awk`
- `sed`
- `wc`
- `xargs`
- `tee`

## Permissions & Users
- [`chmod`](#chmod)
- `chown`
- `usermod`
- `whoami`
- `groups`
- `sudo`
- `passwd`

## Networking
- [`ping`](#ping)
- `ip`
- `ss`
- [`ssh`](#ssh)
- `netstat`
- `dig`
- `nslookup`
- `curl`
- `wget`
- `traceroute`
- `nmap`
- [`nc`](#nc)

## Archives & Packages
- `tar`
- `zip`
- `unzip`
- `dpkg`
- `apt`
- `rpm`
- `dnf`
- `pacman`

## Dangerous but Useful
- `rm -rf`
- `dd`
- `mkfs`
- `mount`
- `umount`
- `kill`
- `pkill`
- `reboot`
- `shutdown`

## Misc & Meta
- `alias`
- `history`
- `!` 
- `man`
- `which`
- `type`
- `time`
- `yes`

---

<!--

Format suggestion for each command:

#### command

***What it does:***  

***Real use case:***

***Example:***

***Tip:***


--> 

---

#### cat

***What it does:*** It shows what is inside the file you append.  

***Example:*** I use it all the time to read out the flag on some CTF's. 

***Tip:*** Awesomt for any automation, where you want to work with some text inside a file.  
 Just use `cat | secondCommand`.  
That also makes it perfect for searching though large files, like logs, together with `grep`

---

#### cd

***What it does:*** Let's you move to the directory of your choosing.  

***Tip:*** Don't forget about the special usecases:  

- `..` move up the file structure
- `~` move to home directory of the current user
- `/` move to root, but also let's you move anywhere you want, as long as you know the path

---

#### chmod

***What it does:***  
Used to change permissions of a file.

***Real use case:***  
Whenever you make a script so you are actually able to run it. 

***Example:***  
In the example above, making a file executable, it would like that `chmod -x [file]`

***Tip:***  
Learning the numbercodes is extremly helpful. First number for the user, second for the group, and last for others. Each digit represents a combination of read (4), write (2), and execute (1). 

---

#### du

***What it does:***  
Calculates actual disk space used by files and directories. 

***Real use case:***
Good to identify how the space is used in case of low disk space.  

***Tip:***  
You can pipe it through `sort -rh` to sort it by biggest size first. 

---

#### find

***What it does:***  
Used to search for files in a specifed directory. You can search for all kinds of properties that you already know about it. 

***Real use case:***  
I used it to find the flag while playing OWT Bandit. For the level you got the size and some of the properties of the flag, and had to find it. 

***Example:***
`find / -user bandit7 -group bandit6 -size 33c 2>/dev/null`  
That is how I found the specific flag. 
***Tip:***  
I really want to remember the 2>/dev/null part for throwing out strerr. 

---

#### htop

***What it does:***  
An enhanced, interactive version of `top` with better visuals and controls. 

***Real use case:***  
Quickly kill, renice, or inspect processes without needing multiple commands

***Tip:***  
It is really important do learn the short cuts and ways to use it to be effectiv. 

---

#### ls

***What it does:***  
Shows the inside of the current directory.

***Tip:***  
Best used with a `-al` flag to list all files in long format.

---

#### nc

***What it does:***  
Used for everything concering connections via TCP or UDP.  
You can do **soo** much with it that it would probably be to much for this little section, and I need to make a whole page for netcat in the futur. 

***Real use case:***
Mainly to set up listeners to get a reverse shell.
That would look something like this:  
`nc -l 1234`  
Also netcat can be used to connect to some port and set it something manuel or in a script. 

---

#### ping

***What it does:***  
Sends an ICMP echo request to a target host. 

***Real use case:***  
Perfect to test if there is a connection. Eighter to the target on the way in, or from the mashine on the way out (by pinging something that is alway reachable)

***Example:***  
`ping 8.8.8.8` to try to ping the google DNS server, which should always work if you have connection to the internet. 

***Tip:*** Is often used to monitor server uptime from afar, by regularly sending a ping. 

---

#### ps

***What it does:***  
Prints out the current processes. 

***Real use case:***  
Audit running processes precisely, grep specific patterns, or script behavior. 

***Tip:***  
`ps faux` shows process hierachy, kind of like tree for files.  
This really helps with finding out where everything is comming from.  

---

#### ssh

***What it does:***  
Creates a secure connetion with access to the local terminal. 

***Real use case:***  
Maintaining remote servers where it is not reasonable to have direkt access, and which might not have a GUI.

***Example:***  
Accessing the Bandit Wargame from OvertheWire:  
`ssh -p 2220 bandit0@bandit.labs.overthewire.org`  

---

#### top

***What it does:***  
Real-time view of system processes and resource usage. 

***Real use case:***  
Monitor CPU and detect runaway processes. 

***Tip:***  
You can press M to sort instantly by memory usage.  

---

#### tree

***What it does:***  
It prints out a skeleton of file system you give it.  
Awesome to get an overview of where everything lives and to better understand what you are working with.  

---  

#### uniq

***What it does:***  
Filter adjacent matching lines. It is mostly used when you have to omit or report repeating lines. Really helpful to dens down loads of data. 

***Real use case:***  
For me it was alo really helpful in one of the OTW Bandit levels. It was mainly designed to teach the `uniq` command, so I am really excited to find some more real world use cases. 


