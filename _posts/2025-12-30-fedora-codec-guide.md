---
title: "How to Install Codecs & Enable Hardware Acceleration in Fedora"
description: "Fix choppy video and missing audio on Fedora! Learn to install essential codecs (H.264/HEVC) and enable hardware acceleration (VA-API) for smooth 4K playback."
date: 2025-12-30 13:33:00 +0600
categories: [linux]
tags: [linux, fedora, multimedia, hardware-acceleration, ffmpeg, rpm-fusion, video]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: /assets/images/2025-12-30-fedora-codec-guide/cover.webp
  lqip: data:image/webp;base64,UklGRmoAAABXRUJQVlA4IF4AAAAQBACdASoUAAsAPzmEuVOvKKWisAgB4CcJbACdACKmEzHmc68hgboZwADvoG6wayXh98ig6rrtMPEZOvb3Rz+Vy3Zt+w9nGLFtWH7VGV01hHoAPDgISlMES6IYAAAA
---

Fedora does not include proprietary media codecs (like H.264/H.265, AAC) by default due to patent and licensing restrictions. To play these formats, you generally need to enable the RPM Fusion repositories.

## OpenH264 support
Fedora cannot ship MP4/H.264 support by default because of patents. However, Cisco pays the patent fees for a specific version of H.264 called OpenH264 and gives it away for free.
```sh
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf install mozilla-openh264 gstreamer1-plugin-openh264
```
> Note: If you installed `gstreamer1-libav` (from the below steps), your system will prefer that over this one. This package becomes a backup/fallback.

## Enable RPM Fusion Repositories
Mendatory step. Copy and paste this entire command to enable both free and non-free repositories of rpmfusion:
```sh
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

## Method 1: The Easy/Clean Method (Recommended)
By default, Fedora installs a version of FFmpeg called `ffmpeg-free`. It contains all the open-source code to play formats like VP9 (YouTube) or AV1. However, the code for H.264 (standard MP4 video) and H.265/HEVC is physically removed because of patent laws in the US.

Instead of replacing the system libraries, install `libavcodec-freeworld`. This adds the restricted codecs (H.264/H.265) to your existing system without breaking base updates.

```sh
sudo dnf install libavcodec-freeworld
```

## Method 2: Replacing system ffmpeg
This method completely removes the limited `ffmpeg-free` packages installed by Fedora and replaces them with the full-featured `ffmpeg` packages from RPM Fusion.

You get the full ffmpeg command-line tool. You can convert, encode, and stream video formats like H.264/H.265 using the terminal. 

```sh
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
```

## Additional Codecs
GNOME Videos (Totem), Rhythmbox, and the GNOME Web browser all rely on a framework called GStreamer to play media. By default, GNOME comes with "free" GStreamer plugins (which cannot play common files). This command installs the "ugly" and "bad" plugins (the actual names used by developers) that allow GNOME apps to play restricted formats like MP4, AAC, and H.265.

```sh
sudo dnf upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
```

## Hardware Accelerated Codec
This allows your GPU to handle video decoding/encoding, reducing CPU usage and battery drain.

### 1. Intel Graphics
For newer interl integrated or dedicated graphics:  
Gen 8 (Broadwell) and newer. 2015 and later. Examples: Broadwell, Skylake, Kaby Lake, Coffee Lake, Tiger Lake, Intel Arc etc.
```sh
sudo dnf install intel-media-driver
```
### 2. Intel (Legacy)
Gen 7.5 (Haswell) and older. Year: 2014 and earlier. Examples: Haswell, Ivy Bridge, Sandy Bridge.
```sh
sudo dnf install libva-intel-driver
```

Not sure which one you have? Run this command to see your CPU model/generation year:
```sh
lscpu | grep "Model name"
```

### 3. AMD Graphics
Fedora excludes H.264/H.265 support from the default AMD drivers due to US patent laws and the specific way AMD drivers (Mesa) are built.

```sh
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
```

By default **32-bit** support is not included in fedora. But **Steam**, **Lutris**, or **Wine**. Steam relies on 32-bit libraries, and if they don't match your main drivers, games may crash or fail to launch.

```sh
sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
```

### 4. NVIDIA
Use this if you only use standard desktop apps like Firefox, Chrome, or VLC. It installs the wrapper for your main system only (64-bit).
```sh
sudo dnf install libva-nvidia-driver
```
Use this if you play games (Steam, Lutris, Wine). It installs both the 64-bit version for the system and the 32-bit version for games, ensuring everything runs smoothly.
```sh
sudo dnf install libva-nvidia-driver.{i686,x86_64}
```

