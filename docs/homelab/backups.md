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


