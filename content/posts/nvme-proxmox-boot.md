---
title: "Booting from NVMe on older BIOSes"
date: 2023-08-05T17:29:01Z
description:

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- sysadmin
- proxmox
series:
- 
categories:
- technology
image:
---

I recently had to replace a server and chose to add an old Dell workstation to my homelab. I previously covered this topic with my R510 in [NVMe Boot in Proxmox on R510 BIOS](../nvme-proxmox-r510-bios), but since I had to do it again from scratch, this post will get into the fine details of the process and setup.

## Initial Proxmox install

To start with, install Proxmox Virtual Environment (PVE) like normal on the NVMe drive. I use [Ventoy](https://www.ventoy.net/en/download.html) to have my installers in one easy-to-use flash drive. When booting into the installer (or Ventoy if you are using the installer), make sure you boot it as UEFI so it will install PVE to boot as UEFI. I run PVE on a ZFS install, so I selected my NVMe drive for a single-drive pool (ZRAID0 in the installer GUI).
