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

> vscode + flatpak + devcontainer + podman
{: .prompt-tip }



Want to use DevContainers with VS Code Flatpak and Podman?
 It's not as straightforward as it sounds. Flatpak's sandboxing and Podman's socket access pose challenges. This post will guide you through the hurdles, offering solutions and workarounds to get your DevContainer up and running smoothly. We'll cover essential configurations, troubleshooting tips, and best practices to make your development experience as painless as possible.

Prerequisites: `podman`, `flatpak`

- Install flatpak vscode and podman
```sh
flatpak install -y flathub \
    com.visualstudio.code//stable \
    com.visualstudio.code.tool.podman//stable
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
flatpak run --command=sh com.visualstudio.code -c \
  "/app/extra/vscode/bin/code --install-extension ms-vscode-remote.remote-containers"
```
- We need to replace docker with podman (podman-remote that connect with host podman). We can do that by opening vscode and go to user setting `ctrl + ,`. and search for `dev.containers.dockerPath` change the setting from `docker` to `/app/tools/podman/bin/podman/podman-remote`. And search for `dev.containers.dockerSocketPath` change it to `/run/user/$UID/podman/podman.sock`. Replace `$UID` with yours.

To open and edit this file with your favorite text editor (e.g., code, micro, vim, or gedit):
Or from terminal
```sh
mkdir -p ~/.var/app/com.visualstudio.code/config/Code/User
nano ~/.var/app/com.visualstudio.code/config/Code/User/settings.json
```
and put the setting
```json
{
    "dev.containers.dockerPath": "/app/tools/podman/bin/podman-remote",
    "dev.containers.dockerSocketPath": "/run/user/$UID/podman/podman.sock"
}
```
> replace `$UID` with yours. Find with `id -u`  


- Test if vscode flatpak is connected and working with podman (optional)
```sh
flatpak run --command=sh com.visualstudio.code -c \
  "/app/tools/podman/bin/podman-remote version"
```



Check out [How I Built a Dev Container Workflow with Flatpak VSCode, Devcontainer and Podman on Wayland]({% post_url 2025-05-04-setup-flatpak-vscode-devcontainer-podman-wayland-gui %}) for more about Vscode devcontainer running gui.
