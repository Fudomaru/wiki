---
title: void_linux 
description: This is the journey of me setting up my new Laptop as a minimal VoidStation.
---

# Void_Station_Setup

### Table of Contents

* [`Why Void`](#why-void)

* [`Pre-Install Decisions`](#pre-install-decisions)

* [`Installation`](#installation)

* [`Post-Install Setup`](#post-install-setup)

* [`Graphical Stack`](#graphical-stack)

* Networking (TTY Wi-Fi)

* Final Touches

* Gotchas & Lessons

* Replication Checklist

      
## Why Void

So for this there can be a lot of reason. 
But to be completely honest it comes mostly down to what I found and what sounded interesting. 
I have been looking to have something a lot more minimal then my current fedora setup. 
But not just minimal, because I still feel that is a bit of a bold statement. 
You don't just want something minimal, there is normally a reason even for that. 
And with that I am pretty clear: 
*I want to understand!*
And the less there is, the more of it you can actually comprehensivly understand. 
So starting out with a minimal system, if at all possible staying in the TTY, the possibility is a lot more realistic to actually get how everything works. 
To be clear:
I do not expect to actually be able to just comprehend the whole linux kernal like that. 
But the less I have on top, the less there is to abstract and keep me from actually knowing what is going on. 

There are a lot more fun things to learn using Void Linux. 
But these I figured out after already choosing it, and so I don't want to clame them as my reason. 


## Pre-Install Decisions

So there had to be a few decisions I had to make before, and for me also during the installation. 
The first was choosing the ISO. 
But this was relativly easy. 
I wanted a clean install without anything. 
So even if I would choose a Window Manager later on, I did now want anything like that on my ISO. 
Next was the boot method.
And there I have to be honest again, since before I started I wanted to see how it workes, I looked though quite a few guides. 
Pretty much all of them used the UEFI system. 
So that is what I choose. 

??? "UEFI vs. BIOS"
    So even though I just choose the UEFI because of the information I got. 
    Mainly BIOS doesn't have a lot of features. 
    From bigger drives and more partitions.
    It has also better graphical support and secure boot. 
    The problem is that I can't really say one of these things are a game breaker for me, so I might have to go back and figure out more details. 


## Installation 

So this was suprisiongly problematic at first.
And I still don't really know what went wrong. 
First I used the `dd` command to make the bootable USB form the ISO. 
This already impressed me, since I have never used that tool to be honest. 
Also a point where I still have a lot of things to learn. 
Then booting to the USB, and running `void-installer` is pretty straight forward. 

Now I went through the installer one by one, and all seemed pretty logically, I struggled a bit with making sure I have the UEFI partition and choose to use a bit of SWAP too. 
Also I wasnt completly sure what groups I would need, so I choose to use almost non, so I could add them later if I can't do something because I am missing them. 
That comes back to me understanding what everything is for. 
And if you add something because you need it, then you know what it is for by definition. 


## Post-Install Setup

So this is where the fun actually begun. 
Booting up I was in the tty. 
That is pretty much everything I ever wanted from a system. 
Reading up on the documentation (https://voidlinux.org) I tried to figure out as much as I could. 
But I am still far from understanding everything.

---

The first problem I run into was the font, more spefically the font size. 
Don't understand me wrong, I wanted to change the font too, but the size was the acutal problem. 
But I couldn't get it to stay persistent for a reboot.
To quickly change the the font I used ``setfont /usr/share/kbd/consolefonts/<font>``
That works fine, but I needed to find the right config file to change it. 
There I did something stupid, which cost me a lot of time.
I found the right file to change it very quickly, and just for your info, it is ``/etc/rc.conf``
It is pretty self explanatory, just setting the ``FONT="<font>"`` to the desired font. 
It was also pretty fun to find out that in the tty there isn't really a fontsize. 
Since a font in tty is just a bitmap, laying out exactly which bit is part of the letter and which is not, the different size is just a different font. 

But my problem was that I had a typo in the rc.conf file. 
So it did not take it, and I was on the search of how else to change it. 
So my big lesson learned is: if it doesn't work as expected, check again. 
It might not be that you have the wrong way to do something, it might just be a small mistake costing you sanity.

---

But I was connected to my wifi, and I started updating with ``xbps-install -Su`` and installing some basic things I liked. 
One of them is neovim.
Since I am using NVIM already on my fedora workstation, and I have the setup in my dotfiles repo, I went on trying to connect to that. 
For this I installed git and cloned my local dotfiles. 
I knew that it probably won't work completly the way I am used to it, since some of my plugins relay on the graphical interface. 
Searching it up to be exact it relies on a NerdFont Package and on truecolor. 
Since tty is not able to do eighter or, I would just have to get used to it. 
To be honest I don't really mind, since it is both just about looks, not about funktionality. 


## Graphical Stack

So there we are. 
I have set this up with the intention of a tty only minimal system to learn how everything works. 
And with that I was pretty much done. 
So all that I needed now was to work with it. 
But then it started getting to me.
I am still in a lot of need for some graphical things. 
This is why I needed something. 
It needs to be small enough to still fit my feeling of a minimal setup, but I need some basic things to make this my daily driver. 
And so I found suckless. 
I really liked the idea. 
Not just the minimal, from the feeling almost self build setup. I really enjoyed reading there documentation, having to compile it locally also sounded like a lot of fun,
and to get to the "settings" you just change the code. 
That actually sounds exatly like what I want. 
To be able to use this system, you have no choice but to understand it. 
And I just keeps going like that. 
The form of patching also made me smile. 
No updates, patches, code changes, and you do what you need to fix things, if you want to. 

That is why I descided to try my luck. 
And I installed not only dwm. 
I put ST, Dmenu, and dwmblocks. At least for now. 
I want to try to set everything up and see how that feels. 
Everything of that setup brings me closer to the metal, having more controle and for that also generates more understanding and knowledge. 
And whatever happens afterwards happens.
I would love to go to a tty only setup, but I am just not ready yet. 


## Networking

So my next step is to setup some good networking without installing any more tools. 
I am planing on using dmenu, wpa-supplicant, and dhcped. 
That and some bash script should be enough to let me create something very similar to a modern network manager.
Or at least the part that is mostly used. 
Without all the unnessesary bloat, which no one understands, or needs. 














