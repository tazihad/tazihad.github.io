---
title: Debian 13 Minimal KDE Plasma Installation & Post-Install Tweaks and Tips
description: Learn how to install Debian 13 with a minimal KDE Plasma setup and optimize your system with essential post-install tweaks. Perfect for users seeking a lightweight and efficient Linux desktop experience.
date: 2025-04-21 16:33:00 +0600
categories: [linux]
tags: [linux, debian, kde plasma, minimal install, post-install tips]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: ../assets/images/2025-04-21-debian-minimal-kde-plasma-post-install/debian-plasma-minimal-setup.webp
  lqip: data:image/webp;base64,UklGRnoAAABXRUJQVlA4IG4AAABwBACdASoUAAsAPzmGuVOvKSWisAgB4CcJaACdOUDcMRKg0bEGJZs/h5PUgAD0BSLiW+6DZ7kGKBDOMYDkq/SJ0zEdEhA3Sz3OKnhoQZ9f7z7kqzY6HtzfJYT8Q7g0BGSt9q7iLP6EyeygznQAAA==
  alt: Debian KDE Plasma minimal setup
---

Debian 13 is one of the most stable and versatile Linux distributions available, and when combined with a minimal KDE Plasma setup, it offers a lightweight yet powerful desktop experience. In this guide, we’ll walk you through the Debian 13 minimal installation process and share essential post-install tweaks to optimize your system for performance and usability. Whether you’re a beginner or an experienced user, this step-by-step guide will help you set up Debian with KDE Plasma, ensuring a smooth and efficient Linux environment.

## Introduction

During Debian install and in **Software selection** uncheck everything except **standard system utilities**

## Minimal Plasma Desktop Install

```sh
sudo apt install kde-plasma-desktop plasma-nm sddm-theme-breeze kwin-addons -y
```

Reboot the system. This should give you basic minimal kde plasma setup for debian.

You can also remove some bloats if you have already install kde plasma full
```sh
sudo apt-get remove --purge 'kontrast*', 'k3b*', 'akregator*', 'imagemagick*', 'kmail*', 'apper*', 'dragon*','juk*','contact*','kmousetool*','kmouth*','kwrite*','kmag*','konqueror*','sieveeditor*'
```

## Fix Debian ethernet or network not working  
Sometimes after installations ethernet network may not work. we can fix it like this.

```sh
sudo nano /etc/network/interfaces
```
comment this:
```sh
#iface enp4s0f1 inet dhcp				# comment this 
```
> or your ethernet device name

You can also edit `/etc/NetworkManager/NetworkManager.conf` to give Network Manager full control over your network devices. Set `managed=true`.
```sh 
[ifupdown]
managed=true
```


## Username is not in the sudoers file  
To get root, then add your user to the sudo group, use:
```sh
su -
usermod -aG sudo YOUR_USERNAME
exit
```

or 

```sh
su
nano /etc/sudoers
```
Add your user below %sudo
EXAMPLE:
```sh
Defaults        env_reset,pwfeedback
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Defaults        insults

# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL
USER_NAME    ALL=(ALL:ALL) ALL
```

## Fastest mirror  
Find fastest mirrors. A list of mirrors ranked by speed will be places in your home directory
Copy this list to `/etc/apt/sources.list`
```sh
sudo apt install netselect-apt
netselect-apt
sudo apt-get update
```

## Install flatpak  
Install flatpak and add flathub
```sh
sudo apt install flatpak 
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt install plasma-discover-backend-flatpak
```

## Comment *-src from sources

Unless you are from developers you should remove the sources files for faster updates.
Go to `/etc/apt/sources.list` and comment out the src lines.

## Install some necessary softwares  
These are some basic softwares that I like. 
```sh
sudo apt install synaptic breeze-gtk kde-gtk-config kde-config-gtk-style kde-config-gtk-style-preview vlc kdeconnect neovim htop neofetch gstreamer1.0-nice gstreamer1.0-plugins-bad python-is-python3 python3-pip ncdu thunderbird stacer 
```
## Setup Bootsplash  
Bootsplash may not be setup in debian. We can set it manually.

