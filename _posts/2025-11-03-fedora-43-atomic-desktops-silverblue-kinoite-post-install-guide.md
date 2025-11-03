---
title: "Fedora 43 Atomic Desktops Post-Install Guide (2026) – Top Tweaks, Flatpak Setup & Essential Tips"
description: "Discover what to do after installing Fedora 43 Atomic Desktops in this 2025 post-install guide! Learn the best tweaks, Flatpak setup, NVIDIA driver tips, RPM Fusion configuration, and productivity apps to make your Fedora 43 system faster and smoother."
date: 2025-11-03 14:33:00 +0600
categories: [linux,fedora]
tags: [linux,fedora,silverblue,atomic,kinoite]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: /assets/images/2025-11-03-fedora-43-atomic-desktops-silverblue-kinoite-post-install-guide/Screenshot_20251103_184641.webp
  lqip: data:image/webp;base64,UklGRlIAAABXRUJQVlA4IEYAAACQAwCdASoUAAsAPzmGuVOvKSWisAgB4CcJZgCw7B09zQ8i+V/AAP6gwUrHkJhhADjHKZw3rmGtbsbI0nCti383B89EJgAA
  alt: Fedora 43 desktop
---

Let’s go straight to the point and get started.

## Update
Update your system to latest package
```sh
rpm-ostree update
```

Update flatpak apps
```sh
flatpak update -y
```

## Update firmware
```sh
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

## Enable Flatpak & Flathub
Fedora 43 already includes Flatpak, just add Flathub:
```sh
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Install your favourite apps
```sh
flatpak install flathub com.brave.Browser com.spotify.Client org.videolan.VLC com.discordapp.Discord
```

## [Experimental] Install apps as systemd extension
Fedora [developers](https://github.com/travier) are working on experimental features. Which might be included in future. There's no downside for testing this now. It let's us install and use apps that doesn't work with flatpak. And I don't want to layer apps. 
It is called Systemd extension. We can install `zsh`, `steam-devices` or `openh264`.  
You might want to check this site - [fedora-sysexts](https://fedora-sysexts.github.io/)

Default firefox can't play h264 video playback. So, we can install `openh264`
First time setup
```sh
sudo install -d -m 0755 -o 0 -g 0 /var/lib/extensions /var/lib/extensions.d
sudo restorecon -RFv /var/lib/extensions /var/lib/extensions.d
sudo systemctl enable --now systemd-sysext.service
```

Install `openh264`
```sh
install_sysext() {
  SYSEXT="${1}"
  URL="https://extensions.fcos.fr/community"
  sudo install -d -m 0755 -o 0 -g 0 /etc/sysupdate.${SYSEXT}.d
  sudo restorecon -RFv /etc/sysupdate.${SYSEXT}.d
  curl --silent --fail --location "${URL}/${SYSEXT}.conf" \
    | sudo tee "/etc/sysupdate.${SYSEXT}.d/${SYSEXT}.conf"
  sudo /usr/lib/systemd/systemd-sysupdate update --component "${SYSEXT}"
}
```
You might want to checkout [full guide](https://fedora-sysexts.github.io/community/openh264/)

Similarly, you can install apps that are available in the repo.  
[Official fedora repo](https://fedora-sysexts.github.io/fedora/)  
[Fedora community repo](https://fedora-sysexts.github.io/community/)

## Enable magic SysRq - REISUB

To enable the SysRq key functionality, add the following line to the `/etc/sysctl.d/90-sysrq.conf` file:
```sh
kernel.sysrq = 1
```
In case your system freezes, you can safely reboot it using the **REISUB** sequence:

1. Hold down `Alt` + `SysRq` (Print Screen key).
2. While holding them, type the following keys in order: `R`, `E`, `I`, `S`, `U`, `B`.

## Install brew
Brew from Macos now works with linux. If you are from mac world. You should be at home.
Check out [How to install Homebrew (Brew / LinuxBrew) in Fedora Silverblue & Kinoite]({% post_url 2023-01-07-how-to-install-linuxbrew-in-silverblue-kinoite %}) for more about installing Linuxbrew.

## Mount Drives permanently

You many want to mount external drivers.

check `uuid` of the drive you want to mount permanently 
```sh
lsblk -f
```
add `uuid` in `/etc/fstab` at the last line
```sh
UUID=0d8130f6-ad5a-4df7-9c44-5001f3a950d8 /home/my_user_name/data   ext4    defaults,noatime,x-gfvs-show 0 0
```

## Gaming
For gaming on Fedora atomic there are many ways. Check my other posts. [Setup Gaming Environment for Fedora Silverblue & Kinoite]({% post_url 2023-01-11-gaming-on-fedora-silverblue %})






