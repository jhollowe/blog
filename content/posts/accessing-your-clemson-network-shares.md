---
title: "Accessing Your Clemson Network Shares"
date: 2021-02-07T14:08:51-05:00
description:

draft: false
enableToc: false
hideToc: true
series:
- Getting started in CS at Clemson
categories:
- clemson
---

Clemson University’s computer labs store files across all the computers using network shares. You usually just access these shares on the lab machines, but you can also add the shares on your own computer as a network drive.

There are two main shares on campus: the campus share used by all the Windows (and Mac?) lab machines (e.g. in Cooper Library, Martin, etc.) and the School of Computing’s Linux systems. Both systems can be accessed in a similar way, but with different settings.

{{< notice info "VPN Required" >}}
To access these network shares, you must either be on campus internet (WiFi or Ethernet) or have the Clemson VPN installed and activated on your device. See the [CCIT guide for VPN access]( https://ccit.clemson.edu/services/network-phones-cable/network/vpn/
) for more information.
{{< /notice >}}

The following instructions assume you are using a Windows device to access the shares. Using the credentials as below, you can follow a guide for adding network drives on [Mac OS X]( https://it.cornell.edu/computer-recommendations/how-map-drive-mac-os-x
) or [Linux (Ubuntu)]( https://confluence.uconn.edu/ikb/file-storage/enterprise-file-services/mapping-a-network-drive-on-linux#MappingaNetworkDriveonLinux-GraphicalOption(UbuntuDesktop))

## Steps

1. Open File Explorer and go to "This PC". {{< imgRel src="this_pc.png" alt="Windows File Explorer \"This PC\" screen" width="50%" >}}
2. Click "Map Network Drive" in the top ribbon.
3. Choose what drive letter you want the share to appear as (it doesn’t matter what you choose for this; I used "Z" for this example)

{{< tabs "Linux Share" "Windows Share" >}}
  {{< tab >}}
  4. Enter `\\neon.cs.clemson.edu\home` into the "folder" box. {{< imgRel src="neon_mapping.png" alt="Adding the Linux share as a network drive" >}}
  5. Check both "Reconnect as sign-in" and "Connect using different credentials" so the network drive will automatically connect and you can use your Clemson credentials (rather than your local device’s username and password). Click "Finish".
  6. Enter your University username (with @clemson.edu) and password. (You might have to click "more choices" in the login window to be able to enter a new username/password.)
  {{< imgRel src="neon_creds.png" alt="example login credentials for neon.cs.clemson.edu">}}
  7. Click "OK". Your School of Computing home directory should now appear under the drive letter you chose.

  {{< alert theme="info" >}}
  **NOTE**: When adding new files via the network share, they are created with permissions defined by your `umask`. You can use `chmod xxx <file>` to change a files permissions to `xxx` (view a [chomod guide](https://www.computerhope.com/unix/uchmod.htm) for more information on the chmod command)
  {{< /alert >}}
  {{</ tab >}}

  {{< tab >}}
  4. Enter `\\home.clemson.edu\<username>` where `<username>` is your university username. {{< imgRel src="home_mapping.png" alt="Adding the Windows share as a network drive" >}}
  5. Check both "Reconnect as sign-in" and "Connect using different credentials" so the network drive will automatically connect and you can use your Clemson credentials (rather than your local device’s username and password). Click "Finish".
  6. Enter your University username (without @clemson.edu) and password. (You might have to click "more choices" in the login window to be able to enter a new username/password.)
  {{< imgRel src="home_creds.png" alt="example login credentials for home.clemson.edu">}}
  7. Click "OK". Your Windows home directory should now appear under the drive letter you chose.
  {{</ tab >}}

{{</tabs>}}

You now have access to your files as if they were just another drive in your computer. Do note that these drives will be significantly slower than your actual computer drives due to higher latency and lower bandwidth.
