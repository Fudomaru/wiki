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

### Starting Point  

Hitting the main page first:  

```bash
curl -i -u natas3:3gqisGdR0pjm6tpkDKdIWO2hSvchLeYH http://natas3.natas.labs.overthewire.org/  
```

The HTML looks empty except for a bold little comment:  

No more information leaks!! Not even Google will find it this time...  

That line practically screams **robots.txt**, 
because that’s exactly how you tell Google (and other crawlers) to stay away.  

---

### Checking Robots.txt  

So the next step is to grab that file directly:  

```bash
curl -i -u natas3:3gqisGdR0pjm6tpkDKdIWO2hSvchLeYH http://natas3.natas.labs.overthewire.org/robots.txt  
```

The response says:  

User-agent: *  
Disallow: /s3cr3t/  

Bingo.  

---

### Digging Deeper  

Heading into the disallowed directory:  

```bash
curl -i -u natas3:3gqisGdR0pjm6tpkDKdIWO2hSvchLeYH http://natas3.natas.labs.overthewire.org/s3cr3t/  
```

This reveals an Apache directory listing with a single interesting file: `users.txt`.  

---

### Grabbing the File  

One more curl to fetch that file directly:  

```bash
curl -i -u natas3:3gqisGdR0pjm6tpkDKdIWO2hSvchLeYH http://natas3.natas.labs.overthewire.org/s3cr3t/users.txt  
```

Inside is the credential for the next level.  

---

### Lesson Learned  

This level ties a neat chain together:  

- A comment hints at **Google** → think **robots.txt**.  
- `robots.txt` discloses a **hidden directory**.  
- Directory listing exposes sensitive files.  

Each step shows how small leaks can stack up into full compromises. 
What admins thought was “hidden” was actually trivial to discover with curl.  

<!--
QryZXc2e0zahULdHrtHxzyYkj59kUxLQ
-->


## Natas Level 4

### Overview

This challenge stepped up from static file discovery into manipulating HTTP headers. 
The server blocked me by checking the **Referer header**, 
insisting I could only come from `http://natas5.natas.labs.overthewire.org/`. 
Instead of touching a browser, I kept things clean in curl 
and controlling headers directly is actually quite easy and efficent.  

This is where the exercise really starts to feel like proper web hacking: 
not clicking around, but shaping requests until the server bends.  

---

### First Request: Blocked by Referer

My initial request with just basic authentication got me a rejection. 
The message made the requirement explicit:  

> “Access disallowed. You are visiting from "" 
while authorized users should come only from `http://natas5.natas.labs.overthewire.org/`.”  

That’s the server telling me: “Your header is empty, fill it right.”  

---

### Crafting the Correct Header

Curl lets me set or override headers with `-H`. 
So I added a Referer that matched exactly what the server wanted:  

```bash
curl -u natas5:natas5password -H "http://natas5.natas.labs.overthewire.org/" http://natas4.natas.labs.overthewire.org/
```

---

### Result: Access Granted

With the forged header, the server was satisfied and revealed the next password.  
The simple trick here was learning to lie about **where I came from**, 
something browsers do automatically but curl makes explicit.  

---

### Reflection

This level drilled the importance of headers: 
they’re not magic, they’re just lines in the request. 
Controlling them directly with curl forces me to see 
how fragile these “protections” are. 
If I can fake a Referer in one line, I can fake anything else too.  

---

<!--
0n35PkggAPm2zbEpOU802c0x0Msn1ToK
-->

## Level 5 → Level 6

### Why Cookies Matter

At this point I hit a new wall. 
Basic auth got me through the door, but the page still spat back at me:  
*"Access disallowed. You are not logged in."*  

Turns out, this wasn’t about the username/password combo anymore. 
It was about **cookies**. 
The server decides whether I’m “logged in” 
by checking the value of a cookie named `loggedin`. 
If it’s set to `0`, I’m out. If I can set it to `1`, I’m in.

### Set-Cookie vs. Cookie

Here’s the catch: cookies have a direction.  

- `Set-Cookie:` → This is sent by the **server** to tell the client what cookie to store.  
- `Cookie:` → This is sent by the **client** (browser or curl) back to the server in the next request.  

I made the mistake of trying to inject `Set-Cookie` myself. 
That’s me impersonating the server which is pointless, 
because the real server will just overwrite it. 
What I actually needed was to send a `Cookie` header, 
the way a browser does.

### Forcing the Cookie

So the correct move was:  

```bash
curl -i -u natas5:natas5password -H "Cookie: loggedin=1" http://natas5.natas.labs.overthewire.org/
```

By doing this, I’m explicitly telling the server: 
*“Yes, I’m logged in.”* And it worked.

### General Rule of Thumb

- Use `Cookie:` when you want to **send data** to the server.  
- `Set-Cookie:` is only the server telling you what to store. You almost never send that manually.  


---

<!--
0RoJwHdSKWFTYR5WuiAewauSuNaBXned
-->

## Level 6 → Level 7

### Level Goal

The goal of this level is to retrieve the password for the next level, **natas7**, by interacting with a form on the page and examining the source code.

### Initial Observation

Accessing the level with basic authentication:

Codeblock example here: curl -i -u natas6:0RoJwHdSKWFTYR5WuiAewauSuNaBXned http://natas6.natas.labs.overthewire.org/

Returns a page containing a simple form:

```bash
<form method=post> Input secret: <input name=secret><br> <input type=submit name=submit> </form>
```

Submissions are expected via POST with a field named `secret`.

## Viewing Source Code

The level provides a link to the source code:

```bash
curl -i -u natas6:0RoJwHdSKWFTYR5WuiAewauSuNaBXned http://natas6.natas.labs.overthewire.org/index-source.html
```

Inspecting the source shows:

Codeblock example here: <?php include "includes/secret.inc";
if(array_key_exists("submit", $_POST)) { 
if($secret == $_POST['secret']) { print "Access granted. 
    The password for natas7 is <censored>"; }
else { print "Wrong secret"; } } ?>

### Key Insight

- The secret is stored in a file: `includes/secret.inc`.
- The server includes this file in the code.
- This file is **directly accessible**, 
even though normally PHP includes are not meant to be exposed.

## Retrieving the Secret

Fetching the secret file:

```bash
curl -i -u natas6:natas6password http://natas6.natas.labs.overthewire.org/includes/secret.inc
```

Reveals:

```bash
<? $secret = "FOEIUWGHFEEUHOFUOIU"; ?>
```

## Submitting the Secret via POST

With `curl` we can emulate the form submission:

Codeblock example here: curl -i -u natas6:0RoJwHdSKWFTYR5WuiAewauSuNaBXned -d "secret=FOEIUWGHFEEUHOFUOIU&submit=submit" http://natas6.natas.labs.overthewire.org/


## Summary

1. **Examine the form** to understand required input (`secret` via POST).  
2. **Check the source code** via the provided `index-source.html` link.  
3. **Discover hidden files** (`includes/secret.inc`) containing the secret.  
4. **Submit the secret** with `curl -d` to emulate the form and retrieve the password for **natas7**.  

This level demonstrates the importance of **source code exposure** and how form POST submissions can be automated with `curl`.

<!--
bmg8SvU1LizuWjx3y7xkNERkHxGre0GS
-->
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
