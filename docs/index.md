---
title: Building a Wiki
description: Short tutorial style explaination how I build this page, what problems I had, and what I learned from it.
---

# Building a Wiki

## How I Built My Wiki Using MkDocs

### 1. Installing Python

- First things first: Checking if Python is already installed. For that I just checked for the Version using `py --version` or `python --version`

- Since for me it wasn't installed, I went on installing it. I used `winget install --id Python.Python.3 --source winget` to install it over Powershell, which seamed the most strait forward way to do it. 

- Then I got to my first bump in the road: `py --version` worked, but `python --version` did not. For that I wanted to figure out what the actual difference is


!!! info "Difference py and python command"

	### **`py` is the launcher. `python` is the interpreter.**

	- `py` is a small helper program that comes with the official Python installation on Windows. Its only job is to find and launch the correct version of Python installed on your system.  
   
	- `python` is the actual executable — the real Python interpreter. When you type `python`, you're telling your system, "Run this specific program."

    ### Why does this matter?

	Because `py` will usually work, even if your system PATH isn’t set up right.
	- `python` might be broken or hijacked by the Microsoft Store’s fake shortcut — leading to frustration and confusion.

    **Bottom line:**

	- Use `py` when your system is fresh and you’re still figuring things out.
	- But for full control and compatibility (especially with scripts, tools, and virtual environments), make sure `python` points to your real install — and then use `python` from that point forward.

	**If `py` is the butler, `python` is the king.**  
	Eventually, you don’t want to talk to the butler anymore.

- With that in mind, I figured out that I had to disable the Microsoft Store shortcut, which lets `python` point to the install in the MS Store. I found it under `Settings>Apps>App execution aliases`

### 2. Installed MkDocs
- `pip install mkdocs`
- Ran `mkdocs new .` inside my project folder

### 3. Git & GitHub Setup
- Installed Git with winget
- Set up username + email
- Created GitHub repo and pushed source
- Deployed using `mkdocs gh-deploy`

### 4. Lessons Learned
- Don't trust Windows defaults
- GitHub Pages uses `gh-pages`, not `main`
- Always check your branches and remotes

### 5. What's Next
- Theme upgrade
- First real knowledge sections