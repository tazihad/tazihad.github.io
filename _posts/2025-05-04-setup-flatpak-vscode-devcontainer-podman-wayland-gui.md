---
title: How I Built a Dev Container Workflow for GUI development with Flatpak VSCode, Devcontainer and Podman on Wayland
description: Learn how I set up a DevContainer workflow using Flatpak VSCode, Podman, and Wayland. Running a rust gui project. Perfect for rootless, containerized development on modern Linux desktops.
date: 2025-05-04 08:33:00 +0600
categories: [linux]
tags: [vscode, docker, podman, devcontainer, flatpak, rust, gui, wayland]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: /assets/images/2025-05-04-setup-flatpak-vscode-devcontainer-podman-wayland-gui/devcontainer-poster.webp
  lqip: data:image/webp;base64,UklGRm4AAABXRUJQVlA4IGIAAADwAwCdASoUAAsAPzmGuVOvKSWisAgB4CcJYgC7AB07rW+973ydAVAAAP7k1krNAOIvhDygB2K00bKyOo49JGYLO58qLuwRueizRVly6R2444VlPyyTPFOkpgV0qNOuh2QAAA==
  alt: devcontainer wayland poster
---

Yeah, I know — that’s a bit of a mouthful for a title. But if you’re using an immutable Linux distro like Fedora Silverblue or Kinoite (or anything Atomic), chances are you’ve run into a similar setup. In my case, Flatpak has become my go-to for running GUI apps like VSCode. It's sandboxed, non-intrusive, and just works — most of the time.

I recently started a Rust-based GUI project and wanted to develop it inside a containerized environment. Naturally, I reached for DevContainers with Podman. But running GUI apps (like my Rust app or even graphical tools inside the container) under Wayland with Flatpak VSCode turned out to be more confusing than I expected. Nothing seemed to "just work" out of the box.

In this post, I’ll walk you through how I finally got it working — how to use Flatpak VSCode to work with DevContainers using Podman, and how to get GUI apps running from inside the container under Wayland. Hopefully, this saves you the hours I spent scratching my head.

> vscode + flatpak + devcontainer + podman + wayland
{: .prompt-tip }

## Prerequisites

### 🔹 1. Why I Use Podman Instead of Docker  
First of all, let’s talk about Podman. It’s a container engine just like Docker, but it’s daemonless and works better with rootless containers—which means it’s more secure. It’s developed by Red Hat, and since Fedora is also a Red Hat project, Podman works out of the box.
To install Podman on any linux distro, just run:
```sh
sudo dnf install podman   # fedora, redhat
sudo apt install podman   # debian, ubuntu
```

### 🔹 2. Installing Visual Studio Code and Podman remote as a Flatpak  
Install VS Code:
```sh
flatpak install flathub com.visualstudio.code
```
Podman has a remote flatpak that can connect to host podman. We need to install it:  
```sh
flatpak install com.visualstudio.code.tool.podman
```

### 🔹 3. How to Check If You Are Using Wayland  
If you're using Fedora (Workstation, Kinoite, Silverblue, etc.), there's a high chance you’re running Wayland as the display server instead of X11. Wayland is modern, secure, and smoother in terms of graphics and touchpad gestures.

To confirm which display protocol your session is using, just open a terminal and type:
```sh
echo $XDG_SESSION_TYPE
```
If the output is:  
```sh
wayland
```
Congrats! You're running on Wayland. If it says x11, you're still on the older X server.
You can also check from `loginctl`:  
```sh
loginctl show-session $(loginctl | grep $USER | awk '{print $1}') -p Type
```

## Setup podman and permissions  

Let's configure `podman`.  
Start podman socket:  
```sh
systemctl --user enable --now podman.socket && \
systemctl --user status podman.socket
```

Let's give `vscode` flatpak some pemission.  
```sh
flatpak override --user \
--filesystem=xdg-run/podman:ro \
--filesystem=/run/user/$UID/podman/podman.sock:ro \
com.visualstudio.code
```

Test podman socket connection:
```sh
curl -w "\n" \
-H "Content-Type: application/json" \
--unix-socket /run/user/$UID/podman/podman.sock \
http://localhost/_ping
```

We need to replace `docker` with `podman` for vscode.  
To open and edit this file with your favorite text editor (e.g., code, micro, vim, or gedit): Or from terminal  
```sh
mkdir -p ~/.var/app/com.visualstudio.code/config/Code/User
nano ~/.var/app/com.visualstudio.code/config/Code/User/settings.json
```
and put in the setting
```json
{
    "dev.containers.dockerPath": "/app/tools/podman/bin/podman-remote",
    "dev.containers.dockerSocketPath": "/run/user/$UID/podman/podman.sock"
}
```
> replace $UID with yours. Find with `id -u`

