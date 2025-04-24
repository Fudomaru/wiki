---
title: bandit
description: Aimed at Beginners. Teaching the basics of linux commands and system structur. 
---


## Level 0

So first of all: The setup:  
OvertheWire is something I found as a good way to get started with CTFs. 
Bandit is a simple Linux mashine, setup in a way, where each "flag" you find is the password for the next level.
With this password you can access the mashine over SSH, using the level as a username.  
It is aimed at absolute beginners, teaching the basics of linux and playing CTFs. 
For each level you get a list with new introduced commands, which can help you with figuring out what to do. 

## Level 0 → Level 1

The first level is mainly the get the setup right.  
It explaines that you connect over SSH over port 2220 to bandit.labs.overthewire.org.  
The username is bandit0 and the password for the first level is given -> also bandit0.  

#### My Setup:  
I don´t really want to miss out with the linux expiriance, so I use WSL2 on my Windows mashine.  
It worked like a charme. 

#### New Commands

For this there was only one command given: **SSH**  
This is used to get a secure remote access to another mashine. You use this general format:  
`ssh username@connection.adress`
In this case that would look like this:  
`ssh bandit0@bandit.labs.overthewire.org`

#### My Solutions

I think for this the most imporant step is to not forget about the port.  
At first I wanted to just skip reading and try things out, thinking of the way a port is put in an URL. My first try was this:  
`ssh bandit0@bandit.labs.overthewire.org:2220`
That was obiously wrong.  
So I did have do figure out what the right way was.  
I wanted to improve in figuring out this the right way, so instead of looking it up online, I opened the man pages.  
And shortly after that I found it.  
I had to use a -p flag to give it the port to use. So I got connected with:  
`ssh -p bandit0@bandit.labs.overthewire.org:2220`  

So I was connected.  
It was a nice greeting in consol, giving a bit more information on the game.  

But I wasn't done.  

There was still something missing.  
The flag, or to be correct: The password for the next level.  
I started just just looking around. With `ls` I found the conveniently placed readme file.  
I looked at it with `cat readme` and there it was: the **FLAG**!

<!-- 
ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If
-->

## Level 1 → Level 2



## Level 2 → Level 3



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