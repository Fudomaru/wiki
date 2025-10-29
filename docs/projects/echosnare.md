---
title: EchoSnare
description: Personal Wifi Sniffer Project using an ESP32 with MicroPython
---

# EchoSnare

## Vision

For a while now I have been interested in Networking. 
With that a big part of understanding is working out how everything fits together. 
And so I started to think about what I can do to understand where I am, and what surrounds me in the Internet. 
What paths does my traffic usually follow. 
Can I find out where it differs. 
And I already have a few good Ideas of how to start mapping out the cables I am using all day long to talk, game, and watch stuff. 

--- 
Now it also happened that I came across something special. 
Something that probably always piqued my interest, but I have never really felt ready to dive deeper. 
Well I am ready. 
I have learned a lot, and I feel ready to get my feet wet trying to **really** understand what IoT means, what it is and what it can do. 
I found an ESP32 Dev board with battery, case, Oled Display and LoRa Modul. 
So what do I want to do with it. Everything. 
But for now I want to build my own Wifi_Sniffer.

## Tools of the Hunt

Here are the tools I plan to use for this project. 

### Hardware

* ESP32 LoRa V3 Development Board
* 3000mAh LiPo battery
* Meshtastic case
* Smartphone (for eventual geotagging)
* PC running some Linux Distro

### Software

* MicroPython
* Nvim (with MicroPython plugin)
* rshell
* ampy

## Gameplan

### Battle Station Setup

This is the first real move in the direction of actually doing something after the planning phase.
I need to get my Nvim setup for MicroPython.
For that I need to install all the dependencies I will need to finish this project. Then I set up my Nvim to have Highlighting, etc. 

### Flash and Burn

Then the next step will be flashing the right firmware to the board. 
I also need to find out which firmware I need since I have already read somewhere there might be a problem with promiscuous mode in there. 
Next just making sure it works, and I can start getting to work. 

### WIFI Sniffing Core

This is going to be the first step. 
For that I need to enable the sniffing. 
Then figure out how I can log what I need and how to save it using onboard flash. 
And last I would need to figure out good settings and control over the scanning rate and uptime. 

### OLED Display 

Next I will be considering what to do with the already integrated display. 
Thinking about it there should probably be some way to display the battery level. 
And also maybe a count of how many SSID/MAC adresses I have found and saved. 
Maybe I can do a percentage of how full the storage is or something like it. 

### Sync to Base

The last thing of the offical project is going to be how I handle syncing the data to my server. 
Since this is going to be local, I will probably try to make the ESP32 connect to my local Wifi, and then start a sync automatically. 
Maybe I find a better way, but the idea is that I can have it with me, 
and only worry about charging it. 
The rest should be automated. 

### Geotagging

As a bonus I will try to get some location to my scanned data, and maybe start to build a map. 
For that my idea is to use my androids GPS. 
And for something special the fun Idea I had was to use my phones ability to create a hotspot for a few seconds and encode the location in the SSID name, 
and later convert it back for some general location based on time. 
