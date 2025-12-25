---
title: Backups
description: I will try to lay out what I have already done for backups, why I have done it that way, and what will likly be the next step. 
---

# Backups

### Introduction

This will be my story of building out my personal backup system. 
I will try to explain the reason behind my choices,
how I set it up, 
and especially what I have struggled with the most. 

There are some clear caveats to this. 

First I am on a budget. 
I do not want to spend a lot of money, 
and since all of that is mostly for training and learning, 
and I will most likely never actually have to restore from backup, 
and considering my homelab's lack of redundancy,
I think it is okay to not be perfect with my backup setup. 
Secondly I have a constantly shifting setup, moving things around, 
creating new and/or deleting old, breaking things and rebuilding, 
or trying something completely random just to see if it works. 
That also influences my backup system. 
In my lab there is nothing staying the same for very long, 
and therefor I will most like have to change the backup system
regularly to actually have any realist reason to believe
I could ever restore anything. 

I will go over the creating of the storage,
where it lives in my lab right now,
and the to different systems I implemented
to get the data to my storage: Borgbackup and Proxmox Backup Server. 


## Foundation - ZFS Pool setup

#### What is ZFS: 

After a bit of research I decided to use ZFS.
With ZFS you have don't have as many layers to administrate. 
It treats the partitions, the volumes and the filesystem as one thing. 
ZFS uses copy-on-write when data is written to the disk. 
That means it is always saved somewhere else, and later only points to the new files. 
Doing it that way eliminates a lot of things that can go wrong when writing data to the disk. 
There is also data corruption checks build into it. 
It has also snapshot capabilities, which I can later use to expand on what I am doing. 

#### My Structure 

I decided to use what I have, and finally get startet. 
This is why I am using one disk for now. 
I created one zfs storage pool, 
and two datasets for the two different backups I am going to use. 

'''bash
zpool create vault /dev/sdX #creating the zfs storage pool
zfs create vault/borg       #creating a dataset for borg repo
zfs create vault/pbs        #creating a dataset for pbs datastore
'''

This way I have both ways to backup on in one zfs pool
and will be able to backup all of it to an external storage. 


## Borg Backup for Proxmox Hosts

#### Borg LXC Setup

I want to use one central point of control for my backups. 
For that I using a Debian Bookworm LXC. 
I created it manually with 1 core, 512mb RAM, since it wont need a lot of power. 
It gets a static IP, and a mount point with the zfs Pool. 

'''bash
arch: amd64
cores: 1
features: nesting=1
hostname: borg
memory: 512
mp1: /path/to/zfs/pool/,mp=/path/to/mountpoint
net0: name=eth0,bridge=vmbr0,firewall=1,ip=10.0.0.10/24,ip6=dhcp,type=veth
ostype: debian
rootfs: local-lvm:vm-100-disk-0,size=8G
swap: 512
unprivileged: 1
'''

#### Borg Installation and User Setup

First of all, like always, it is important to 
run all of the updates.
Then I also installed borgbackup, since that is what I am using. 
I also created a user that I can use to run it,
to make sure I dont have anything to run as root. 
I also set up passwordless access over ssh to the borg user. 

'''bash
apt update && apt upgrade -y  #Update the system
apt install borgupdate        #Installation of borgupdate
useradd borg                  #Adding service account
'''



#### Backup Script for Main Proxmox Host



#### Systemd Automation


#### What gets backed up?



## Proxmox Backup Server

#### PBS LXC Container Setup



#### PBS Installation



#### PBS Datastore Configuration



#### Configure Proxmox Hosts to use PBS



#### Backup Jobs



#### Testing Restores 



## Future Plans - Offsite Backup Strategy 

