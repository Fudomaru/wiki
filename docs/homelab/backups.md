---
title: Backups
description: I will try to lay out what I have already done for backups, why I have done it that way, and what will likely be the next step. 
---

# Backups

### Introduction

This will be my story of building out my personal backup system. 
I will try to explain the reason behind my choices,
how I set it up, 
and especially what I have struggled with the most. 

There are some clear caveats to this. 

First, I am on a budget. 
I do not want to spend a lot of money, and since this is all mostly for training and learning, I will most likely never have a critical need to restore from backup. 
Considering my homelab's lack of redundancy, I think it is okay to not be perfect with my backup setup. 
Secondly, I have a constantly shifting setup: moving things around, creating new services, deleting old ones, breaking things and rebuilding, or trying something completely random just to see if it works. 
That also influences my backup system. 
In my lab, there is nothing that stays the same for very long, and therefore I will most likely have to change the backup system
regularly to have any realistic reason to believe I could ever restore anything. 

I will go over the creation of the storage,
where it lives in my lab right now,
and the two different systems I implemented
to get the data to my storage: BorgBackup and Proxmox Backup Server. 


## Foundation - ZFS Pool Setup

#### What is ZFS?

After a bit of research, I decided to use ZFS.
With ZFS, you don't have as many layers to administer; it treats partitions, volumes, and the filesystem as a single entity. 
ZFS uses copy-on-write, which means new data is written to a different block before the original pointers are updated. 
This atomic operation eliminates many common issues that can occur during data writes and ensures the filesystem is always in a consistent state.
It also has built-in data corruption checks and snapshot capabilities, which I can use to expand on this system later.

#### My Structure 

I decided to use what I have and finally get started. 
This is why I am using a single disk for now. 
I created one ZFS storage pool named `vault` and two datasets within it for the two different backup systems I am going to use.

```bash
# Create the ZFS storage pool on a specific disk
zpool create vault /dev/sdX

# Create a dataset for BorgBackup repositories
zfs create vault/borg

# Create a dataset for the Proxmox Backup Server datastore
zfs create vault/pbs
```

This way, I have both backup methods organized in one ZFS pool, which will make it simpler to back up the entire pool to an external drive in the future.


## Borg Backup for Proxmox Hosts

#### Borg LXC Setup

I wanted a central point of control for my backups, so I created a Debian Bookworm LXC container to act as my backup repository server.
I created it manually with 1 core and 512MB RAM, since it won't need a lot of power. 
It gets a static IP and a mount point that passes the ZFS pool from the Proxmox host into the container.

```ini
# /etc/pve/lxc/100.conf
arch: amd64
cores: 1
features: nesting=1
hostname: borg
memory: 512
# This maps the host's ZFS dataset into the container's filesystem
mp0: /vault/borg,mp=/mnt/borg
net0: name=eth0,bridge=vmbr0,firewall=1,ip=10.0.0.10/24,ip6=dhcp,type=veth
ostype: debian
rootfs: local-lvm:vm-100-disk-0,size=8G
swap: 512
unprivileged: 1
```

#### Borg Installation and User Setup

First, as always, it's important to update the system inside the LXC.
Then, I installed BorgBackup and created a dedicated `borg` user to manage the repository. This avoids running anything as root.
I also set up passwordless SSH access to this user from the Proxmox hosts that will be backed up.

```bash
# Update the system
apt update && apt upgrade -y

# Installation of BorgBackup
apt install borgbackup

# Add a dedicated service account
useradd borg

# ... (Then, set up authorized_keys for the borg user) ...
```

#### Borg Repo Initialization

To use Borg, you first have to initialize a repository. 
This is the location where Borg saves the backup data. 
Since I have two Proxmox hosts to back up, I initialized two separate repositories inside the LXC container. I am running this command *inside the LXC container*.

```bash
# Remember, these paths are inside the LXC, from the mount point we set up
borg init --encryption=repokey-blake2 /mnt/borg/proxmox01
borg init --encryption=repokey-blake2 /mnt/borg/proxmox02
```

#### Backup Script for Proxmox Hosts

