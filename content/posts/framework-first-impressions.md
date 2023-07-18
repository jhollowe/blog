---
title: "Framework First Impressions"
date: 2023-02-24T02:10:42Z
description: I recently upgraded my laptop to a Framework laptop since my old trusty laptop's screen cracked and a replacement screen cost as much as new some laptops. These are my initial impressions of the laptop's build, performance, and usability.
draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- hardware
- life
series:
- framework laptop
categories:
- review
image: post-cover-image/framework.jpg
---
<!-- spell-checker:ignore trackpad repairability SODIMM -->

I recently upgraded my laptop to a Framework laptop since my old trusty laptop's screen cracked and a replacement screen cost as much as some new laptops. These are my initial impressions of the laptop's build, performance, and usability.

## Use Case

I have a bit of a minimal use case for my laptop. Since I have a powerful desktop and a fairly performant phone, I don't need my laptop to be a do-everything device. If I need to do something that requires a lot of performance (gaming, heavy development builds, video transcode, etc), I will use my desktop. If I need to quickly do something, I will use the phone that is always in my pocket or on the desk next to me. My laptop fulfils three main functions: portable large-screen remote access to desktop, couch web-browsing and light development, and media consumption while on the road.

### Desktop Remote

The main place I will install games and software, store some files, and do high-performance tasks is on my desktop. I often will need or want to do something on my desktop while not sitting at my desk. Be it from a few meters away on the couch or thousands of kilometers away, I will often remote into my desktop from my laptop. There are not really any specific requirements, but a large screen, enough CPU performance to decode the remote screen stream, and good enough networking to get the connection through. This is honestly the lowest performance need for a laptop, but having hardware decode for whatever remote solution would provide long battery life for this use case.

### Couch Computer

This is the middle-of-the-road use case in terms of requirements. It is mostly web browsing, some light video consumption, and low-demand development/writing (like writing this blog). I use VS Code devcontainers for just about everything, so being able to run docker and VS Code well is a must. Mostly, this presents as having enough memory for the containers, VS Code (thanks memory-hungry electron), and all the extensions I typically use. Occasionally, having some performance is nice to be able to build a new dev container (fast network to pull dependencies, fast CPU to decompress image layers and compile dependencies, and mostly fast disk to support fast installation of packages, create new layers, etc.) and makes getting started contributing to a new project incredibly streamlined.

### On-the-road System

