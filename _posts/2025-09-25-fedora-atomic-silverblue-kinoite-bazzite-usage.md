---
title: How to Properly Use Fedora Atomic Desktops: Silverblue, Kinoite, and Bazzite Explained
description: Examples of text, typography, math equations, diagrams, flowcharts, pictures, videos, and more.
date: 2025-09-25 12:33:00 +0600
categories: [linux, fedora]
tags: [silverblue, kinoite, bazzite, fedora, atomic]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: ../assets/images/2025-09-25-fedora-atomic-silverblue-kinoite-bazzite-usage/cover.webp
  lqip: data:image/webp;base64,UklGRl4AAABXRUJQVlA4IFIAAACwAwCdASoUAAsAPzmGulOvKKWisAgB4CcJYgCw7Bcx8Vf7V27oAAD6c2jTpPubDweSQEc6d8Qeggy3Oz7QfRuEYK9UUS7FofziSlzBraW0oAAA
  alt: fedora atomic usage
---

I have been using Fedora Atomic distro since Fedora released Kinoite with Fedora 35. For first few weeks it felt odd. I couldn't install any apps using `sudo dnf install htop`. Fedora suggests that I use `toolbox`. I was introduced to `podman`. 

Fedora devs want me to not install anything to the system. And use container based approach. They tell use to use flatpak apps, appimages or binaraies. I couldn't understand the benefit.

One thing is clear my system is saved from all the thousands of dependencies that comes along with a app. 

I discovered different ways to use apps and developments. I will share them below.

### Flatpak

Fedora Atomic heart and soul is flatpak. Fedora defaults to flatpak apps. If you open Fedora software center or discover. You would get recommanded flatpak apps. Sometime Fedora defaults to Fedora flatpak repo. But a better way to use Flatpak is to use Flatpak central repo. Which is flathub.

```sh
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

If you see that Fedora has filtered flathub. You can remove the filter using
```sh
flatpak remote-modify --no-filter --enable flathub
```

You will notice that all default apps comes from fedora remote.
```sh
flatpak list
```

You can install these apps from flathub. It can help reduce runtime storage.
Run this command to reinstall fedora flatpak repo applications with ones from flathub
```sh
flatpak install --reinstall flathub $(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application | tail -n +1 )
```

This is optional. You can remove fedora flatpak repo entirely.
```sh
flatpak remote-delete fedora
```
> Reinstall fedora remote using `flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org`


Now install any app that is available in [flathub](https://flathub.org).

```sh
flatpak install flathub com.google.Chrome
```

### Appimage

Using appimage is straight forward. Download an appimage. And double click to use it. May need executable permission.

There are some apps avilable to integrate appimages.

#### Gear Lever

Gear Lever from flathub can manage appimages and integrate into system.

```sh
flatpak install flathub it.mijorus.gearlever
```

#### AppImageLauncher

AppimageLauncher provide some way to integrate appimage. The downside is this is a service that is always running in background.

They have 2 release. Traditional deb, rpm and a lite version using appimage.

Let's see how to use lite appimage version.

Download lite appimage from [here](https://github.com/TheAssassin/AppImageLauncher/releases).

Make it executable. And install
```sh
chmod +x ./appimagelauncher-lite-3.0.0-alpha-4-gha275-x86_64.AppImage
./appimagelauncher-lite-3.0.0-alpha-4-gha275-x86_64.AppImage install
```

You should see AppImageLauncher Settings app in your app menu.

Put any appimage in `~/Applications` folder. Your appimage will be auto integrated to the system.

### Toolbox

Some apps do not have any flatpak and appimage release. These are hard to use. The better way to use these apps is using `toolbox`.

An app is **MegaSync**. This MegaSync app has no flatpak or appimage release. But MegaSync has traditional rpm release. We can use `toolbox` to use such apps.


Let's create a `toolbox` named `apps`.
```sh
toolbox create --release f43 --container apps
```

Enter this toolbox using 
```sh
toolbox enter apps
```

Now download the megasync rpm from their website. And install it from toolbox.
```sh
sudo dnf install ~/Downloads/megasync-Fedora_43.x86_64.rpm
```

Export the app.

Get the CONTAINER_ID of container `apps`
```sh
podman ps -a --filter "name=apps"
```

Check the `.desktop` if available inside container.
```sh
podman exec CONTAINER_ID ls /usr/share/applications
```

export the `.desktop`
```sh
podman cp CONTAINER_ID:/usr/share/applications/megasync.desktop ~/.local/share/applications/megasync.desktop
```
export the `.icon`
```sh
mkdir -p ~/.local/share/icons/hicolor/128x128/apps/
podman cp CONTAINER_ID:/usr/share/icons/hicolor/128x128/apps/mega.png ~/.local/share/icons/hicolor/128x128/apps/
```

Let's modify the `.desktop` file `.local/share/applications/megasync.desktop`. We just have to change the executable to  
```sh
Exec=toolbox run --container apps /usr/bin/megasync
```

We can set the `.desktop` to autostart by copying the file to `~/.config/autostart/`.


### Podman Quadlet

Podman has quadlet feature. Which integrates with systemd. Allows you to run container based applications.

All you have to do is create a `.container` quadlet file.

Let's try one with Qbittorrent quadlet.

Create `qbittorrent-nox.container` in `~/.config/containers/systemd/`

```sh
[Container]
Image=docker.io/qbittorrentofficial/qbittorrent-nox:latest

AutoUpdate=registry
PublishPort=8080:8080
PublishPort=6881:6881
PublishPort=6881:6881/udp
Timezone=Asia/Dhaka

Environment=PUID=1000
Environment=PGID=1000
# Set the port for qBittorrent Web UI access at http://localhost:8080
# You can change 8080 to any unused port you prefer.
Environment=QBT_WEBUI_PORT=8080

# Persistent Podman config storage (any local path, e.g., Volume=%h/.config/qBittorrent:/config)
Volume=qbittorrent-config:/config
Volume=%h/Downloads:/downloads

# SELinux considerations for Fedora/RHEL:
# - Use :Z on volume mounts to automatically relabel directories for container access.
#   Example:
#     Volume=%h/Downloads:/downloads:Z
# - If you prefer to manage SELinux labeling manually or want to disable relabeling:
#     SecurityLabelDisable=true

User=root
UserNS=keep-id
Network=host

[Service]
Restart=on-failure
TimeoutStartSec=900

[Install]
WantedBy=default.target
```

start the quadlet
```sh
systemctl --user daemon-reload
systemctl --user start qbittorrent-nox
```

You can find more quadlets in [my repo](https://github.com/tazihad/podman-quadlets), [dwedia](https://github.com/dwedia/podmanQuadlets), [herzenschein](https://github.com/herzenschein/herz-quadlet), [appstore](https://github.com/containers/appstore).

You can also convert a podman command to a quadlet using [podlet](https://github.com/containers/podlet/releases).

### Brew

Another way to use cli apps using brew.

Cli apps like `htop`, `gh`, `yt-dlp` can be installed using brew.

Check out [How to install Homebrew (Brew / LinuxBrew) in Fedora Silverblue & Kinoite]({% post_url 2023-01-07-how-to-install-linuxbrew-in-silverblue-kinoite %}) for more about installing Linuxbrew.