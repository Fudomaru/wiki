---
title: Building a Wiki
description: Short tutorial style explaination how I build this page, what problems I had, and what I learned from it.
---

# Building a Wiki

## How I Built My Wiki Using MkDocs

### 1. Installing Python

- First things first: checking if Python was already installed. I tested that by running `py --version` or `python --version`

- Since it wasn't installed on my machine, I installed it using:
```
winget install --id Python.Python.3 --source winget
```
This was the cleanest, most straightforward way to do it via PowerShell.

- Then I hit my first bump in the road: `py --version` worked, but `python --version` didn’t. So I had to figure out the difference.


??? info "Difference between `py` and `python` commands"

	### **`py` is the launcher. `python` is the interpreter.**

	- `py` is a small helper that comes with the official Python install on Windows. Its job is to find and launch the right Python version. 
   
	- `python` is the actual interpreter — the program that runs your code.

    ### Why does this matter?

	Because `py` usually works even if your PATH isn't set up right.
	But `python` might be broken, hijacked, or just point to the wrong thing (like the Microsoft Store version).

    **Bottom line:**

	- Use `py` when your system is fresh and you’re still figuring things out.
	- But for full control and compatibility (especially with scripts, tools, and virtual environments), make sure `python` points to your real install — and then use `python` from that point forward.

	**If `py` is the butler, `python` is the king.**  
	Eventually, you don’t want to talk to the butler anymore.

- To fix this, I disabled the Microsoft Store’s shortcut under:
```
Settings > Apps > App execution aliases
```
That forced `python` to point to the real install.

### 2. Installed MkDocs

- This was straightforward. I installed MkDocs using pip: 
```
pip install mkdocs
```

- I picked a good spot for my project folder, navigated into it, and ran: 
```
mkdocs new .
``` 
This initialized a fresh MkDocs site in the current directory. 

### 3. Git & GitHub Setup

- I checked if Git was installed 
```
git --version
```
It wasn’t, so I installed it using: 
```
winget install --id git.git -e
```

- Then I configured Git with: 
```
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```
- I initialized my repo and set up the remote:
```
git init
git remote add origin https://github.com/YOUR_USERNAME/my-wiki.git
git add .
git commit -m "Initial commit"
git push -u origin main
```
- That’s where I hit the next wall: the push failed. Why? Because I hadn’t set up GitHub authentication on this machine. 

??? info "GitHub setup"

	Since this was a fresh install, I needed to authenticate with GitHub using SSH:

	- Generated an SSH key (`ssh-keygen`) and copied the public key.
	- Added the key to GitHub under *Settings > SSH and GPG keys*.
	- Switched the Git remote to use SSH:

	```
	git remote set-url origin git@github.com:username/repo.git
	```

- With that out of the way, I built and deployed the site:
```
mkdocs build
mkdocs gh-deploy
```
MkDocs created a gh-pages branch with only the built site and pushed it to GitHub  
— ready to be served.

### 4. What's Next

- Writing actual content: The infrastructure’s ready. Now comes the real work: documenting ideas, tools, commands, thoughts.
- Structuring the knowledge: Tags, categories, maybe a TOC plugin. I want a digital brain that grows with me.
- Styling the site: Playing with themes (starting with Material for MkDocs) and customizing fonts, colors, and layout.