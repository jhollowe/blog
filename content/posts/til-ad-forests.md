---
title: "TIL: AD Forests"
date: 2021-06-08T06:10:52Z
description: "Today I Learned about Active Directory Forests"

draft: false
enableToc: false
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- Active Directory
series:
- TIL
categories:
- 
image: post-cover-image/ad_forest.png
---

For environments with complex Active Directory (AD) environments, AD forests can allow flexibility in management and organization of objects.

Basically, an AD forest allows multiple domains and trees of domains (subdomains) to access and have a shared configuration while still having separate domains with separate host servers.
They allow domains to trust and access each other while still maintain separations and boarders. I've seen this used to allow corporate and client domains to communicate or to have a development domain tree that trust and can cross-talk with the production domain tree while still being separate (this is less common as dev domains are usually just subdomains within the production tree).

Resources

* <https://en.wikipedia.org/wiki/Active_Directory#Forests,_trees,_and_domains>
* <https://ipwithease.com/what-is-a-forest-in-active-directory/>
* <https://www.varonis.com/blog/active-directory-forest/>
