---
title: "Arch Linux & EndeavourOS Post-Install Guide: From Fresh Install to Daily Driver"
description: "A complete post-installation setup guide for Arch Linux and EndeavourOS. Covers pacman tuning, reflector, yay, PipeWire audio, graphics drivers, zram, firewall, and essential daily utilities."
date: 2026-09-13 10:00:00 +0600
categories: [linux, arch]
tags: [linux, arch, endeavouros, post-install, pacman, aur, yay, pipewire, btrfs]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-09-13-arch-linux-endeavouros-post-install-guide/banner.webp
  lqip: data:image/webp;base64,UklGRsYAAABXRUJQVlA4ILoAAACQBACdASoUAAsAPpE4l0eloyIhMAgAsBIJZgCdH8AgpRlw5LEl70pmLv21GYAA/sKZZoP3b/j8MRFVRN7Jrk+9FV9byWRFwVucNZdsxBWX9qGIXi0yldKxYuXb3U9LkO8JDxb/KuL23s4+G5i4VaG4tNxhA97Fmum6KNFaImGNOoIqsU7AcrFQbLCAAUJuQLZz//dMhL8SvfuNW/9cvLvf6yvUIbJM+1zh7kwgxwLTWn881p80zpTQAAA=
  alt: Arch Linux and EndeavourOS terminal and desktop setup
---

Completing a minimal Arch Linux install or landing on the EndeavourOS desktop is only half the battle. A freshly installed system lacks several essential optimizations: pacman mirror ranking, multilib repositories, audio plumbing, power management, and an AUR helper.

This post-install checklist walks through configuring Arch Linux or EndeavourOS into a reliable, high-performance daily workstation.

---

## 1. Optimize Pacman Configuration

Open `/etc/pacman.conf`:

```bash
sudo nano /etc/pacman.conf
```

Find the `[options]` section and make the following adjustments:

```ini
# Enable parallel downloads (set between 5 and 10)
ParallelDownloads = 5

# Enable terminal color output and pacman animation
Color
ILoveCandy
VerbosePkgLists
```

Scroll down to the repository section and uncomment the `[multilib]` repository to enable 32-bit software support (required for Steam, Wine, and certain 32-bit libraries):

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`), then synchronize repository databases:

```bash
sudo pacman -Syu
```

---

## 2. Benchmark and Rank Mirrors with Reflector

Slow download speeds on Arch are usually caused by stale or geographically distant mirrors. Use `reflector` to fetch and rank the 15 fastest HTTPS mirrors:

```bash
sudo pacman -S --needed reflector rsync
sudo reflector --latest 15 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

To automate mirror updates on a weekly timer, enable the systemd service:

```bash
sudo systemctl enable --now reflector.timer
```

---

## 3. Install an AUR Helper (yay)

The Arch User Repository (AUR) contains nearly every package not found in the official repos. Install `yay` using base development tools:

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd .. && rm -rf yay-bin
```

Verify the installation and test an update:

```bash
yay -Syu
```

---

## 4. Verify Audio Stack (PipeWire & WirePlumber)

Modern Arch uses **PipeWire** as the low-latency replacement for PulseAudio and JACK. Ensure all compatibility layers and the WirePlumber session manager are installed:

```bash
sudo pacman -S --needed \
  pipewire \
  pipewire-audio \
  pipewire-alsa \
  pipewire-pulse \
  pipewire-jack \
  wireplumber \
  pavucontrol
```

Enable the user services:

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

Check that PulseAudio emulation is active:

```bash
pactl info | grep "Server Name"
```
*Output should display: `Server Name: PulseAudio (on PipeWire ...)`*

---

## 5. Install GPU Drivers

### For NVIDIA
Install DKMS drivers so kernel updates don't break display output:

```bash
sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
```

Enable NVIDIA systemd services for power management:

```bash
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
```

### For AMD
Install the open-source Mesa drivers and Vulkan loader:

```bash
sudo pacman -S --needed mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
```

### For Intel
```bash
sudo pacman -S --needed mesa lib32-mesa intel-media-driver vulkan-intel lib32-vulkan-intel
```

---

## 6. Configure ZRAM Swap

ZRAM creates a compressed RAM block device used as swap, significantly improving memory efficiency under heavy loads.

Install `zram-generator`:

```bash
sudo pacman -S --needed zram-generator
```

Create `/etc/systemd/zram-generator.conf`:

```bash
sudo nano /etc/systemd/zram-generator.conf
```

Add the following configuration:

```ini
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
```

Start the service and verify:

```bash
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service
zramctl
```

---

## 7. Enable Essential System Services

Enable SSD TRIM, Bluetooth, and network time synchronization:

```bash
# Periodic SSD TRIM (runs weekly)
sudo systemctl enable --now fstrim.timer

# Network time synchronization
sudo systemctl enable --now systemd-timesyncd.service

# Bluetooth (if hardware is present)
sudo pacman -S --needed bluez bluez-utils
sudo systemctl enable --now bluetooth.service
```

---

## 8. Configure the UFW Firewall

Install and start the Uncomplicated Firewall:

```bash
sudo pacman -S --needed ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw.service
```

---

## 9. Set Up Automated Pacman Cache Cleaning

Pacman does not delete old package tarballs automatically from `/var/cache/pacman/pkg/`. Use `paccache` from `pacman-contrib` to keep only the 2 most recent versions:

```bash
sudo pacman -S --needed pacman-contrib
sudo systemctl enable --now paccache.timer
```

---

## 10. Install Fonts, Media Codecs, and Core Tools

Prevent missing glyphs, boxes, and broken font rendering across web pages and documents:

```bash
# Fonts
sudo pacman -S --needed \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  ttf-liberation \
  ttf-jetbrains-mono-nerd

# Media codecs and playback
sudo pacman -S --needed \
  ffmpeg \
  gstreamer \
  gst-plugins-good \
  gst-plugins-bad \
  gst-plugins-ugly \
  gst-libav \
  mpv

# Essential CLI Utilities
sudo pacman -S --needed \
  htop \
  btop \
  fastfetch \
  curl \
  wget \
  unzip \
  p7zip \
  bash-completion
```

Reboot your system to apply all kernel modules, services, and display driver changes:

```bash
sudo reboot
```
