---
title: bandit
description: Aimed at Beginners. Teaching the basics of linux commands and system structur. 
---


## Level 0

So first of all: The setup:  
OvertheWire is something I found as a good way to get started with CTFs. 
Bandit is a simple Linux machine, setup in a way, where each "flag" you find is the password for the next level.
With this password you can access the machine over SSH, using the level as a username.  
It is aimed at absolute beginners, teaching the basics of linux and playing CTFs. 
For each level you get a list with new introduced commands, which can help you with figuring out what to do. 

## Level 0 → Level 1

The first level is mainly the get the setup right.  
It explaines that you connect over SSH over port 2220 to bandit.labs.overthewire.org.  
The username is bandit0 and the password for the first level is given -> also bandit0.  

#### My Setup:  
I don´t really want to miss out with the linux expiriance, so I use WSL2 on my Windows machine.  
It worked like a charme. 

#### New Commands  
For this there was only one command given: [**SSH**](/linux/cli-magic/#ssh)  
This is used to get a secure remote access to another machine. You use this general format:  
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

#### New Commands
[ls](/linux/cli-magic/#ls) , [cd](/linux/cli-magic/#cd) , [cat](/linux/cli-magic/#cat)  


#### My Solutions
I am always suprised on how easy it is to make regular things seam special.  
It was practically the same thing then the level before.  
This time the file just wasn't called "readme", but "-".  
So just tiping in the normal command wouldn't work.  
But this time I actually had the problem before. So I did the following:  
`cat ./-`

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 2 → Level 3

#### My Solutions
Since there where no new commands, and in the level description it told me the file name with the flag, I just went on trying `cat` again.  
This time went pretty easy for me, since I accidently found the right answer.  
Sometimes I am pretty lazy, so I use tab to autocomplete a lot.  
And here it saved me from figuring out on my own how to deal with spaces in filenames.  
`cat spaces\ in\ this\ filename`

<!--
MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx
-->

## Level 3 → Level 4

#### My Solutions  
No new commands. From the description it was about finding a "hidden" file.  
For this I used `cd` to get to the folder, and then used the following to show the hidden file:  
`ls -al`  
I know technically I only need the -a to see all, but I do like the look of -l, and it is a lot better for me to just remember -al like I want to see al(l).  
Then it was just the now typical `cat` to get to the flag. 

<!--
2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ
-->

!!! info ""
    For most Terminals you can right click somewhere in the Terminal to eighter Copy or Past.  
    Helped me a lot for all these flags.

## Level 4 → Level 5

#### New Commands  
[file]()

#### My Solutions
So again: No new commands, so I guess I can just `cat` all the files in there.  
Or so I tought.  
I was really supprised to find output infront of my bash setup. It wasn't too bad, and just brute forcing my way though all 10 files, it was easy to find the human readable file and the flag.  

#### but
I couldn't let it be. So I started searching for to figure out if a file is human readable first.  
It felt like that would be the **right** solution.  
So after thinking about it, and trying to find a clear path to "human readable" in the help of different commands, I setteled on the file command.  
It tells me what something is, and maybe I can tell from the type which is the right one.  
This is what I ended up using, and it only put one file as ASCII instead of data or a PGP Secret Sub-Key. 
`file ./*`

<!--
4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw
-->

## Level 5 → Level 6

#### New Commands  
[find]()

#### My Solutions  
So for this I had to do a bit more reading.  
I kinda looked into the `find` command for the last level, but since `file` seamed to work so good I stopped at that.  
So in the Level description I got following clue:  
- human-readable  
- 1033 bytes in size  
- not executable  
Taking my time, going though the man page of find, the first thing useable I got was `-size`.  
With this you can search for files with a specific size.  
For me that meant trying it out and seeing how much I got back, just filtering with the size.  
I run:
`find . -size 1033c`  

<!--
HWasnPhtq9AVKe0dmk45nxy20cvUa6EG
-->

## Level 6 → Level 7

#### My Solutions  
For this I was greeted with a new search.  
But this time in a bigger haystack. The whole server.  
The clues this time:  
- owned by user bandit7  
- owned by group bandit6  
- 33 bytes in size

---

So first I had to try the same thing I did Level 5:  
`find / -size 33c`  
This found me a whole lot of different stuff.  
So I had to go to the next step and figure out how to search for ownership.  
Back to the `man` page for me. But I didn't wanted to try to read though everything again.  
So I thought to be really clever figured out how to search on the `man` pages.  
This is done with `/ WhatYouWantToSearch`.  
With this it was a lot easier to find out the right command to find the user and group.  
`find / -user bandit7 -group bandit6 -size 33c`  
But still there where way to many files, most of which the permission was denied to me anyway. 


<!--
morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj
-->

## Level 7 → Level 8

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 8 → Level 9

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 9 → Level 10

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 10 → Level 11

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 11 → Level 12

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 12 → Level 13

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 13 → Level 14

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 14 → Level 15

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 15 → Level 16

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 16 → Level 17

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 17 → Level 18

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 18 → Level 19

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 19 → Level 20

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 20 → Level 21

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 21 → Level 22

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 22 → Level 23

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 23 → Level 24

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 24 → Level 25

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 25 → Level 26

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 26 → Level 27

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 27 → Level 28

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 28 → Level 29

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 29 → Level 30

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 30 → Level 31

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 31 → Level 32

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 32 → Level 33

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->

## Level 33 → Level 34

#### New Commands

#### My Solutions

<!--
263JGJPfgU6LtdEvgfWU1XP5yac29mFx
-->
