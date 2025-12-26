---
title: Cybersec Fundamentals
description: Explaining the fundamentals of Cybersecurity, how to use them, abuse and defend against them.
---

## What is this Page

This is my personal crash course into cybersecurity.  
I use it to track concepts, tools and tactics I pick up and get to use efficiently in CTFs and during my learning.  

!!! info ""
    It evolves as I learn!


## The Mindset of a Hacker

- Thinking outside the box: Try to find as many ways to use tools and systems as you can. There is never the right way, there are only endless possibilities.  

- The Why is more important then the How: Understanding why something is done, the motivation and psychology behind it, you find the weak points.  

- No is not an option: You often get the best results, after nothing works and you have to get creative.  

- See the System: To figure something out, and really understand it, it is often recommended to take a step back.   

- Attention to Detail: Pay close attention to every detail and be persistent in figuring out the why.   

- "Man lernt nie aus": This is not just a phrase, it is a philosophy  

##  Core Concepts to Understand

- CIA Triade: The three core parts to make things secure. Look at this on every level, from singel packages to complete infrastructures. If any is missing, that is where things go wrong.  

- OWASP Top 10: The most common vulnerabilities found in the wild. Learn them, know them, and look for them everywhere.  

- Defense in depth: Layering security strategies, always know that every layer will be breached. So configure every layer like it is the first and last defence.  

- Privilege escalation: Type of attack where a unauthorized user gains access to more then they should. There are two ways for that, vertical and horizontal. Vertical movement is going up the food ladder, to management and admin. Horizontal means staying on your permission level, but accessing a different user, gaining confidentail data.  

- Post Exploitation: Don't forget that most seriouse attackers are not done after they get access. They will try to get persistence, escalate privileges, and gather information.  

## Tools I use

- [nmap](toolbelt/nmap.md): Networkscanner of choice. 

- Burp Suite: Package interception, changing and exploring of WebApps on a new level.  

- John the Ripper: Because weak passwords are still more common then you think.  

- ffuf: Because Enumerating is at least half of the game.  

- netcat: The Swiss army knife of raw Networking Connections.  

## My Learning Plan

Phase 1: Basics - get as much Hands on as you can.  
Phase 2: Enumeration - try to learn to understand systems quickly.  
Phase 3: Exploration - warming up with all the common bugs.  
Phase 4: Real World - getting my Hands dirty in Bug Bounty

