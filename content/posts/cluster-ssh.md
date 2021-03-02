---
title: "Cluster SSH"
date: 2021-02-14T14:15:41-05:00
lastmod: 2021-03-02T17:47:13-05:00
description: "One of the most important parts of a working cluster is the interconnection and communication between nodes. While the networking side will not be covered now, a very important aspect will be: passwordless SSH."

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- SSH
- cluster
series:
- Raspberry Pi Cluster
categories:
- guide
- networks
image: post-cover-image/raspberry-pis.jpg
---

One of the most important parts of a working cluster is the interconnection and communication between nodes. While the networking side will not be covered now, a very important aspect will be: passwordless SSH.

### Inter-node SSH

The first task to getting easy access between nodes is ensuring SSH access between all the nodes.

While not necessary, I recommend adding all your nodes to the `/etc/hosts` file on each node. For example, the `/etc/hosts` file might look like

```
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```

to which I would add (using the actual IPs of the nodes)

```
192.168.0.11 node1
192.168.0.12 node2
192.168.0.13 node3
192.168.0.14 node4
```

{{< expand "Automate adding to your hosts files" >}}

```shell
for node in localhost node2 node3 node4; do
ssh $node "cat | sudo tee -a /etc/hosts > /dev/null" << EOF

192.168.0.11 node1
192.168.0.12 node2
192.168.0.13 node3
192.168.0.14 node4
EOF
done
```

{{< /expand >}}

After this is added to your hosts file on all your nodes, from any node you should be able to `ssh node1` from any of them successfully after entering your password.

{{< alert theme="info" >}}
**NOTE**: if you have not configured static IP addresses for your nodes, any changes to their IPs will require you changing the hosts file on all your nodes.
{{< /alert >}}

### Passwordless SSH

To be able to SSH between nodes without the need for a password, you will need to create an SSH key. This will allow SSH to work in scripts and tools (MPI) without needing user interaction.

<!-- put link to detailed SSH info from SoC guide once written -->

First, we need to create a key. There are multiple standards of encryption you can use for SSH keys. The default is [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem)), but it is generally considered to be [less secure than modern standards](https://nbeguier.medium.com/a-real-world-comparison-of-the-ssh-key-algorithms-b26b0b31bfd9). Therefore, these instructions will show how to create a ed25519 key. This will work on your cluster, but some (very) old systems may not support ED25519 keys (RSA keys will generally work everywhere even though they are less secure).

To create a key, use this command on one of your nodes:

```shell
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -C "Inter-node cluster ssh"
```

[This article](https://medium.com/risan/upgrade-your-ssh-key-to-ed25519-c6e8d60d3c54#eb8e) does a good job of breaking down what all the arguments are used for.

Next, we need our nodes to trust the key we just created. We'll start with getting the current node to trust the key.

```shell
ssh-copy-id -i ~/.ssh/id_ed25519 localhost
```

{{< alert theme="warning" >}}
**NOTE**: If you have already setup NFS with a shared home directory, you don't need to do anything further; the key is accessible and trusted on all the nodes.
{{< /alert >}}

Now we can just copy these files to all the other nodes so that they can use and will trust this key.

```shell
for node in node2 node3 node4; do # list all the nodes that should get the key
  ssh-copy-id -i ~/.ssh/id_ed25519 $node # you will need to enter your password for this step
  scp ~/.ssh/id_ed25519 $node:.ssh/
  ssh $node "chmod 600 ~/.ssh/id_ed25519" # ensure the key is locked down so SSH will accept it.
done
```

And to make all the nodes trust each other's fingerprints

```shell
for node in node2 node3 node4; do
  scp ~/.ssh/known_hosts $node:.ssh/
done
```

We can check that we can SSH into all the nodes without having to enter a password:

```shell
for node in node2 node3 node4; do
  ssh $node "hostname"
```