This is the most taxing use case that I have for my laptop. This is everything from [Couch Computer](#couch-computer) and more. Some video transcoding (compressing) of footage I've taken, some light (and not-so-light) gaming, and occasionally some heavy network traffic (using my laptop as a portable NAS or sneaker-net).

This is also the use case where the connectivity of the laptop is the most important. From hooking into projectors using HDMI, to needing ethernet for some network troubleshooting, to flashing a Raspberry Pi or reading images from an SD card, the most variability in how I interact with my computers is on the road. The ample expansion/connectivity modules make it easier to have the right connector where I want it, when I want it. Also, the ability to move my ports around mean I will never have to do the awkward my-HDMI-is-on-the-wrong-side-for-this-podium dance again. Further, having 4 thunderbolt USB-C ports means that even if there is not an official module for what you want, you can easily connect a dongle or even make your own modules. Always in the data center? make yourself an RS-232 serial port module for interacting with all the serial consoles on your hardware.

### Desktop Replacement

As a bonus use case, I will very, very rarely use my laptop at my desk instead of my desktop. My work laptop usually sits on my desk, plugged into a thunderbolt dock connected to all my peripherals and monitors. Every once in a while, I might use this setup with my personal laptop in this setup if I was working on some project on my laptop that would be too cumbersome to move to my desktop but might benefit from the extra monitors and peripherals.

## Build

### Form Factor

The Framework is a 13.5" laptop with a 3:2 screen ratio. While I'm used to my previous laptop's 15" form factor, the added height of the Framework's screen and higher resolution maintains a good amount of screen real estate. It also provides a more compact body which is more portable and takes up less space on a desk. Weighing in at 4.4 lb, it isn't a light laptop, but the incredibly sturdy chassis and zero deck flex on the keyboard are reason enough for the bit of weigh.

### Power and Battery

It uses Type-C (USB-PD) for charging via any of the 4 expansion ports when a USB-C expansion module is installed (or really you can directly connect to the type-c ports at the back of the expansion ports). This allows charging from either side of the laptop which brings a great versatility. While writing this, the idle power draw was ~15W at a medium-low screen brightness. Running a benchmark, the draw from the USB-C charger reached ~62W (on a 90W charger).Charging from 0% to ~80% while powered off averaged around 40W. Charging from ~85% to 100% averaged around a 30W draw (~10W to the battery and ~15W to the idle running system).

### Keyboard

The keyboard is easy to type on with ample key spacing and a sensible key layout.  I wrote this whole post on the Framework's keyboard. The keys have good stabilization and have a comfortable travel distance. The palm rest areas beside the trackpad are large enough to use and the keyboard is centered on the chassis so one hand/wrist is more extended than the other.Overall, an easy keyboard on which to type.

### Trackpad

Not much to say about the trackpad, and that is a good thing. The trackpad is a nice size: not too small to be useless and not too large to be cumbersome to use. It has a nice tactile click when pressed (which I rarely notice since I mostly tap-to-click rather than use the actual displacement button method of clicking) and a smooth surface which is easy to swipe across. The trackpad's palm rejection while typing is very good, but the button still functions while the movement is disabled. If you place a lot of weight on the insides of your hands while typing, you may need to be careful to not push too hard on the trackpad while typing. The typical multi-touch gestures work correctly and smoothly zoom, swipe, and the rest.

### Speakers

The speakers on the Framework have impressed me so far. I will use earphones/headphones over speakers most of the time, but the speakers are much better than my previous laptop's speakers and are a nice, usable option. They are quite loud and even at 100% there is no distortion, clipping, or chassis rattle. Although the speakers are down-firing at the front (user-facing side), they are on the angled bevel of the side so even sitting atop a flat surface the speakers fire out and around the chassis to provide a well-balanced sound profile.

## Performance

### CPU

My Framework performs well. I got the i5 12th gen variant (i5-1240P, up to 4.4 GHz, 4+8 cores) as a low power yet still performant portable system. Following on the [Desktop Remote](#desktop-remote) section above, I very rarely need my laptop to be very performant. What I want most of the time is something that can boost to do a little bit of compute while mostly being a power-efficient system that can run web apps, remote desktop software, and YouTube. The system excels at these tasks. I'll leave the hard numbers and comparisons to benchmark publications, but the system has done everything (within reason) I've thrown at it.

### Memory

While it may seem basic, the ability to have socketed memory can't be ignored in modern laptops. Being able to upgrade and/or expand your system's memory down the line is one of the simplest ways to give an old machine a boost. However, a lot of new machines are coming out with soldered memory that can't be upgraded, expanded, or replaced. The availability of 2 SODIMM slots for memory is a great feature for repairability and the longevity of the system.

### Cooling and Fan

One disappointing aspect of the Framework is its cooling system and fan. When idle, the fan is inaudible and the user-facing components stay cool. However, even when idle the bottom chassis panel gets slightly too warm to hold for a long time. While on a desk, this is not an issue but when on a lap (where the lap in laptop comes from), the heat it a bit too much for bare skin contact and going hand-held with one hand on the bottom for support is not comfortable to hold. However, even when running full-tilt under a stress test, the top (keyboard, trackpad, and palm rest areas) stayed cool and comfortable.

The cooling fan, when going at full speed, is loud but does an adequate job of keeping the internals cool and preventing drastic thermal throttling. A concern I had heard from others was with the vent being in the hinge and concerns over the cooling capacity of the system while the screen is closed. After some tests, the hinge cover is shaped to direct the exhaust air out the bottom of the hinge which gives enough airflow to keep the system cool.

### WiFi 6E

While I currently don't have any other wifi gear which supports 6E to test against, I believe 6 GHz is going to be super useful in the coming years and having a computer that already supports it is a great feature. And even if it didn't have a 6E chip in it, the Framework's wifi is socketed which allows for future improvement.

For what I can test, the Framework's WiFi works well. It gets the maximum speed my Access Point (AP) supports and has very good range. I haven't noticed any difference it reception between different orientations of the laptop, so the antenna placement seems to be the best it can be.

## Usability

### I/O

The ability to select the I/O that your laptop has is one of the obvious usability features of the Framework. The ability to have up to 4 USB-C thunderbolt ports is impressive and the various modules to adapt those ports into other common ports is fantastic. My favorite ability so far is just having a USB-C port on both sides of the laptop. When I was searching for a new laptop, few had a Type-C port and even fewer had at least one on both sides. The Framework works well with all the USB-C and thunderbolt docks and dongles that I have used with it.

### Battery

Another great usability feature is the long battery life. The combination of an efficient processor and a high-capacity battery makes the Framework able to stay running for hours.

### Security, Privacy, and Webcam

For security and privacy, the Framework has several great features. For signing in (on supported OSes), you can use the fingerprint sensor integrated into the power button for authentication. While my previous laptop had a Windows Hello capable camera, the fingerprint reader is just about as easy to use. The fingerprint reader works well

On the webcam, the Framework has physical toggles to disable the webcam and disable the microphone (independently). They toggles have a nice red section visible when disabled and the camera has a light when it is active. It is really nice to have physical switches for the cameras, and since I am using the fingerprint sensor for login (instead of the facial recognition of my previous laptop), I can leave the camera disabled most of the time. The camera is 1080p and does a good enough job with challenging situations like low light and high contrast environments.

### Screen

The screen is a 2256 x 1504 (3:2) glossy screen. The extra screen real estate is nice for tasks that can make use of the extra vertical space, media consumption which is mostly 16:9 or wider leaves unused space on the screen. The maximum brightness of the screen is quite bright and is easily visible in direct sunlight. The screen also has a light detector which can be used for automatic screen brightness adjustments. However, at least in Windows, the auto brightness works well but causes a massive jump in brightness when adjusting to above ~50%. Due the the glossy, highly-reflective screen, bright sun from behind makes it hard to read the screen even at maximum brightness. I'm planning to investigate what matte screen films/protectors are available that I could use to make the screen less reflective. As I will very rarely use my laptop for very color accurate uses, a matte screen would be better.

### Windows Install and Drivers

One cautionary note revolves around the newer, less used components in the Framework. I installed Windows 10 and out of the box, the trackpad and WiFi did not work. I had to use an Ethernet dongle (since I did not get the ethernet Framework module) to download the driver pack from Framework's website. It did not automatically get the drivers from Windows Update like most other firmware/drivers. I also tried Ubuntu 22.04, and while it had fully functional WiFi and and trackpad out of the box, it did not properly adjust the screen backlight based on the function keys (but was able to control the brightness manually using the OS settings slider).

## Overall Impressions

Overall, I really like my Framework laptop so far. I did not think I would like the smaller size, but setting the display scaling to lower than the default of 200% (I'm testing between 175% and 150%) give more than enough screen space for task I need to do on my laptop. After writing this whole post on the keyboard both on a couch and a desk, it is comfortable to type on and quick to pick up touch typing. It is small and portable while having good performance, battery longevity, and screen real estate. I wish it was a bit bigger as I like a laptop with a larger screen, but for the chassis size the screen is nearly 100% of the size of the laptop footprint. With a 11-in-1 USB dongle, it has as much or more connectivity than my desktop. It works flawlessly with thunderbolt docks (at least the ones I have tested). The first install of Windows 10 was a little painful having to install the driver bundle, but that is a small, one-time price to pay for a nice machine on an old OS.

9.5/10. Would recommend.
