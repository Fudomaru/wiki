---
title: bandit
description: Aimed at Beginners. Teaching the basics of linux commands and system structur. 
---


## Level 0

So first of all: The setup:  
OvertheWire is something I found as a good way to get started with CTFs. 
Bandit is a simple Linux machine, setup in a way, where each "flag" you find is the password for the next level.
With this password you can access the machine over SSH, using the level as a username.  
It is aimed at absolute beginners, teaching the basics of Linux and playing CTFs. 
For each level you get a list with new introduced commands, which can help you with figuring out what to do. 

## Level 0 → Level 1

The first level is mainly to get the setup right.  
It explains that you connect over SSH over port 2220 to bandit.labs.overthewire.org.  
The username is bandit0 and the password for the first level is given -> also bandit0.  

#### My Setup:  
I don't really want to miss out with the Linux experience, so I use WSL2 on my Windows machine.  
It worked like a charm. 

#### New Commands  
For this there was only one command given: [**SSH**](/linux/cli-magic/#ssh)  
This is used to get a secure remote access to another machine. You use this general format:  
`ssh username@connection.address`  
In this case that would look like this:  
`ssh bandit0@bandit.labs.overthewire.org`

#### My Solutions

I think for this the most important step is to not forget about the port.  
At first I wanted to just skip reading and try things out, thinking of the way a port is put in an URL. My first try was this:  
`ssh bandit0@bandit.labs.overthewire.org:2220`
That was obviously wrong.  
So I did have to figure out what the right way was.  
I wanted to improve in figuring out this the right way, so instead of looking it up online, I opened the man pages.  
And shortly after that I found it.  
I had to use a -p flag to give it the port to use. So I got connected with:  
`ssh -p bandit0@bandit.labs.overthewire.org:2220`  

So I was connected.  
It was a nice greeting in consol, giving a bit more information on the game.  

But I wasn't done.  

There was still something missing.  
The flag, or to be correct: The password for the next level.  
I started just looking around. With `ls` I found the conveniently placed readme file.  
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
I was really surprised to find output in front of my bash setup. It wasn't too bad, and just brute forcing my way though all 10 files, it was easy to find the human readable file and the flag.  

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
[find](/linux/cli-magic/#find)

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
Going though it, with most of them I had no permissions to look at them anyway.  
So a quick google search came up with this to check the return code.  
Then it saves everything that is coded with an standard error (2) to the dedicated place for deletion:  
`find / -user bandit7 -group bandit6 -size 33c 2>/dev/null`    

<!--
morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj
-->

## Level 7 → Level 8

#### New Commands  
grep, strings, base64

#### My Solutions  
So for this level there where a whole lot of new commands.  
The Info for this was as follows:  
The password for the next level is stored in the file data.txt next to the word millionth  
That meant I now what to do:  
`cat data.txt | grep millionth`

<!--
dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc
-->

## Level 8 → Level 9

#### New Commands  
sort, [uniq](/linux/cli-magic/#uniq)  

#### My Solutions  
So same set up, but the only line of text that occurs only once.  
For this I imidiatly went to the `sort` command.  
I thought that would make it easy.  
But I was wrong.  
Probably I could just go though the output and find the line that only occurs once.  
But I want it clean.  
If at all possible just giving me the one line I need.  
I went looking, but didn't find anything in the sort command.  
Back to the list with new commands.  
Kind of ashamed I saw that the next command is called `uniq`.  
If that is not made for finding something only existing once in the file.  
After reading though the man page, I figured I would need to use both.  
In the end it looked something like that:  
`sort data.txt | uniq -u`

<!--
4CKMh1JI91bUIZZPXDqGanal4xvAg0JM
-->

## Level 9 → Level 10

#### New Commands  
string

#### My Solutions  
So I have a data.txt, but it is all gibberish.  
Again needing to go back to the description.  
It is supposed to be the only human readable string preceded by several =.  
For me the imidiat problem is that several is not very specific.  
But leaving that for the end, I needed to find some good way to look for the right part. I though for the equal sign I can just use `qrep`.  
Sadly that wouldn't want to work.  
Back to the commands.  
Just checking the next in line, since they seam to come in order, gave me this final answer:  
`strings data.txt | grep "=="`

<!--
FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey
-->

## Level 10 → Level 11

#### New Commands  
base64  

#### My Solutions  
Going though the description first this time I learned, that the data this time  is base64 encoded.  
So it seams it was pretty straight forward.  
Reading though the docu for `base64` and building a functioning command to use it.  
`base64 -d data.txt`

<!--
dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr
-->

## Level 11 → Level 12

#### New Commands  
tr  

#### My Solutions  
With this I had a bit more problems.  
I feel like I have heared it somewhere before, so I search online for what this actually is.  
This is how I found [ROT13](#level-11--level-12).  
With that knowledge I just tried looking at the next command.  
`tr` is for translating or deleting charaters in a text.  
So I knew what I had to do.  
Delete every letter with the corresponding one.  
`cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'`  

<!--
7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4
-->

## Level 12 → Level 13

#### New Commands  
tar, gzip, bzip2, xxd  

#### My Solutions  
So for this the info for the level recomanded to make a directory to work at.  
I did as I was told.  
Then I started working my way though everything saving every step of the way.  
First I converted the hex dump back with:  
`xxd -d data`  
Afterwards I always look what conversion was used with `file`, then changed the name to have the apropriat ending with `mv` and used the fitting decompression command.  
This I needed to do 10 times until finally -> filetype: ASCII  
Finally I was done and had the password.  

<!--
FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn
-->

## Level 13 → Level 14

#### New Commands  
ssh, telnet, nc, openssl, s_client, nmap

#### My Solutions  
This was pretty exciting for me.  
I am a big fan of using keys and what happens when it gets into the wrong hands.  
This might be why I never saved the password for level 14.  
I copied the privat key and used it to connect directly to the bandit14 account.  
But I do know you are supposed to connect to bandit14 from your bandit13 account.  
The command for that would be:  
`ssh -i sshkey.private -p 2220 bandit14@localhost`

<!--
MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS
-->

## Level 14 → Level 15

#### New Commands  
nc

#### My Solutions  
For this I was really unsure what to do at first.  
Okay that is not quite true.  
The level description actually tells me exactly what to do.  
However, I was unsure how to send something to a port.    
This means I went to the internet to figure it out.  
And found out that I can use netcat for it.  
So I connected to the port using  
`nc localhost 30000`  
and send the password. 
And promt I got the new password for bandit15.  

<!--
8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo
-->

## Level 15 → Level 16

#### New Commands  
openssl, s_client

#### My Solutions  
I used the openSSL s_client to connect to localhost Port 30001. 
It worked very smoothly and I send the password for the level.  
`opelssl s_client -connect localhost:30001`

<!--
kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx
-->

## Level 16 → Level 17

#### New Commands  
nmap

#### My Solutions
First I scanned the given portspace with nmap also trying to find out the service version.  
`nmap -p 31000-32000 --open -sV localhost`  
The options made the port I needed pretty clear.  
Next I thought to pretty much just do what I did in the last level.  
First it did not work and made me really scatch my head.  
---
So after I quite literally smashed my head against the keyboard I finally stumbled upon a solution.  
I got the connection to the port.  
I also seam to have the right password, since if I put anything else in, I got the message "wrong password" and it kicked me of the connection.  
But for my password, I only got KEYUPDATED and not the actuall key.  
I do not know why, but for some reason I could not find out how to look at the key.  
My solution finally was this:  
`openssl s_client -nocommands -connect localhost:31790`  
With that I avoided the KEYUPDATED information, and instead got the key, which I used like in one of the earlier levels to connect via a SSL key.  

<!--
kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx
-->

## Level 17 → Level 18

#### New Commands  
diff

#### My Solutions  
In comparison with the last level, I felt like it was to easy to work.  
But I pretty much just used `diff` to compare the old and new password files.  
And used the result to log into the next level.  

<!--
x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO
-->

## Level 18 → Level 19

#### New Commands  
scp

#### My Solutions  
So I really liked this idea from the start.  
Instead of just logging in and finding the password, you are actually logged out.  
Or at least something like it.  
When you log in you are imidiatly kicked back out.  
---  
So I logged back unto level 17 to see if I can just open the readme file from there.  
But of course I did not have the permissions to do so.  
Also I looked at the .bashrc file to see if I can figure out how exactly it works, and how I can get around it.  
But while looking at it, I had another idea.  
And so I used folling command to copy the readme file to my own mashine.  
`scp -P 2220 bandit18@bandit.labs.overthewire.org:/home/readme ./bandit18pass`

<!--
cGWpMaKXVwDUNgPAVJbWYuGHVn9zl3j8
-->

## Level 19 → Level 20

#### My Solutions  
This one was really straight forward.  
Just do what you are told in the description and you get the password.  
But it is made to teach about setuid and what that means, so I need to learn more about it. 

<!--
0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO
-->

## Level 20 → Level 21

#### My Solutions  
This I found also really interessting. I couldn't get tmux to work, which is why I will not put it as a new command here.  
But I do need to learn how to use it.  
Instead I connected twice, the old fashen way. I just opened two terminals, and connected both over SSH.  
After that it was just a matter of knowing what to do.  
On the one side I opened a nc listener, and connected to it with the setuid from the other side.  
Then I gave the setuid the password, and got the next one out.  

<!--
EeoULMCra2q0dSkYj561DX7s1CpBuOBt
-->

## Level 21 → Level 22

#### My Solutions  
For this I got to see cronjobs for the first time, at least in this game.  
I went to look at the bandit22 job in /etc/con.d/ folder.  
Here I found a script, and looking at it I just needed to cat the file the password got saved in.  

<!--
tRae0UfB9v0UzbCdn9cY0gQnds9GF58Q
-->

## Level 22 → Level 23

#### My Solutions  
The first part was just like the last level.  
Looking at the cronjob_bandit23.sh I understood that it did some conversion with md5sum and a sentence that contains a variable from the current whoami command.  
With that I recreated that converstion using bandit23 as the variable.  
Then it creates a temp file with this as the name and saves the password from the current user in it.  
This file I could just cat to see the next flag.  

<!--
0Zf11ioIjMVN551jX3CmStKLYqjk54Ga
-->

## Level 23 → Level 24

#### New Commands  
chmod

#### My Solutions  
Same trick new rules.  
This was really fun for me because I really had to think about what permissions really mean and on how many levels they work.  
I found the script that was run by cron every minute at the same place as the last.  
It is pretty much to excecute everything in a specific folder and afterwards delete everything in that folder.  
But one small problem for me. The scripts only runs if the executable is owned my Bandit23.  
Shouldn't be hard since that is where I already am. But still a bit eye opening for me.  
The permissions of access is determined by the one that executes, even if the owner of the script is someone else.  
So I made this to just copy the pass into my temp file:
```
#!/bin/bash
cat /etc/bandit_pass/bandit24 > /tmp/tmp.RXVt3VhFpv/pass24.txt
```  
Should work like a charm.  
I checked the permissions, and the ownership and made sure everything is correct with chmod.  
After moving it into the write folder, I was waiting for cron to run to get the password.  
It never happened.  
Then it tool quite a while for me to figure out, that Bandit24 didn't have permission to write into my temp folder, so as soon as I changed that, everything worked.  

<!--
gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8
-->

## Level 24 → Level 25

#### My Solutions  
For this I could either try ever 10000 possiblities by hand, or I had to come up with a script.  
So the script it was:  
```
#!/bin/bash

password="Old Password"
{
    for pin in $(seq -w 0000 9999); do
        echo "$password $pin"
    done
} | nc localhost 30002
```

<!--
iCi86ttT4KSNe1armKiwbQNmB3YJP3q4
-->

## Level 25 → Level 26

#### My Solutions  
So I guess this one I can easily just scip. You get a SSL Key for level 26.  
That is why it wasnt ever important for me not have the normal shell.  
I just grabbed the key to the next level and was out of there.    

<!--
s0773xxkk0MXfdqOfPRVr9L3jJBUOgCZ
-->

## Level 26 → Level 27

#### New Commands

#### My Solutions  
Small Window to get `more`.
Use V to get into vim.  
Use `:term shell` to normally get a shell in the top half of the termanl.  

With that you can get a shell and take what you need, like the password for bandait26 just to be sure to have it.  
It is saved in the same spot all the other passwords are saved, and can just be read out:  
`cat /ect/bandit_pass/bandit26`  
---  
But that isn't it.  
You also have to get to bandit27 from here, or get the password somehow.  
Luckely the solution for that came from [Bandit19](#level-19-level-20).  

<!--
upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB
-->

## Level 27 → Level 28

#### New Commands  
git

#### My Solutions  
So for this you have to use `git` for the first time.  
But it was not too difficult yet.  
You have to clone the repo, and make sure you are on the right port.  
`git clone ssh://bandit27-git@bandit.labs.overthewire.org:2220/h
ome/bandit27-git/repo`  
After that I just took a look inside, found a readme file, and there was the pass for the next level.  

<!--
Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN
-->

## Level 28 → Level 29

#### My Solutions  
The description for this level was the same as the last one.  
So I went the same way and cloned the repo, and looked at the readme file.  
It desplayed the the credentials of Bandit29, but the password was **xxxxxxxx**.  
Since I know git is a version control, I thought that is probably *the* feature for me to learn about.  
So I looked at the perviouse commits with:  
`git log`  
And in one of them I found the comment **fix info leak** and in the one before it read **add missing data**.  
So of course I needed to look at the **add missing data** commit just to see what that meant.  
`git checkout <commit-hash>`  
That reverted me back to the version befor the info leak fixing.  
And now it was just a matter of looking at the readme file, and copying the password.  

<!--
4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7
-->

## Level 29 → Level 30

#### My Solutions  
Same stepps as in the last two levels. But no results.  
So I looked at the different branches.  
`git branch -r`  
There were severeal branches, but the one that imidiatly took my interest was *origin/sploits-dev*.  
So I got to work.  
`git pull origin sploits-dev`  
Pulled the branch I wanted to take a look at.  
`cat exploits/horde5.md`  
Let me see what is in there.  
But there wasn't anything in there. So I took a look at the previouse versions.  
There had to be something, but after reading the comment **add some silly exploit, just for shit and giggles** I knew.  
They played with me.  
So I went back to look at the other branches.  
I saw the branch origion/dev and thought to myself:  
Since the readme file said for password **not in Production** that would be a strong hint, that maybe the dev branch already has something.  
So I want to the dev branch and looked at the readme file, and found the password.  
`git fetch origin dev`  
`git switch dev`  
`cat README.md`

<!--
qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL
-->

## Level 30 → Level 31

#### My Solutions  
Same same. Just cloned the repo, looked at the log and the branches.  
And found nothing.  
After a while of searching online, what all you can do with git, I found tags.  
I looked at the tags and found: **secret**  
`git tag`  
`git show secret`  

<!--
fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy
-->

## Level 31 → Level 32

#### My Solutions  
Again I cloned the repo and looked at the readme file. This one had a really interesting description of what I needed to do.  
I had to upload a file with specific conditions.  
So I got to work. 
```
echo 'May I come in?' > key.txt
```
I also needed to delete the `*.txt` from the .gitignor file to get everything to work. 
Then it was just:  
```
git add .
git commit "something clever"
git push
```
And I got the next password back. 

<!--
3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K
-->

## Level 32 → Level 33

#### My Solutions  
This was a lot of fun.  
When I arrived, I found this:  
`WELCOME TO THE UPPERCASE SHELL`  
So I tought, that should not make too much of a difference.  
But I was very wrong.  
Non of the previously learned commands worked.  
But I could try around and see if I find something good to do.  
After searching though the web for shell commands that only use uppercase, I pretty much only found the variables.  
So I looked though them to see what there is.  
Maybe I can use one of them to escape this uppercase shell, just like the level desciption suggested.  
I found one: `$0`  
With that I was back to something more usefull.  
But for convinence I wanted more.  
`/bin/bash` got me to something I was used too.  
But there was still the problem with getting the next level password.  
At least until I noticed that I am already bandit33, so I just went to the usuall place and get my password. 
`cat /etc/bandit_pass/bandit33`

<!--
tQdtbs5D5i2vJwkO8mEyYEyTL8izoeJ0
-->

---


!!! example "Conclution"
    With this I got though all of the bandit levels. I think it is an awesome experiance, a lot of fun, and you can learn a lot of the basic commands and structure of a Linux system. Also you get used to the idea of not knowing something, and figuring it out on you own. 