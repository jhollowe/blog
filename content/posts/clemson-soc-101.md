---
title: "Clemson SoC 101"
date: 2021-02-08T20:08:42-05:00
description: "Clemson's School of Computing can be complicated. Here are some tips and tricks to get started quickly and make the most of the resources you have."

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- clemson
series:
- Getting started in CS at Clemson
categories:
- 101
image:
---

Clemson's [School of Computing](https://www.clemson.edu/cecas/departments/computing/index.html) (SoC) is the place at Clemson where Computer Science (CPSC), Computer Information Systems (CIS), and Digital Production Arts (DPA) are located. Other computing departments (like Computer Engineering) also use some of the SoC's systems. Below are some useful tips and tools for quickly getting going in the SoC.

### Access Servers

The access servers are the way you can access all the SoC computers from off-campus (without having to use the VPN). You can SSH into them and then SSH into other computers through access (or anything else you can do through SSH). You can connect to the access servers using `ssh <clemson_username>@access.computing.clemson.edu` (or just `ssh access.computing.clemson.edu` if you computer's username matches your Clemson username). When you connect, you will see a list of lab computers that you can then connect to by using their name (e.g. `ssh babbage1`). You can also use `access2.computing.clemson.edu` if the main `access` server is down or overloaded.

If you are on campus, you can directly access the lab computers without the need to go through the access server. Simply use `ssh <computer_name>.computing.clemson.edu` while on campus (or VPN) and you can directly connect to the machine.

{{< alert theme="info" >}}
**NOTE**: There is a limit in place on the number of connections for each user connecting to the access server. I've found it to be 4 connections. If you need more connections, consider using both `access` and `access2` or using [SSH Multiplexing](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Multiplexing).
{{< /alert >}}

### Files on the lab computers

All the lab computers share your home directory. This means that if you write a file on one computer, you can access it on any other lab computer. This also means your settings for most programs will be the same on all the computers.

This also means you can access these files from your own computer as a network drive. Check out [these instructions]({{< ref "accessing-your-clemson-network-shares" >}}) for more information on the subject (use the linux share instructions).

### SSH between computers

SSHing between the lab machines can be a bit of a pain when you have to enter your password every time. It also makes it harder to write scripts that use multiple lab computers to work on rendering a project or running some processing. However, if you set up SSH keys on the computers, it allows the lab machines to connect to each other without the need for a password. And since the lab computers [share files](#files-on-the-lab-computers), once SSH keys are setup on one system, the will work on all the systems.
<!-- TODO: add link to normal SSH key guide -->

The process of making the keys we will use is fairly straight forward. You can check out [more information on what these commands do]({{< ref "cluster-ssh/#passwordless-ssh" >}}) if you are interested.

```shell
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/id_ed25519 -C "School of Computing"
ssh-copy-id -i ~/.ssh/id_ed25519 localhost
```

This will generate a key for the computers to use, and "install" it so they will accept connections from that key. Since all the computers have the needed files due to the shared filesystem, all the computers now trust connections from all the other computers.

### Snapshot folder

Oh no! You just deleted all the files for your assignment! Not to worry.

You home directory (/home/\<username\>/) on the SoC computers is backed up for just such a problem. Within every folder in your home directory is a hidden folder named `.snapshot`. It will not appear in any listing of directories, but if you `cd` into it, you can access all the different backups that are available. You can `ls ~/.snapshot/` to see all the different dates that are have backups (there are hourly, daily, and weekly backups). These backup files are read-only, so you will need to copy them back into your home directory to be able to edit them.

To access and recover your files, you can either do

```shell
cd ~
cd .snapshot/daily.1234-56-78_0010/path/to/your/files/
cp very-important-file.txt ~/path/to/your/files/
```

OR

```shell
cd ~/path/to/your/files/
cd .snapshot/daily.1234-56-78_0010
cp very-important-file.txt ~/path/to/your/files/
```

### Teachers' Office Hours

While is isn't really a technology in the SoC, your teachers are one of best resources to gain knowledge and software development skills. After all, the aren't called teachers for nothing.

All teachers are required to have office hours (and so are Teaching Assistants (TAs)). Make use of this time to get to know your teacher, ask questions, and learn more about topics that excite you. It is also a good idea to start projects early (I'm not saying I ever did this, but it is what I should have done) so you can ask the teacher questions in office hours before everyone else starts to cram the assignment and office hours get busy.

### YOUR SUGGESTION HERE

Is there something you really liked or have often used that you think I should add here or in another post? Get in contact with me and let me know!