Now vscode should work with podman. 

## Setting up devcontainer.json

We must give this permission for wayland to show any gui inside any `devcontainer.json`:  
```json
{
  "runArgs": [
    "--security-opt=label=disable",
    "--userns=keep-id",
    "--device=/dev/dri",
    "-e", "XDG_RUNTIME_DIR=/tmp",
    "-e", "WAYLAND_DISPLAY=${env:WAYLAND_DISPLAY}",
    "-v", "${env:XDG_RUNTIME_DIR}/${env:WAYLAND_DISPLAY}:/tmp/${env:WAYLAND_DISPLAY}"
  ],
  "containerEnv": {
    "XDG_RUNTIME_DIR": "/tmp",
    "WAYLAND_DISPLAY": "${env:WAYLAND_DISPLAY}"
  }
}
```

We have to install necessary dependencies inside container show any gui.  
example:  
```sh
apt-get install -y \
    pkg-config \
    libasound2-dev \
    libudev-dev \
    mesa-utils \
    vulkan-tools \
    libwayland-dev \
    libxkbcommon-dev \
    libvulkan1 \
    libvulkan-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libx11-dev \
    libxcursor-dev \
    libxrandr-dev \
    libxi-dev \
    libxcb1-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxcb-xkb-dev \
    libegl1-mesa \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglu1-mesa-dev \
    libglu1-mesa \
    libgles2-mesa \
    libgtk-3-0
```

## Example workflow

Nothing is better than a working workflow. Let's just get straight into it.  
I have a template. You can run on your local machine and see for your self. 
It's rust project template.

```sh
git clone git@github.com:tazihad/flatpak-vscode-podman-devcontainer-wayland.git
```

Open the folder with vscode. You should see `devcontainer.json`
```json
{
  "name": "Rust GUI-Enabled",
  "image": "mcr.microsoft.com/devcontainers/rust:1-1-bullseye",
  "customizations": {
    "vscode": {
      "settings": {},
      "extensions": [
        "streetsidesoftware.code-spell-checker"
      ]
    }
  },
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace/${localWorkspaceFolderBasename},type=bind,Z",
  "workspaceFolder": "/workspace/${localWorkspaceFolderBasename}",
  "remoteUser": "root",
  "postCreateCommand": "bash .devcontainer/scripts/dependencies.sh",
  "runArgs": [
    "--security-opt=label=disable",
    "--userns=keep-id",
    "--device=/dev/dri",
    "-e", "XDG_RUNTIME_DIR=/tmp",
    "-e", "WAYLAND_DISPLAY=${env:WAYLAND_DISPLAY}",
    "-v", "${env:XDG_RUNTIME_DIR}/${env:WAYLAND_DISPLAY}:/tmp/${env:WAYLAND_DISPLAY}"
  ],
  "containerEnv": {
    "XDG_RUNTIME_DIR": "/tmp",
    "WAYLAND_DISPLAY": "${env:WAYLAND_DISPLAY}"
  }
}
```

And dependencies.sh

```sh
#!/bin/bash

# Update package lists
echo "Updating package lists..."
apt-get update

# Install required dependencies
echo "Installing dependencies..."
apt-get install -y \
    pkg-config \
    libasound2-dev \
    libudev-dev \
    mesa-utils \
    vulkan-tools \
    libwayland-dev \
    libxkbcommon-dev \
    libvulkan1 \
    libvulkan-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libx11-dev \
    libxcursor-dev \
    libxrandr-dev \
    libxi-dev \
    libxcb1-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    libxcb-xkb-dev \
    libegl1-mesa \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglu1-mesa-dev \
    libglu1-mesa \
    libgles2-mesa \
    libgtk-3-0

# Clean up to reduce image size
echo "Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "Post-installation steps completed successfully!"
```

Rebuild and run container using `ctrl+shift+p` search for `rebuild and reopen in container`.

You need to have [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed for all of it to work. 


## Troubleshooting
For Fedora podman already has `/tmp` permission. If in any other distro you have problem with accessing `/tmp`. Try giving flatpak permisison of `/tmp` to `vscode`.

You really don't need explictly allow `vscode` to run on `wayland`. Even if vscode uisng `x11`. The gui should be uisng `xwayland`.



Check out [Setup Devcontainer in VSCode Flatpak with Podman]({% post_url 2024-08-15-setup-vscode-flatpak-devcontainer-with-podman %}) for more about Vscode devcontainer.

