---
title: "NVMe Boot in Proxmox on R510 BIOS"
date: 2022-12-27T18:54:12Z
description: My process of finding the best way to boot Proxmox off an NVMe drive in an old Dell R510

draft: false
enableToc: true
hideToc: false
tags:
- sysadmin
- proxmox
image:
---
<!-- spell-checker:ignore bootloader hackintoshes UEFI gparted cmdline -->

{{< notice info "Outdated" >}} While this information is still relevant, more complete information on this topic can be found on [Booting from NVMe on older BIOSes](../nvme-proxmox-boot)
{{< /notice >}}

---

Trying to boot off an NVMe drive on older hardware can cause some issues. If you are running an older BIOS/UEFI, it may not have the needed drivers to understand how to talk to a NVMe drive. I ran into this exact issue when trying to boot my Dell R510 from an NVMe drive.

To boot from NVMe, I would need to use some shim which *could* be booted by the BIOS which would chain-boot the actual OS on the NVMe.

## Attempt 1 - Clover

The first method I attempted to used was the [Clover Bootloader](https://github.com/CloverHackyColor/CloverBootloader). Clover, while primarily used for Hackintoshes, can have NVMe support added and chain boot to another disk. I wanted to try this first as I would prefer an OS-indifferent solution that would continue to work no matter what I installed on the NVMe.

I attempted to image Clover onto a USB drive and after several wrong attempts, I finally formatted the USB as fat32 and just copy/pasted the contents to the drive. I then followed instructions I found to enable NVMe compatibility by copying `NvmExpressDxe.efi` from `EFI/CLOVER/drivers/off` into `EFI/CLOVER/drivers/BIOS/` and `EFI/CLOVER/drivers/UEFI/`. I then modified the `EFI/CLOVER/config.plist` file to automatically boot the the NVMe drive after a 5 second pause.

However, I could never get Clover to read this config.plist file. I tried placing it in other paths that were suggested by comments on the internet. I tried reverting to the original file and modifying one small value to ensure I had not messed up the file formatting. Still, I could not get Clover to read the config file and automatically boot from the NVMe drive. It would just remain at the boot selection menu where I could manually select the NVMe to boot from which would then work perfectly.

## Attempt 2 - Proxmox Boot

Proxmox comes with the `proxmox-boot-tool` tool which is used to synchronize all the boot disks with the UEFI (ESP) partition. After giving up on Clover, I looked into `proxmox-boot-tool` and found I could just place an extra ESP partition on the USB drive and let `proxmox-boot-tool` keep it up-to-date and synced.

Rather than creating the correct partitions in the correct locations and of the right size, I just did a `dd if=/dev/<root pool> of=/dev/<usb drive> bs=1M count=1024` to copy over the first 1 GB of the disk. I then used `gparted` to delete the main partition (leaving the BIO and ESP partitions) and to give the remaining partitions new UUIDs. I then booted into Proxmox and `proxmox-boot-tool format /dev/disk/by-uuid/<USB ESP partition UUID> --force` and `proxmox-boot-tool init /dev/disk/by-uuid/<USB ESP partition UUID>`. Once that finished, I rebooted and the USB drive was used as the boot drive which booted into the main Proxmox OS.

## Conclusion

I've had this in place for a few months now and it has worked perfectly through several updates to the boot cmdline options and kernel updates.
