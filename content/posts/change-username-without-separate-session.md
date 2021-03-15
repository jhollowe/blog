---
title: "Change Username Without Separate Session"
date: 2021-03-14T18:51:50-04:00
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
series:
- 
categories:
- 
image:
---

Changing a user's username on Linux requires no processes be running under that user. This makes sense, but what if we only have that user accessible through a SSh connection. What if we don't want to allow external access to the root account? What if the root account doesn't have a password?

## Background

I was recently spinning up a bunch of Raspberry Pis running Ubuntu 20.04 and some VPSes also running Ubuntu 20.04. I wanted to change the username on these nodes, but only really had access to the `ubuntu` (sudo) account. While I know I could use a [cloud-init](https://cloudinit.readthedocs.io/en/latest/) file to create a user exactly how I want (more on that in a future post), I didn't want to re-flash the nodes and was not able to add a cloud-init file before boot on the VPSes.

## The Process

### Getting The Commands To Run

So we can't change the username of a user with running processes, but a SSH session and a bash shell both run under my user whenever I'm connected.

The main problem is executing a command from a user (and sudo-ing to root) while not having that user have a process running.

Using either of the commands below allows a command to be run as the root user which will continue running 

```shell
# interactive shell
sudo tmux

# non-interactive command
sudo -s -- sh -c "nohup <command> &"
```

Now that we can have a command running as root independent of the initiating user, we need to kill everything of the user so we can run usermod commands without difficulty. We kill the processes and wait a couple seconds for them all to terminate. Then we can run whatever commands we need.

```shell
ps -o pid= -u <current_username> | xargs kill && sleep 2 && <command>
```

{{< expand "What This Command Does">}}

* `ps` lists the processes running on the system
  * `-o pid=` selects only the process ID (pid) and does not create a header for the column (`=`)
  * `-u <username>` selects only the processes running under `<username>`
* `|` takes the output of the previous command (`ps`) and makes it the input of the following command (`xargs`)
* `xargs` takes a line separated list (can change the separator) and turns them into arguments for the following command
* `kill` takes a pid (or list of pids) and kills the process. While `kill` can send different signals to processes, this uses the default signal (TERM).
* `&&` runs the following command if the preceding command exited successfully (exit code 0)
* `sleep 2` wait 2 seconds for the killed processes to terminate

{{< /expand >}}

Now, we can get to actually changing the username!

### Changing The Username

Now that we can run commands as root without our user running processes, we can proceed to change the username and other related tasks.
These commands assume you are running as root. If not, you may need to insert some `sudo``s as necessary

```shell
# change the user's username
usermod -l <new_username> <current_username>
# move the user's home directory
usermod -d /home/<new_username> -m <new_username>
# change user's group name
groupmod -n <new_username> <current_username>
# replace username in all sudoers files
sed -i.bak 's/<current_username>/<new_username>/g' /etc/sudoers
for f in /etc/sudoers.d/*; do
  sed -i.bak 's/<current_username>/<new_username>/g' $f
done
```

## Putting it all together

When we put it all together (with some supporting script), we get [change-username.sh]({{< urlRel "change-username.sh" >}}) as seen below:

{{% include-code lang="shell" file="change-username.sh" %}}
