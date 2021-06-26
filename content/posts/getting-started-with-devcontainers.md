---
title: "Getting Started With Devcontainers"
date: 2021-06-25T20:06:55Z
description: "Setting up and maintaining a development environment is hard, especially when you need to destructively test features or libraries."

draft: false
enableToc: true
hideToc: false
# enableTocContent: false
# tocFolding: false
# tocPosition: inner
# tocLevels: ["h2", "h3", "h4"]
tags:
- development
- containers
series:
- 
categories:
- 101
- guide
image: post-cover-image/vscode_remote-containers.png
---

Setting up and maintaining a development environment is hard, especially when you need to destructively test features or libraries. Especially for contributing to a new project, you don't know everything that is needed. Sometimes the install/development instructions assume some base tools or packages that are not included in your development environment of choice.

In come devcontainers. Rather than having to search through the README for a project you are wanting to contribute to, installing several packages onto your machine, and troubleshooting when it doesn't work, you can simply open the repository as a devcontainer and you are ready to start contributing. Have a project that requires several separate services (databases, middleware/api server, etc.)? Create a devcontainer using docker-compose and your development environment can launch an entire suit of containers exactly how you need them.

## Setup

### Install Docker

To be able to use containers, we need a container manager: Docker.

To get Docker installed, simply follow [their instructions](https://www.docker.com/get-started)

### Install VS Code

To get Visual Studio Code (VS Code) installed, simply follow [their instructions](https://code.visualstudio.com/download)

### Add container remote extension

<!-- TODO(jhollowe) add detailed information on how to install the extension -->

Within VS Code, install the [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

* Click the Extensions sidebar (or use the "Ctrl + Shift + X" shortcut)
* Search for `ms-vscode-remote.remote-containers`
* Click "Install"

## Test It Out

Now that you are ready to use a devcontainer, it is time to test it out!

You can grab this blog and use it as the devcontainer to play with. Click on the bottom left in VS Code on the green arrows, find the Container remote section, and select "Clone Repository in Container Volume...", enter `https://github.com/jhollowe/blog` and hit enter.

After a minute or so of downloading and building your development container, VS Code will be fully functional. You can use the included tasks (Terminal > Run Task... > Serve) to build and serve the blog. The devcontainer includes everything needed to build the blog and run VS Code. VS Code will even pull in common configuration for tools like Git and SSH.

## Modes

There are several "modes" of how to store your files in which you can use devcontainers, each with its own benefits and drawbacks.

| "mode"               | Pros                                                                                                                        | Cons                                                               |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| container volume     | * fast<br>* fully self-contained environment                                                                                | * hard to access files from outside container                      |
| mounting a directory | * easy to get files in and out<br>* allows statefull local files                                                            | * slow file I/O<br>* add/edits/deletes affect the source directory |
| cloning a directory  | * as fast as a container volume<br>* easy to get files into container<br>* edits/deletes do not affect the source directory | * hard to get files out of container                               |
