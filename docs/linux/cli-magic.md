---
title: Linux CLI
description: Common linux CLI, what they do and how to use them.
---

# CLI Magic

These are the commands I reach for when things get real.

## Navigation & Discovery

- [`cd`](#cd)
- [`ls`](#ls)
- `find` 
- `tree`
- `locate` 
- `du` 
- `df` 
- `pwd` 
- `readlink`

## System Info & Process Control

- `top` 
- `htop`
- `ps`
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
- `uniq`
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
- `netstat`
- `dig`
- `nslookup`
- `curl`
- `wget`
- `traceroute`
- `nmap`

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


alias  
apt  
awk  
cat     -- done
cd      -- done
chgrp  
chmod   -- done
chown  
curl  
cut  
dd  
df  
dig  
dnf  
dpkg  
dmesg  
du  
find  
free  
groups  
head  
history  
htop  
ip  
kill  
less  
locate 
ls      -- done 
lsof  
man  
mkfs  
mount  
netstat  
nmap  
nslookup  
passwd  
pacman  
ping    -- done
pkill  
ps  
pwd  
readlink  
reboot  
rm  
rpm  
sed  
shutdown  
sort  
ss  
sudo  
tail  
tar  
tee  
time  
top  
traceroute  
tree  
type  
umount  
uniq  
uptime  
usermod  
vmstat  
wc  
wget  
which  
whoami  
xargs  
yes  
zip  

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

***What it does:*** Used to change permissions of a file.

***Real use case:*** Whenever you make a script so you are actually able to run it. 

***Example:*** In the example above, making a file executable, it would like that `chmod -x [file]`

***Tip:*** Learning the numbercodes is extremly helpful. First number for the user, second for the group, and last for others. Each digit represents a combination of read (4), write (2), and execute (1). 

---

#### ls

***What it does:*** Shows the inside of the current directory.

***Tip:*** Best used with a `-al` flag to list all files in long format.

---

#### ping

***What it does:*** Sends an ICMP echo request to a target host. 

***Real use case:*** Perfect to test if there is a connection. Eighter to the target on the way in, or from the mashine on the way out (by pinging something that is alway reachable)

***Example:*** `ping 8.8.8.8` to try to ping the google DNS server, which should always work if you have connection to the internet. 

***Tip:*** Is often used to monitor server uptime from afar, by regularly sending a ping. 
