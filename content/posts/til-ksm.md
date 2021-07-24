---
title: "TIL: Kernel Same-page Merging (KSM)"
date: 2021-07-24T00:39:18Z
description: "Today I Learned about Kernel Same-page Merging (KSM)"

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- Linux
- memory
series:
- TIL
categories:
- 
image:
---

I first noticed Kernel Same-page Merging (KSM) while working with Virtual Machines (VMs) under KVM (in Proxmox VE).

KSM is a way of reducing physical memory usage by using one physical page of memory for all duplicate copied of that page. It does this by periodically scanning through memory, finding duplicate pages, and de-duplicating them via virtual memory. It is an extension of how the kernel shares pages between `fork()`'ed processes and uses many of the same methods of sharing memory. KSM is most often used with virtualization to de-duplicate memory used by guest Operating Systems (OSs), but can be used for any page of memory which the program registers with KSM to scan. "Red Hat found that thanks to KSM, KVM can run as many as 52 Windows XP VMs with 1 GB of RAM each on a server with just 16 GB of RAM."[^1]

### Virtual Memory Background

To fully understand how KSM works, a (at least) basic understanding of how virtual memory work is required.

To prevent programs from having to know where every other process on the computer is using memory, the kernel (the all-powerful dictator of the OS) tells each process it has memory starting at address 0. It then keeps a record of where in actual (physical) memory each block (page) or the virtual memory is located.
It uses this mapping to translate memory addresses each time the process reads or writes to memory.

{{< imgRel src="how_virtual_memory_works.jpg" attr="© Computer History Museum" attrlink="how_virtual_memory_works.jpg" width="75%" alt="virtual memory can point to any physical memory page or to storage" >}}

This virtual memory also allows things like memory-mapped files on disk and Copy-On-Write (COW) pages. When a process clones (forks) itself, it doesn't have to make a copy of all the memory it was using. It simply marks each page as COW. Each process can read from their memory with both virtual addresses pointing to the same physical page (now marked COW), but when either attempts to write to memory, the existing physical page is left inn place (so the other process can still use it) and a new physical page is allocated and mapped to the writer's virtual memory. This allows pages of memory that are not changed in forked processes to use no additional memory.

the same process is used by KSM: it finds duplicate pages in the memory ranges registered with it, marks one of the physical pages as COW, and frees the other physical pages after mapping all the virtual pages to the one physical page.


[^1]: https://kernelnewbies.org/Linux_2_6_32#Kernel_Samepage_Merging_.28memory_deduplication.29
