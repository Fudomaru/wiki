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

* [`Networking`](#networking)

* [`Final Touches`](#final-touches)

* [`Lessons learned`](#lessons-lerned)

* [`Replication Checklist`](#replication-checklist)

      
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
I put ST, Dmenu, and slstatus. At least for now. 
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
Everything Else comes later. 


## Final touches

There are a few things I want to do. 
I started with the thing that bortherd me the most.
And then I worked form there. 
This way I hoped to build up only what really helps me, and what I want visually. 

#### First Visuals

For that reason I startet with slstatus. 
The things I wanted to display are only things that I would actually want to look at. 
Something that gives me information I need and want to check regularly. 
That came out as following: Time and Date, Battery (since it is Laptop), RAM usage.
There is one more thing, which is still a to-do. 
And that would be some way to show where I am. 
But I want that to be mainly for when I am using SSH, just to have a clear way to see on which mashine I am working on. 
That set up I have now looks something like this: 

``` c
static const struct arg args[] = {
    {datetime, "%s", "%d"},
    {datetime, "%s", "%T"},
    {battery_perc, "%s%%", BAT0},
    {ram_perc, "%s%%", NULL},
}
```

Then I also got myself some Nerd Fonts, put the ones I wanted in **dwm** and in **st** and fixed the size, to make everything feel more like home. 
And directly after that I also installed the fibonacci patch for dwm,
because I think that is one of the most efficent layouts I can think of. 

<!-- 
TODO
--> 

## Lessons learned

With this project there are a lot of things I have learned, and am still learning. 
But most of them don't really bolong into a "lessons learned" section. 
I feel like here should mostly belong things that went wrong and taught me something. 
Since this is an ongoing experiment, I think there will still be a lot of things that go wrong.
So this part is going to be regularly updated with everything I have learned.

#### Minimalism

With this project I feel like the most important lessons I have learned,
is the difference people can see in the same idea. 
At the beginning, a minimal system mostly sounded like something without a lot of buttons and programs constantly running. 
I thought that it could be a really good looking aesthetic. 
Less programms already installed. 
And maybe I even recognized a smaller ISO file size. 
But working with it, and trying to find my way and make this PC my own, I learned what that really means. 
It means that there is a whole lot of things that can be made simpler. 
Things that work the way they do, because somewhere there is some edge case that needs them to work that way. 
But that also adds a huge amount of noise. 
And with a minimal setup, it constrains and makes you think about what you actually want and need. 
The best example is networking. 
There are a lot of things that can be done in networking.
And almost all of these things, I dont need for my day to day work. 
For a stationary PC, even if it is connected over wlan, I dont need a menu and all these different settings to manage different SSIDs. 
I am not moving a stationary PC. 
And I am not changing the SSID of my wlan weekly, or even monthly, probably not even every year. 
So in this case, every one of these options is noise. 

I think this one of the best way for me to explain it. 
Maybe I can find a better explaination in the future, but for now that needs to be enough.


## Replication Checklist

Get yourself a base image of Void Linux. 
Also you need a USB stick without any important data on it. 
Burn the ISO on the USB stick using

``` 
sudo dd if=/path/to/your.iso of=/dev/sdX bs=4M oflag=sync
```

Then you just need to start you pc from the USB. 
It starts into the live void system, and you are already almost done. 
There are now just a few options you need to set and fit to your liking. 
For that, I wouls say you do your own research, but I will give you my settings anyway. 
After you start the installation process you just run ``void-installer``. 
Going though the different options you need to choose your keyboard and network yourself. 
For source I used the network with base installation. 
Next is the partioning. 
I use cfdisk, and cleaned everything form the PC, because I did my backup beforehand. 
I made a 1g efi partition, and put everything else into a file system. 
The mount points need to be as following:
For the boot partition it is ``/boot/efi`` and the root partition is just ``/``.
Then you have to create a user and and choose which groups you want to be in. 
That is also completly your own choice. 
Just one thing that helped my decision. 
Since I wanted this to learn how everything works, I didn't choose anything. 
I know I can log into root if nessesary, and I can put myself to every group I want to if nessesary. 
Then you start the installation and you are pretty much done with everything I will decribe here. 
From there you choose what you want. 








