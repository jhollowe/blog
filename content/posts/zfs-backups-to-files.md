---
title: "ZFS Backups to Files"
date: 2021-07-10T19:51:43Z
description: "ZFS is a great filesystem which I use on most of my systems and it makes full-drive backups a breeze. However, sometimes I want to backup to a non-ZFS system. These are the steps I use for fast and verified backups to a file on another computer."

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- zfs
series:
- 
categories:
- guide
image:
---

ZFS is a great filesystem which I use on most of my systems and it makes full-drive backups a breeze when I am refreshing hardware in my homelab. However, sometimes I want to backup to a non-ZFS system. These are the steps I use for fast and verified backups to a file on another computer.

## Background

{{< alert theme="info" >}}If you already know about ZFS, snapshots, replication, and zStandard, feel free to skip this section.{{< /alert >}}
If you already know about ZFS, snapshots, replication, and zStandard, feel free to skip this section.

ZFS is a next-generation filesystem which supports a lot of great usability, data integrity, and performance features.
One of the most useful features are snapshots. Since ZFS is a copy-on-write (COW) filesystem, it can make a "copy" of an entire filesystem instantly as it just stores the current state and keeps blocks of data even if they later get updated/deleted. This is incredibly useful for backing up a system, as you can make a snapshot of the system instantly while it is running and then take the time to transfer the data.

ZFS can take a snapshot and `zfs send` the data in a stream that can be piped to a file, other commands, or a `zfs receive` on another host to load the datasets to that host's storage and make the files available on the live filesystem. Receiving to another system has many benefits, but one major problem is the destination requires a ZFS pool mounted that has enough unused storage to receive all the incoming data. Sometimes this is not feasible, or even if the destination has a working pool it is not desired to mix in another filesystem with the existing data. In this case, sending to a file will store the entire send stream which can later `cat`'d back to a `afs receive` whenever desired.

One other tool used in this guide is zStandard. This is a newer compression library with great compression ratios while maintaining fairly high compression speed and incredibly fast decompression speed. I love zStandard and try to use it in everything. It has also had a large adoption increase in the last year or so with many other projects including zStandard compression support ([ZFS](https://github.com/openzfs/zfs/commit/10b3c7f5e424f54b3ba82dbf1600d866e64ec0a0), [btrfs](https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git/commit/?h=next&id=5c1aab1dd5445ed8bdcdbb575abc1b0d7ee5b2e7), [tor](https://blog.torproject.org/blog/tor-0312-alpha-out-notes-about-0311-alpha), and [Rsync](https://download.samba.org/pub/rsync/NEWS#3.2.0) to name a few).

## Setup

There are two hosts: one using ZFS which will be backed up, and one host which will store the backup. This destination host only needs enough storage space to store the (compressed) send stream.

### Making a Snapshot

### Determining the Size of the Send

### Setting Up The Destination
start netcat if local

## #fullsend

Now that everything is prepared, we can actually send the data to the destination. We'll start with the most basic form and add on some extra commands to add speed and metrics of the status of the send.

### Basic Send

Getting bits from A to B is pretty easy.
