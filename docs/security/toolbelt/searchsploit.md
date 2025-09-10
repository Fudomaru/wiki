---
title: SearchSploit
description: Deep dive into SearchSploit — how it works, what it searches, and how I use it to find public exploits.
---

# SearchSploit

SearchSploit is my go-to tool for quickly finding public exploits and shellcodes.  
It’s fast, offline, and built for terminal use, 
so it is perfect for air-gapped environments or fast triage during recon.

## What It Does

SearchSploit lets me search the Exploit Database (Exploit-DB) from the command line.  
It matches software names, versions, and CVE identifiers to known exploits and shellcodes.

It’s part of the `exploitdb` package maintained by Offensive Security, 
and it mirrors the content of [Exploit-DB](https://www.exploit-db.com) locally.

## How It Works

SearchSploit uses a local copy of the Exploit-DB repository.  
This includes:

- Exploit scripts and shellcode samples  
- Metadata for each entry (title, platform, type, path)  
- Optional papers if configured

The tool parses a CSV index file (`files.csv`) that maps each exploit to its metadata.  
When I run a search, it filters this index using grep-like logic and returns matching entries.

## What It Searches

- Software names and versions  
- CVE identifiers  
- Exploit titles and descriptions  
- File paths and categories

It does **not** search the Google Hacking Database (GHDB), 
but it can include security papers if I install the `exploitdb-papers` package.

## Key Features

- Offline search so no internet needed once the DB is cloned  
- Fast filtering with grep-style syntax  
- CVE-based lookup  
- Ability to mirror or open exploit files  
- JSON output for scripting and automation

## Common Commands

- `searchsploit <term>`  
  Basic search by keyword

- `searchsploit --cve <CVE-ID>`  
  Search by CVE identifier

- `searchsploit -x <path>`  
  View the exploit code directly

- `searchsploit -m <path>`  
  Mirror the exploit to my working directory

- `searchsploit -u`  
  Update the local database

## Installation

On Kali Linux, it’s pre-installed with the `exploitdb` package.  
On other systems, I clone the Git repository:

- Exploit scripts: `https://gitlab.com/exploit-database/exploitdb.git`  
- Binary exploits: `https://gitlab.com/exploit-database/exploitdb-bin-sploits.git`  
- Optional papers: `https://gitlab.com/exploit-database/exploitdb-papers.git`

I make sure the `searchsploit` script is in my `$PATH`, and I run `searchsploit -u` to keep the index fresh.

## How I Use It

SearchSploit is part of my recon and triage workflow.  
When I identify a service or software version, I run a quick search to see if there’s a known exploit.  
If I find something promising, I mirror the exploit and review the code manually.

It’s also useful for building awareness — seeing what kinds of vulnerabilities exist for common platforms.

## Limitations

- It doesn’t verify exploit reliability — I have to test manually  
- Some entries link to external binaries not included by default  
- It’s only as current as my last update — I run `searchsploit -u` regularly

## What’s Next

This page will grow with:

- Notes on exploit categories and naming conventions  
- Examples of how I use SearchSploit in real challenges  
- Scripts to automate CVE lookups and exploit mirroring

This is one of the tools in my belt — fast, focused, and always ready to help me find the cracks.
