---
title: "A Trickle Is Better Than Nothing"
date: 2021-01-02T21:31:47-05:00
description: "While it is always a shock to go from over 100Mbps to under 1Mbps, I think that we are in an age where low bandwidth is not a show-stopper."

draft: false
enableToc: true
hideToc: false
tags:
- web
- life
- opinion
series:
- 
categories:
- networks
image:
---
<!-- spell-checker:ignore datacenter -->

I'm at my extended family's house way out in the middle of nowhere; barely enough cellular connection for an SMS, let alone trying to use any data.
They have DSL, but they are so far out that the signal is poor and it also is horrible speed. The fastest I saw while I was there was 700Kbps.

While it is always a shock to go from over 100Mbps to under 1Mbps, I think that we are in an age where low bandwidth is not a show-stopper. Now obviously, downloading large files and games is a lot more tedious, I have found the "set everything to download overnight" method works quite well.

I think there are three main reason why you can do more with less bandwidth than ever before.

## Compression and Codecs

We have reached the point where processing power is so cheap, most of the time everything else is the limitation. We are glad to spend some power and time compressing data if it means we have more storage space on our devices or use less data. Website analysis tools will now complain if a webserver *doesn't* compress its responses with at least gzip.

We are (slowly) starting to use new video and audio codecs that compress the crap out of the video/audio stream. Many devices are even starting to have highly performant hardware acceleration for these formats so it doesn't even cause high load or power draw on mobile devices. Services like YouTube automatically convert content to many different qualities and have algorithms to pick the best quality that you can support.

## Caches, CDNS, and Apps

Every web browser has a cache. Many even have several tiers of cache to give good hit/miss ratios and speed. If you are going to Facebook, you really should only ever need to receive the logo, most styles, and even some content once. This not only helps on slow connections, but even on fast connections an additional resource request can take a (relatively) long time to do an entire TCP and SSL handshake transaction.

A further performance increase can be gained through websites' use of CDNs for their libraries and assets. If you are loading jQuery, FontAwesome, or bootstrap from local, you are doing it wrong. Pulling these assets from a CDN not only reduces the load on your server and the latency of the client accessing the resource, but allows caching these common resource between sites. If you visit a site using version x of the y library and then visit another site that uses the same version of y, you should be able to cache the first request of that resource and reuse it for any subsequent pages in any site. You can only do this if you using a CDN (and the same, but realistically most resources either have their own CDN or use one of the most common CDNs that everyone else uses).

Additionally, the use of site-specific apps (while annoying) allows the apps to only pull new content and "cache" all the resources needed to display the app. This makes it assured that outside of app updates, ~~all~~ most of the app's traffic is the content you want to see (or ads *sigh*).

## Mobile Focused Pages

Thanks the the horrible practices of the Cellular Companies, anything that is loaded on a cellular connection needs to be small to not use much data to fit within limited bandwidth and even more limited data caps. While I have a great distaste for the stupidity of Cell carriers, their limitations have ~~forced~~ encouraged developments in efficient compression and transmission of pages (as well as a lot of bad practices in lazy loading and obfuscating in the name of minifying). Mosts sites will load smaller or more compressed assets when they detect they are on mobile platforms.

## Caveats

While I did "survive" on the limited connection, I knew it was coming and was able to prepare a bit for it. I downloaded a couple of additional playlists on Spotify and synced a few episodes of TV to my phone from my Plex. However, I did not even use these additional downloads. I used the podcasts I had previously downloaded and even downloaded an additional episode while there. The ability in most apps to download content makes even a trickle of internet be enough to slowly build up the content you want.

I have also recently reset my laptop and had to download FFmpeg while there. It took a few minutes, but it didn't fail. I did want to do some complex computing while there, but since most of what I do is on other computers (servers, remote machines, etc) it was incredibly easy to do what I wanted to do through an SSH connection to a datacenter. This is cheating a little bit but really is not out of the ordinary; even on fast internet I would SSH out to do things I didn't want or couldn't do on my device (thanks Windows). This not not that different from devices like Chromebooks which almost entirely run remotely and require an internet connection to function (or function with all features).

This was also a family gathering, so I didn't spend much time on the internet. I could quickly google the answer to win an argument and that was all I needed.

## Conclusion

Slow internet is still a pain, but I've grown to appreciate its limitations and work around them. Several trends in computing and content delivery in recent years have made slow internet more bearable. I won't be giving up my high-speed internet any time soon, but slowing down and disconnecting a bit is a nice change of pace in this time where everything has to happen online.
