---
title: "Framework Followup"
date: 2023-07-17T22:55:22Z
description: After living with the 13" Framework laptop and releases of new specs for the 13" and plans for the 16", I've got some thoughts on my Framework

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
- framework
categories:
- review
image: post-cover-image/framework.jpg
---
<!-- spell-checker:ignore mainboard mainboards repairability FOMO -->

I'll start off by saying I love my Framework laptop. The transition from my old 15" laptop to this 13" Framework has been a lot more seamless than I thought it would be. It has worked perfectly for everything I've put it through.

## My Experience With My Framework

### Battery Life

Even with the recently-replaced batter in my old laptop, my Framework has a much longer battery life. Likely a combination of both the battery and processor, I'm able to get many hours of even a demanding workload. I'me able to have Discord open in a video call for hours while having many other browser tabs or games running without the worry of where my charger is.

### Lap-ability

The one loss from moving from a 15" laptop to a 13" laptop is the lessened ability to use it effectively on my lap while connected to cords. The smaller size of the 13" means that it sits more between my legs rather than fully on top of my legs. This is normally fine, especially since the fan vents to the rear rather than to the right or left so my legs aren't getting blasted with heat, but it does make having cables connected to the ports is difficult and strains the cables' connectors.

Thankfully, I typically only need to have my charger connected to my laptop, so I found a solution. Since my charger is a type-c charger, I can just pop out one of my modules and directly connect the charger's cable to the deeply-inset type-c port behind where the module would go. This make only the small cable be pressed against my leg and does not put any strain against the cable.

### Charging Fan

One thing that has disappointed about my Framework is the leaf blower it turns into when plugged in to charge (when the battery is discharged). I think a combination of moving from the "Better Battery" Windows power profile while on battery to "Best Performance" when plugged in and the extra heat from the high-speed charging capabilities means the fan kicks up to be quite loud when plugging in. I have not played around much with power profiles to try to reduce this, but it typically only lasts for a short time and I almost always prefer the better performance rather than a bit of ignore-able noise for a bit.

### Physical Camera/Microphone Switches

I didn't think this would be a big thing, but it is really nice to be able to have confidence that at the hardware level, my mic and camera are not able to be accessed.

### E Cores

As I have a wide, eclectic collection of software I run on a regular basis, I was please to not run into many issues with programs not properly understanding/scheduling with the efficiency cores on the 12th gen Intel processor. There are some tools (e.g. zstd) which doesn't properly gather the cores to use. However this could be due to running some of these quirky tools in WSL and how some tools try to detect hyper-threading to schedule themselves only on physical cores.

## FOMO?

Now that 13th gen Intel and AMD mainboards have come out for the 13" Framework, do I feel like I am missing out or should have waited? not at all. If I would have needed a laptop once the 13th gen had come out, I would definitely have chosen to use the 13th gen mainboard, but I am happy with what I have. Especially since I rarely have a [use case](../framework-first-impressions#use-case) for a high-performance laptop, I'm very comfortable with my 12th gen.

Part of the appeal of the Framework is that I don't have to have as much of a fear of missing out. The new laptops all have the same hardware outside of the mainboard. If I want a 13th gen laptop, I can easily upgrade my existing laptop to the 13th gen and get a 12th gen computer to use as a server, media PC, etc. And if I keep my laptop for long enough that the hardware is wearing out, I can replace the parts that are broken (or of which I want an improved version) and keep all the remaining parts, reducing the cost of repair and keeping still-good parts from ending up e-waste.

As for regrets getting the Framework rather than some other newer system, I have none. I have not stayed as up-to-date with the laptop scene since I'm not currently in need of a new one, but the systems that I have seen have not presented any better features or performance for my use cases. Some of the new Apple laptops have been interesting to follow, but I'm not a big fan of many aspects of Apple's hardware and ecosystem and I still do come across some software that is not compiled for ARM (a big one being Windows). I love ARM and use it quite a bit in my homelab (mostly Raspberry Pis), but for my main system is just not quite universal enough for a daily driver.

## Conclusion

Overall, I'm very happy with my Framework and would absolutely recommend it to others. Yes, it is more expensive than another laptop with comparable specs, but the Framework's build quality is supreme. If your use of laptops is more disposable, the Framework may not be for you (and that is okay), but I value the goals of the Framework and truly expect to get my money's worth out of the repairability and modularity of the Framework.
