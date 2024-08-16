---
layout: post
title: "Setup Devcontainer in VSCode Flatpak with Podman"
date: 2024-08-15 04:45 +0600
description: "Set up a Devcontainer in VSCode using Flatpak and Podman for a seamless development experience."
categories:
- linux
tags:
- vscode
- docker
- podman
- flatpak
---

Want to use DevContainers with VS Code Flatpak and Podman?
 It's not as straightforward as it sounds. Flatpak's sandboxing and Podman's socket access pose challenges. This post will guide you through the hurdles, offering solutions and workarounds to get your DevContainer up and running smoothly. We'll cover essential configurations, troubleshooting tips, and best practices to make your development experience as painless as possible.

Prerequisites: `podman`, `flatpak`

- Install flatpak vscode and podman
```sh
flatpak install --user -y \
  com.visualstudio.code \
  com.visualstudio.code.tool.podman
```
- Start podman socket
```sh
systemctl --user enable --now podman.socket && \
systemctl --user status podman.socket
```
- We need to override some vscode flatpak settings
```sh
flatpak override --user \
  --filesystem=xdg-run/podman:ro \
  --filesystem=/run/user/$UID/podman/podman.sock:ro \
  --filesystem=/tmp:rw \
  com.visualstudio.code
```
- Test podman socket connection
```sh
curl -w "\n" \
  -H "Content-Type: application/json" \
  --unix-socket /run/user/$UID/podman/podman.sock \
  http://localhost/_ping
```
You should see OK if everything is alright.
- install [devcontainers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
```sh
flatpak run --user --command=sh com.visualstudio.code -c \
  "/app/extra/vscode/bin/code --install-extension ms-vscode-remote.remote-containers"
```
- We need to replace docker with podman (podman-remote that connect with host podman). We can do that by opening vscode and go to user setting `ctrl + ,`. and search for `dev.containers.dockerPath` change the setting from `docker` to `/app/tools/podman/bin/podman/podman-remote`
Or from terminal
```sh
mkdir -p ~/.var/app/com.visualstudio.code/config/Code/User
nano ~/.var/app/com.visualstudio.code/config/Code/User/settings.json
```
and put the setting
```json
{
    "dev.containers.dockerPath": "/app/tools/podman/bin/podman-remote"
}
```
- Test if vscode flatpak is connected and working with podman (optional)
```sh
flatpak run --user --command=sh com.visualstudio.code
/app/tools/podman/bin/podman-remote version
/app/tools/podman/bin/podman-remote run --rm hello-world
```