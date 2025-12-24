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


## Borg Backup for Proxmox Hosts

#### Borg LXC Setup



#### Borg Installation and User Setup



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