```sh
sudo apt install plymouth plymouth-themes plymouth-theme-breeze kde-config-plymouth kde-config-sddm sddm-theme-debian-breeze
```

Than add `splash` in `/etc/default/grub`
```
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

Update grub
```sh
sudo update-grub
```

Setup plymouth. Edit `/etc/plymouth/plymouthd.conf`
```conf
[Daemon]
Theme=bgrt
```
Than 
```sh
sudo update-initramfs -u
```


## Mount Drives

You many want to mount external drivers.

check `uuid`
```sh
ls -l /dev/disk/by-uuid
sudo blkid
```

add `uuid` in `/etc/fstab` at the bottom

```
# UUID=0d8130f6-ad5a-4df7-9c44-5001f3a950d8 /storage/data   ext4    defaults,noatime,x-gfvs-show 0 0
```
> Mount in your desired location in replace with /storage/data

## 32-bit support
Enable 32bit package downloads. ( Required for some games )
```sh
sudo dpkg --add-architecture i386
sudo apt update
```

## WINE

- wine from wine-hq install [wiki](https://wiki.winehq.org/Debian)
```sh
wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
sudo echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" >  /tmp/winehq.list
sudo cp -v /tmp/winehq.list /etc/apt/sources.list.d/
sudo apt update
sudo apt install --install-recommends winehq-stable
```
- wine from Debian
```sh
sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install wine wine32 wine64 libwine libwine:i386 fonts-wine wine-binfmt
```

**Mono & Gecko**
Download and put these here manually
`/usr/share/wine/`

- [Mono](https://wiki.winehq.org/Mono#Installing "Mono")
- [Gecko](https://wiki.winehq.org/Gecko "Gecko")

Example:
**MONO**
```sh
wget https://dl.winehq.org/wine/wine-mono/9.0.0/wine-mono-9.0.0-x86.msi -P ~/.local/share/wine/mono
```

**Gecko (both 32-bit and 64-bit):**
```sh
wget https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi -P ~/.local/share/wine/gecko
wget https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi -P ~/.local/share/wine/gecko
```


## Install Nvidia Drivers 


Install NVIDIA Drivers
```sh
sudo apt install nvidia-detect
nvidia-detect
sudo apt install linux-headers-amd64 nvidia-driver firmware-misc-nonfree mesa-utils mesa-utils-extra 
sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install nvidia-driver-libs:i386
sudo reboot
nvidia-smi
watch nvidia-smi
```

## Debian Gaming

Install Steam 
```sh
sudo apt install steam
```

## Hardware Acceleration for Debian

For Intel:
```sh
sudo apt install intel-media-va-driver-non-free intel-gpu-tools i965-va-driver-shaders nvidia-vdpau-driver libnvcuvid1 libnvidia-encode1 vdpauinfo vainfo gstreamer1.0-vaapi gstreamer1.0-plugins-bad vulkan-tools
```

Add some environment variable in `/etc/environment`
```
# Intel
LIBVA_DRIVER_NAME=i965
VDPAU_DRIVER=va_gl

# NVIDIA
#LIBVA_DRIVER_NAME=vdpau
#VDPAU_DRIVER=nvidia
```

check hw acceleration usage

```sh
vainfo
vdpauinfo
sudo intel_gpu_top
nvidia-smi -q | grep Decoder
watch -n 1 'nvidia-smi -q | grep Decoder'
```

enable hwacceleration for **mpv**
add in `$HOME/.config/mpv/mpv.conf`
```
hwdec
```

## non-free codecs and other media components
```sh
sudo apt update && sudo apt install -y \
  ffmpeg \
  libavcodec-extra \
  ttf-mscorefonts-installer \
  libdvdcss2 \
  libdvd-pkg \
  ffmpegthumbnailer \
  ffmpegthumbs \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav \
  gstreamer1.0-tools \
  gstreamer1.0-vaapi \
  tumbler-plugins-extra \
  kdegraphics-thumbnailers && \
  sudo dpkg-reconfigure libdvd-pkg
```