Now for the client-side setup. I needed to install Borg on the Proxmox hosts themselves so they could send backups *to* the Borg LXC container.
This clarifies the client-server relationship: the LXC container acts as a central repository, and the hosts are clients that connect to it.

After installing Borg on the hosts and creating a user to run the backups, I worked on automation. The first step is a reliable script that can run without user input. The BorgBackup documentation provides an excellent example script to start with.

A critical part of an automated script is handling the repository passphrase securely. Storing it in plain text is a risk. A much safer method is to store the passphrase in a root-owned file with strict permissions and tell Borg to read it from there using the `BORG_PASSCOMMAND` variable.

```bash
# On the Proxmox host, create a file to hold the passphrase
vim /root/.borg_pass

# Set permissions so only root can read it
chmod 400 /root/.borg_pass
```

Here is the script, which I saved as `/usr/local/bin/borg_backup.sh` on each Proxmox host.

```bash
#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline.
# The repository is located on our Borg LXC server.
export BORG_REPO='ssh://borg@10.0.0.10:22/mnt/borg/proxmox01'

# Setting the command to securely get the passphrase from a protected file.
# This file should be owned by root with 400 permissions.
export BORG_PASSCOMMAND='cat /root/.borg_pass'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:
borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --exclude 'home/*/.cache/*'     \
    --exclude 'var/tmp/*'           \
                                    \
    ::'{hostname}-{now}'            \
    /etc                            \

backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-*' matching is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:
borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6

prune_exit=$?

# actually free repo disk space by compacting segments
info "Compacting repository"
borg compact
compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
```

I adapted the script from the Borg documentation. The key changes I made were:
1.  Set the `BORG_REPO` variable to point to the correct repository on my Borg LXC server.
2.  Used `BORG_PASSCOMMAND` to securely read the passphrase from the file at `/root/.borg_pass` instead of exposing it in the script.
3.  Adjusted the backed-up paths and exclusions to fit the needs of a Proxmox host.


#### Systemd Automation

This was my first time automating a task with systemd timers, but it wasn't too complicated.
I created two files in `/etc/systemd/system/`: a `.service` file to define the backup job and a `.timer` file to schedule it.

The service file is a simple `oneshot` service, which means it runs a command once and then stops. Note that the `User` is `root`, as the script needs to execute the `BORG_PASSCOMMAND` to read the secret file in `/root/`.

```ini
# /etc/systemd/system/borg-backup.service
[Unit]
Description=Borg Backup Service

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/bin/borg_backup.sh
```

The timer file schedules the service to run daily and ensures reactivation after a reboot (`Persistent=true`).

```ini
# /etc/systemd/system/borg-backup.timer
[Unit]
Description=Run borg-backup.service daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

After creating these two files, I reloaded the systemd daemon and enabled the timer to start the schedule.

```bash
# Reload systemd to recognize the new files
systemctl daemon-reload

