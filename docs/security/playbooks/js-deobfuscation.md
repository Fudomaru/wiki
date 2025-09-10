---
title: JavaScript Deobfuscation
description: My method for analyzing and reversing obfuscated JavaScript — from locating code to decoding payloads.
---

# JavaScript Deobfuscation

This page is part of my playbook.  
It’s where I document how I approach obfuscated JavaScript. 
Whether it’s hiding logic, encoding payloads, 
or trying to confuse me during a challenge.

## Why This Matters

Obfuscated JavaScript shows up in phishing kits, 
shady login pages, payload droppers, and even legitimate apps.  
If I can’t read the code, I can’t understand what it’s doing, 
and that means I can’t exploit it, defend against it, or learn from it.

This technique helps me:

- Reveal hidden functionality  
- Extract encoded payloads  
- Understand client-side logic  
- Spot malicious behavior  

## My Workflow

1. Locate the JavaScript  
   I inspect the page source or use browser tools to find embedded or linked scripts.

2. Identify Obfuscation  
   I look for signs like long single-line code, packed functions, strange variable names, or encoded strings.

3. Beautify the Code  
   I reformat the code to make it readable — usually the first step before deeper analysis.

4. Deobfuscate  
   I use tools or manual tracing to unpack the logic and reveal what the code is actually doing.

5. Analyze the Functionality  
   I walk through the code line by line to understand its behavior and purpose.

6. Replicate the Behavior  
   I use tools to mimic what the script is doing and test server-side responses.

7. Decode the Output  
   I identify and decode any encoded strings — base64, hex, rot13, or custom formats.

8. Reverse Engineer if Needed  
   If the code is custom-obfuscated or encrypted, I manually trace execution flow and rebuild the logic.

## Encoding Techniques I Watch For

- Base64  
  Often padded with equal signs and uses only alphanumeric characters plus a few symbols.

- Hex  
  Uses only digits and lowercase letters a to f, often easy to spot in encoded strings.

- Rot13  
  A simple Caesar cipher that shifts letters by 13 positions, recognizable by patterns.

- Other  
  Custom encodings or encryption may require manual analysis or external tools to identify.

## Tools I Use

This list will evolve as I refine my workflow:

- Browser DevTools  
- JSBeautifier or js-beautify  
- UnPacker  
- CyberChef  
- Node.js  
- curl  
- Cipher Identifier  
- rot13 online tools  
- JStillery (experimental)

## What’s Next

This page will grow with:

- Annotated examples from challenges  
- Custom obfuscation patterns I’ve seen  
- Scripts and snippets I use to automate parts of the workflow

Deobfuscation is not just fun. 
It is important. 
It’s where I sharpen my ability to read what others try to hide Turning confusion into clarity.


