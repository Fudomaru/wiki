---
title: Natas
description: Aimed at Beginners. Basic WebApp with a white box approch, showing of the most common bugs and how to abuse them.
---


## Level 0

Natas is not Bandit. There’s no SSH here, no Linux shell waiting. 
This one is entirely web-based, built to teach the fundamentals of web security.  
The structure is simple: 
every level lives on its own webpage, 
protected with **HTTP Basic Authentication**. 
The username and password are provided for the first level, 
and each flag you discover is the password for the next one.  

Instead of poking around a remote filesystem, 
you’ll be crawling through 
**HTML source, HTTP headers, hidden files, cookies, and web logic**. 

I’ll be doing all the web traffic work with **Caido** (an alternative to Burp Suite). 
It gives me clean intercepts, easy header manipulation, and request replay. 


## Level 0 → Level 1

### Why Curl?  

I could just open the site in a browser, punch in the credentials, and be done.  
But that would mean skipping the part where the real learning happens.  

Curl forces me to see the web for what it actually is:  
**raw requests, raw responses, headers, and status codes**.  
No hidden browser magic. No auto-redirects or silent retries.  
Just me, the server, and the HTTP spec.  

Getting comfortable with curl means:  
- I can **reproduce any request** exactly as I want it.  
- I can **see and control every header** going over the wire.  
- I get a deeper feel for how web apps actually behave under the hood.  
- I’m building skills that translate directly into 
  pentesting tools like Caido or Burp, 
  because they’re just fancy wrappers around the same HTTP traffic.  

So yeah, it’s slower than just clicking around.  
But the payoff is a sharper eye and a toolkit that doesn’t depend on a GUI.  

### First Contact – 401 Unauthorized  

Hitting the site with a plain request:  

``` bash
curl -i http://natas0.nats.labs.overthewire.org/
```

This comes back with a **401 Unauthorized**. 
That’s the server rejecting me outright. 
The interesting part isn’t the HTML error page, it’s the header:  
`WWW-Authenticate: Basic realm="Authentication required"`
That single line is the server spelling out the rules of the game:  
*"If you want access, bring me a Basic Auth header."*  

---

### Basic Auth in Plain Words  

Basic Auth is just **username:password**, shoved through Base64, and sent in the `Authorization` header. Nothing fancy, nothing safe, but enough to gate a simple challenge.  

So if my creds are `natas0:natas0`, the header looks like this:  

```bash
Authorization: Basic bmF0YXMwOm5hdGFzMA==
```

So to use it you can use the -H flag to give the header with your request:

```bash
curl -i -H "Authorization: Basic bmF0YXMwOm5hdGFzMA==" http://natas0.natas.labs.overthewire.org/
```

---

### Getting the flag

For all that work, and understanding that happened in these steps, 
there is thing that makes it a clear win: 
If you get this request and authorization to work in curl, 
you get the flag right in front of you,
since it is in the html file, as a comment. 

---

<!--
0nzCigAq7t2iALyvU9xcHlYN4MlkIwlq
-->

## Level 1 → Level 2

For all of that work for the curl request of level one, 
there was an extra reward waiting for me on the second level. 
The second flag sits at the exactly the same spot as the first. 
The main difference is, that the option to view the source code in the brower is disabled. 
Since I are yet to use a browser, that really doesn't matter for me. 

---

<!--
TguMNxKo1DSa1tujBLuZJnDUlCcUAPlI
-->

## Level 2 → Level 3


### Reading Between the Lines  
At first glance, the page just says:  
*“There is nothing on this page.”*  
But there’s one clue — an `<img>` tag pointing to `files/pixel.png`.  

A picture like that doesn’t belong in a challenge unless it’s trying to point me somewhere.  

---

### Following the Trail  
Instead of looking at the picture itself, I cut it off at the directory and tried to see if `/files/` was open:  

Codeblock with example here: curl -i -u natas2:TguMNxKo1DSa1tujBLuZJnDUlCcUAPlI http://natas2.natas.labs.overthewire.org/files/

And yes — Apache is happily showing me a directory listing.  
Inside are two files:  
- `pixel.png` (the image from the page)  
- `users.txt` (way more interesting)  

---

### The Jackpot – users.txt  
Pulling `users.txt` gave me a list of dummy users, with one real gem tucked inside:  

Codeblock with example here: curl -i -u natas2:TguMNxKo1DSa1tujBLuZJnDUlCcUAPlI http://natas2.natas.labs.overthewire.org/files/users.txt  

In between fake creds like `alice` and `bob`, the entry for `natas3` stood out with the real password:  

---

### Lesson Learned  
This level is about **directory indexing**.  
If the web server is misconfigured to show its folders, attackers can just walk through and scoop up whatever files are lying around.  
It’s a rookie mistake, but one that still happens in real systems. 


---

<!--
3gqisGdR0pjm6tpkDKdIWO2hSvchLeYH
-->

## Level 3 → Level 4
## Level 4 → Level 5
## Level 5 → Level 6
## Level 6 → Level 7
## Level 7 → Level 8
## Level 8 → Level 9
## Level 9 → Level 10
## Level 10 → Level 11
## Level 11 → Level 12
## Level 12 → Level 13
## Level 13 → Level 14
## Level 14 → Level 15
## Level 15 → Level 16
## Level 16 → Level 17
## Level 17 → Level 18
## Level 18 → Level 19
## Level 19 → Level 20
## Level 20 → Level 21
## Level 21 → Level 22
## Level 22 → Level 23
## Level 23 → Level 24
## Level 24 → Level 25
## Level 25 → Level 26
## Level 26 → Level 27
## Level 27 → Level 28
## Level 28 → Level 29
## Level 29 → Level 30
## Level 30 → Level 31
## Level 31 → Level 32
## Level 32 → Level 33
## Level 33 → Level 34