# Enable and start the timer
systemctl enable --now borg-backup.timer
```


## Proxmox Backup Server

#### PBS LXC Container Setup

Here I used the Proxmox VE Helper Script for easy installation. 
I build a 2 core, 2GB RAM lxc Container to have pbs running. 
All of that worked really great, and afterwards I only had to mount the 
second zfs dataset to make it complete. 


#### PBS Installation

If you have never tested the [Helperscripts]("https://community-scripts.github.io/ProxmoxVE/") then you should take a longer look at it. 
They are really helpful if you are ever planing to run proxmox 
in a homelab setting. 
I still often try to refuse myself this option, 
because i think you learn a lot more by doing it from scatch, 
but here I decided to go with it. 


#### PBS Datastore Configuration

Afterward it was as simple as browsing to the IP 
I set up and logging into the WebUI. 
Going through that I setup the datastore,
using the mountpoint to my zfs dataset i created previously. 


#### Configure Proxmox Hosts to use PBS

Now the last thing was to implement it into my setup. 
Here I again decided to use the webUi, this time the one from Proxmox.
Under the Datacenter you can add Storage options, 
and here is where you can choose PBS, click yourself though the settings, 
and there you are. 
Same with the actual backups. 
For that you stay in the datacenter settings 
to choose the backup for all or some containers or VMs, 
or you can go to the VM or container directly. 
You now only have to choose the PBS as the storage location,
and everything else is handled for you. 


#### Testing Restores 

This is really important. 
Your best backup is no help at all
if you cant restore from it. 
Therefor I tested a few things at once. 
First I set everything up, and then waited for a few days. 
I also wanted to make sure the backups where running as they should. 
Then I shut down one of my two proxmox nodes, 
and tried to restore the containers 
of the now "not working" node to the one still online. 




## Future Plans - Offsite Backup Strategy

My current setup protects against hardware failure within the lab, 
but it has a single, critical point of failure: 
the lab itself. 
A fire, theft, or catastrophic power event 
would take out both the live data and the local backups. 
This is where the final piece of the classic **3-2-1 backup rule** comes into play.

-   **3 Copies:** My live data, the local backup, and an *offsite* backup.
-   **2 Media:** The disks running the services, and the ZFS pool holding the backups.
-   **1 Offsite Location:** A physically separate location to ensure true disaster recovery.

#### Choosing a Sanctuary for Data

The goal was to find a provider that met a few strict requirements:
1.  **Data Sovereignty:** Must be based in Germany to align with GDPR and my preference for local data privacy.
2.  **Compatibility:** Must work seamlessly with Borg, ideally with native support over SSH.
3.  **Affordability:** The cost had to be reasonable for a homelab budget, without complex pricing or surprise retrieval fees.

After some research, I settled on a Hetzner Storage Box. 
It's a simple, affordable block of storage accessible via SSH, 
offered by a German company. 
This avoids the complexity 
and egress costs of larger cloud providers 
and feels perfectly suited for this project's scale.

#### The Offsite Implementation

The plan is to create a new, encrypted Borg repository on the Hetzner storage. 
The process is nearly identical to the local setup, 
reinforcing the simplicity of the tool.

A script, scheduled with a new systemd timer, will handle the synchronization. 
To start, this script will run weekly or monthly, 
focusing only on syncing the backup data: the local zfs pool as a whole. 

## Lessons Learned & Future Questions

This project was never just about building a backup system; 
it was about understanding the friction points in a real-world deployment.

#### Key Insights

*   **Systemd is Superior to Cron:** 
For services, the declarative nature, dependency management, 
and superior logging (`journalctl`) make systemd timers 
a more robust choice for automation. 
The `Persistent=true` setting alone is a significant improvement, 
ensuring a timer runs if the system was down during its scheduled time.
*   **Test Restores Are Not Optional:** 
A backup is just a theory until a restore has been successfully tested. 
My first attempts immediately revealed gaps in my process, 
reinforcing that this is the most critical step.
*   **Simplicity is a Feature:** 
The combination of ZFS, Borg, and PBS provides immense power, 
but each adds a layer of complexity. 
The initial setup was a reminder 
that the simplest path to a working solution 
is often the best one to start with.
*   **Offsite Backups Don't Have to Be Expensive:** 
For just a few euros a month, 
I can achieve a resilient disaster recovery plan. 
The peace of mind is worth far more than the cost.

#### What This Setup Achieves

*   **3-2-1 Rule:** 
Fulfilled with live data, local ZFS backups, and encrypted offsite copies.
*   **Rapid Local Recovery:** 
PBS allows for the quick restoration of entire VMs and containers.
*   **Host Configuration Safety:** 
Borg protects the essential `/etc` configurations of the Proxmox hosts.
*   **Disaster Recovery:** 
The offsite repository provides a last line of defense against total site failure.

---

### Questions

As the overview page states, this lab is a diary of questions. 
This backup project has raised several new ones that will shape its future:

*   At what point does the cost of storing large PBS snapshots offsite justify the expense? 
Is there a more selective way to back up VM data for disaster recovery?
*   Is a weekly or monthly offsite sync frequent enough? 
How do I define "critical data" 
and what is my true recovery point objective?
*   How can I automate the *testing* of my restores, 
so that I have continuous, provable confidence in my backups?
*   What is the blind spot of this system? 
If the NAS host failed completely, 
what is the exact, step-by-step process to rebuild the backup system itself 
from the offsite repository?

