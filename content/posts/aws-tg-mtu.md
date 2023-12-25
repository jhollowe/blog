---
title: "Unraveling the Mystery of NFS Hangs, or How The (Hybrid) Cloud is a Pain"
date: 2023-12-24T01:32:12Z
description: A simple issue at work with cloud hosts not being able to access an NFS mount on-prem turn into a multi-month bug hunt which ended with finding a low MTU network path and an AWS "feature" (pronounced bug)

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- cloud
- AWS
- networks
categories:
- work
- story time
image:
---
<!-- spell-checker:ignore Wireshark triaging -->

## The Tale Begins

There I was, triaging a new issue that came in. A Linux VM running in the cloud was hanging when we started trying to run our workload on it. Huh, there was no output at all from the python script; it didn't even create its log file, one of the first things it should do. Logging into the cloud instance, I looked around and noticed there was a python process running for the script we started, so the connection to the host and creating the python process at least worked. Well, since it didn't work the first time, I killed the process and tried running the same command manually to see if there was an issue with the setup of the process. Aaaannnndddd it hung. But it doesn't hang with the exact same NFS mount and AMI (root disk image) in a different cloud account we use.

Well, this is interesting. Okay, let's just look at the script we are running. Hung. Welp, I guess it is time for the good old turn-it-off-and-on-again fix. Now let's look at the script. That seems fine. Let's look at the python executable binary we are running. Hung. Uh, okay. Let's check the script again. Hung. Well it looks like an NFS issue. Wireshark Time!

After a bunch of test reads and write to the NFS mount with Wireshark slurping up packets, it looks like the client sends out read requests and the server never responds. The TCP connection retransmits the un-ACK'd packets until the TCP session times out, sends a RST, and sends the read request again.

After inspecting the traffic in the AWS flow logs and in the cloud-to-on-prem firewall, it seems that all the traffic is correctly making it from the cloud client to the on-prem NFS server. So, what do we do now?

After a bunch of additional tests, I ran a test of incrementally increasing the size of a file being written one byte at a time. The writes started to fail around 1300 bytes. Looking at the traffic in Wireshark, these write requests approached 1500 bytes. While both the server and client were using jumbo frames (9000 MTU), it is possible there is a 1500 MTU link somewhere between these two hosts.

## Discovering the Path to a Fix

Collaborating with our cloud operations team, we confirmed that the Direct Connect between the cloud and on-prem did have a 1500 MTU. However, this did not explain why the client/server could not use the standard [Path MTU Discovery (PMTUD)](https://erg.abdn.ac.uk/users/gorry/course/inet-pages/pmtud.html) to detect the smaller link and reduce the effective MTU to the lowest MTU along the path.

PMTUD activates when a frame which is too large for a link is sent with the Don't Fragment (DF) flag set. When network gear receives a frame too large for the MTU of the next hop, it will either fragment the packet or if the DF flag is set, return an ICMP error "Fragmentation Needed and Don't Fragment was Set" packet to the sender and drop the packet. Testing in the other AWS account, this worked correctly and the TCP session downgraded to a 1500 MTU (technically the MSS was reduced to 1500 not the MTU, but that is a whole other topic). However for some reason in the original account, the session did not reduce to 1500. Comparing a packet capture from both accounts, I noticed that there was no ICMP error response in the broken account.

## AWSucks

After much back-and-forth with our cloud ops team, we found that in the broken account there was an additional layer on top of the Direct Connect. The [AWS Transit Gateway](https://docs.aws.amazon.com/directconnect/latest/UserGuide/set-jumbo-frames-vif.html) not only has a maximum MTU of 8500, but also does NOT return an ICMP "fragmentation but DF" error. So the client or server sends a packet larger than the MTU of the Transit Gateway, the TG drops the packet without informing the sender of why the packet is being dropped, and the sender continues to retransmit the packet for which it has not received an ACK thinking it was just randomly dropped.

## Finding Another Way

So PMTUD won't work; great. And we can't reduce the client's MTU to 1500 as there are workloads running on it which must have jumbo frames. Thus began a flurry of research resulting in me learning of Linux's [Packet-Later PMTUD](http://www.ietf.org/rfc/rfc4821.txt). Using the `net.ipv4.tcp_mtu_probing` kernel tunable, we can enable an MTU (really MSS) size discovery for TCP sessions.

### How It Works

When the sender sends a packet which is too large for a link in the path of an active TCP connection, the too-large packet will be dropped by the network and the sender will not receive an ACK from the receiver for that packet. The sender will then retransmit the data on an exponential backoff until the maximum retransit count is reached. The sender will then send a RST and try a new TCP session (which if tried with the same size packet will just continue to repeat). 

The `tcp_mtu_probing` functionality takes over once the standard TCP retransmit limit is reached. With `tcp_mtu_probing` enabled, the kernel's network stack splits the offending packet into `net.ipv4.tcp_base_mss` sized packets and sends those packets instead of the too-large packet. For further packets, the network stack will attempt to double the current packet limit until it again fails to ACK the packet. It then uses this new largest packet size for all future packets for the TCP session. Linux 4.1 improves on this functionality by using a binary search instead of multiple doubling of the MSS. The initial reduced packet size starts at `tcp_base_mss` and then binary searches for the largest functioning MSS between the `tcp_base_mss` and the MTU of the interface passing the traffic.

A great article digging deeper into this is [Linux and the strange case of the TCP black holes](https://xn--tigreray-i1a.org/en/post/2015/10/11/linux-and-the-strange-case-of-the-tcp-black-holes/)

## Conclusion

While the ideal solution would have been for AWS to fix their broken, non-compliant network infrastructure, it is unlikely they will ever fix this. Using a solution which is built into the Linux kernel which allows the continued use of Jumbo frames for cloud-local traffic which preventing traffic over the Transit Gateway from breaking due to large packets.
