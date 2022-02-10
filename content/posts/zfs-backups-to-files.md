---
title: "ZFS Backups to Files"
date: 2021-08-11T05:02:34Z
description: "ZFS is a great filesystem which I use on most of my systems and it makes full-drive backups a breeze. However, sometimes I want to backup to a non-ZFS system. These are the steps I use for fast and verified backups to a file on another computer."

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- ZFS
- backup
- sysadmin
series:
- 
categories:
- guide
image:
---
<!-- spell-checker:ignore btrfs netcat subdataset fullsend zstreamdump  -->

ZFS is a great filesystem that I use on most of my systems and it makes full-drive backups a breeze when I am refreshing hardware in my homelab. However, sometimes I want to backup to a non-ZFS system. These are the steps I use for fast and verified backups to a file on another computer.

[TL;DR](#putting-it-all-together): Combine the power of ZFS, zStandard, pv, and netcat to have a fast backup of a ZFS snapshot with verbose metrics of the process and progress.

## Background

{{< alert theme="info" >}}If you already know about ZFS, snapshots, replication, and zStandard, feel free to skip this section.{{< /alert >}}

ZFS is a next-generation filesystem which supports a lot of great usability, data integrity, and performance features.
One of the most useful features are snapshots. Since ZFS is a copy-on-write (COW) filesystem, it can make a "copy" of an entire filesystem instantly as it just stores the current state and keeps blocks of data even if they later get updated/deleted. This is incredibly useful for backing up a system, as you can make a snapshot of the system instantly while it is running and then take the time to transfer the data.

ZFS can take a snapshot and `zfs send` the data in a stream that can be piped to a file, other commands, or a `zfs receive` on another host to load the datasets to that host's storage and make the files available on the live filesystem. Receiving to another system has many benefits, but one major problem is the destination requires a ZFS pool mounted that has enough unused storage to receive all the incoming data. Sometimes this is not feasible, or even if the destination has a working pool it is not desired to mix in another filesystem with the existing data. In this case, sending to a file will store the entire send stream that can later be `cat`'d back to a `zfs receive` whenever desired.

One other tool used in this guide is zStandard. This is a newer compression library with great compression ratios while maintaining fairly high compression speed and incredibly fast decompression speed. I love zStandard and try to use it in everything. It has also had a large adoption increase in the last year or so with many other projects including zStandard compression support ([ZFS](https://github.com/openzfs/zfs/commit/10b3c7f5e424f54b3ba82dbf1600d866e64ec0a0), [btrfs](https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git/commit/?h=next&id=5c1aab1dd5445ed8bdcdbb575abc1b0d7ee5b2e7), [tor](https://blog.torproject.org/blog/tor-0312-alpha-out-notes-about-0311-alpha), and [Rsync](https://download.samba.org/pub/rsync/NEWS#3.2.0) to name a few).

## Setup

There are two hosts: one using ZFS which will be backed up (src.example.com), and one host which will store the backup (dest.example.com). This destination host only needs enough storage space to store the (compressed) send stream.

{{< alert theme="info" >}}All code is run on src.example.com unless otherwise noted.{{< /alert >}}

### Making a Snapshot

ZFS send streams only work on snapshots, so we need to create a snapshot of the current files and data to be able to send it. If you already have a up-to-date snapshot (maybe from [automation](https://github.com/jimsalterjrs/sanoid)), you can just uses that snapshot.

To create a snapshot, you either need to be root (run the following command with `sudo`), or have the snapshot ZFS permissions on the dataset. As we will be creating a recursive snapshot of all datasets, it is easier to just run commands as root.

The format of the snapshot command is  
`zfs snap[shot] pool/datasetA/subdataset/thing1@snapshot-name`.  
To snapshot the "testing" dataset on my "tank" pool with the snapshot name "backup_2021-01-02_0304", I would use either command

```shell
zfs snap tank/testing@backup_2021-01-02_0304
zfs snapshot tank/testing@backup_2021-01-02_0304
```

To backup an entire pool, use `zfs snap -r tank@full_backup` which will recursively (`-r`) snapshot the given dataset and all datasets below it.

### Determining the Size of the Send

Now that we have our snapshot, it would be nice to know how much data we will be sending and storing for our backup. We can either get a (fairly accurate) estimate of the size of the send (quick) or get the exact size of the send. Unless you really need to know the exact size of the send, I recommend the fast method

#### Fast Size

We can get an estimate of the size of a send by running the send with the dry-run flag (`-n`) in verbose mode (`-v`).

```shell
zfs send -R -n -v tank@full_backup
```

The last line should tell you the estimate of the size of the send.

#### Slow Size

If you really need the exact size of the send, you can use `wc` to get the total bytes being sent.

```shell
zfs send -R tank@full_backup | wc -c
```

If you want to see the speed that zfs can read the send data off your storage, you can use `pv` (you might need to install it) to see the size and speed.

```shell
zfs send -R tank@full-backup | pv > /dev/null
```

## #fullsend

Now that everything is prepared, we can actually send the data to the destination. We'll start with the most basic form and add on some extra commands to add speed and metrics of the status of the send.

In the following examples, the `zfs send` command is used with the `-R` flag. This makes an "replication" send stream which can fully recreate the given snapshot from nothing. You can omit it if that is not the functionality you need.

> -R, --replicate
> Generate a replication stream package, which will replicate the specified file system, and all descendent file systems, up to the named snapshot. When received, all properties, snapshots, descendent file systems, and clones are preserved. [^1]

### Basic Send

Getting bits from A to B is pretty easy. We can use SSH to send the data to the destination host and save it as a file[^2].

```shell
zfs send -R tank@full-backup | ssh dest.example.com "cat > /path/to/saved/file.zfsnap"
```

We can use the size we found earlier to get a rough progress bar. `pv` can take in the size of the stream and use it to determine an ETA and progress. It can take integer values with units of "k", "m", "g", and "t"[^3].

Assuming we have 24860300556 bytes (23.2GiB), we could use either of the following

```shell
zfs send -R tank@full-backup | pv -s 24860300556 | ssh dest.example.com "cat > /path/to/saved/file.zfsnap"
zfs send -R tank@full-backup | pv -s 24G | ssh dest.example.com "cat > /path/to/saved/file.zfsnap"
```

If you have ZFS installed on the destination, you can check validate the send stream using `zstreamdump`[^4].

```shell
# on dest.example.com
cat /path/to/saved/file.zfsnap | zstreamdump
```

While this works and is super reliable, it is inefficient in its data storage size and transport cost. The send stream is uncompressed on your destination and SSH can use significant CPU on low-power devices.
The next two solutions seek to solve these problems.

### Compression

As long as you are not sending a raw or encrypted snapshot, there will be some amount of compressible data in the send stream. We can compress the send stream so it is (a bit) smaller on the destination's storage.
You can compress on either the source or the destination, however compressing on the source means less data is transmitted over the network which usually is slower than the CPU needed for compression.

We'll use zStandard due to its speed, compression ratio, and adaptable compression level.

Basic Usage

```shell
zfs send -R tank@full-backup | zstd -c | ssh dest.example.com "cat > /path/to/saved/file.zfsnap"
```

ZStandard can also use an adaptive compression level. This means that if the network is slow and the compressor would otherwise be idle, it can increase the compression level and can also reduce the level if the network speeds up. This does mean that it can be a low compression ratio, but if reduced storage space is desired, the stream can be recompressed (e.g. `zstd -d /path/to/saved/file.zfsnap.zst | zstd -T0 -19 /path/to/saved/file_smaller.zfsnap.zst`). The minimum and maximum levels for the adaption can be set, but using just `--adapt` defaults to sane defaults (3 to 15).

It can also use multiple threads to fully utilize all the cores in the host. The number of threads can be specified or set to 0 to use the same number of threads as cores (`-T0`)[^5]. It has a verbose mode (`-v`) as well which gives insight to the compression level and compression ratio of the stream.

```shell
zfs send -R tank@full-backup | zstd -c -v -T0 --adapt=min=1,max=19 | ssh dest.example.com "cat > /path/to/saved/file.zfsnap.zst"
```

`pv` can also be used to give progress and speed calculations (however, it seems that the verbose output of `zstd` conflicts with `pv`):

```shell
zfs send -R tank@full-backup | pv -cN raw -s 24G | zstd -c -T0 --adapt=min=1,max=19 | pv -cN compressed | ssh dest.example.com "cat > /path/to/saved/file.zfsnap.zst"
```

### Local Send

{{< alert theme="warning" >}}Only use the following across a network you trust (not the internet). This method sends data unencrypted.{{< /alert >}}

SSH takes a lot of processing power to encrypt data when sending large amounts of data through it. If we are on a secure network where we can sacrifice encryption for speed, we can use netcat instead of ssh.

However, there is not server on the destination (unlike the SSH daemon), so we need to start a netcat server on the destination to listen (`-l`) for connections on a port (12345) and have it redirecting to the destination file (with `pv` showing us stats on the receiving side).

```shell
# on dest.example.com
nc -l 12345 | pv > /path/to/saved/file.zfsnap
```

Now we can send it data to save to the file

```shell
zfs send -R tank@full-backup | pv -s 24G | nc dest.example.com 12345
```

## Putting it all together

```shell
# on dest.example.com
nc -l 12345 | pv > /path/to/saved/file.zfsnap.zst
```

```shell
# on src.example.com
snapName='tank@full-backup'
zfs snap -r ${snapName}
sendSize=$(zfs send -v --dryrun -R ${snapName} | grep "total estimated" | sed -r 's@total estimated size is ([0-9\.]+)(.).*@\1\n\2@' | xargs printf "%.0f%s")

zfs send -R ${snapName} | pv -cN raw -s ${sendSize} | zstd -c -T0 --adapt=min=1,max=19 | pv -cN compressed | nc dest.example.com 12345
```

<!-- markdownlint-disable MD034 -->
[^1]: https://openzfs.github.io/openzfs-docs/man/8/zfs-send.8.html
[^2]: As far as I know, the `.zfsnap` is not an official or commonly used extension. However, it helps me know what the file is, so I've used it here. Use whatever file name and extension you want.
[^3]: https://linux.die.net/man/1/pv
[^4]: https://linux.die.net/man/8/zstreamdump
[^5]: The documentation for zStandard notes that using the `-T` flag with `--adapt` can cause the level to get stuck low. If you have problems with the compression level getting stuck at a low value, try removing the threads flag.
<!-- markdownlint-enable MD034 -->
