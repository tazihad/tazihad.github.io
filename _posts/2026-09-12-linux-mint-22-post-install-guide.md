---
title: "Linux Mint 22 Post-Install Guide: 11 Essential Steps to a Perfect Setup"
description: "Just installed Linux Mint 22? Follow this complete post-install guide to optimize package mirrors, configure Timeshift snapshots, install multimedia codecs, set up NVIDIA drivers, and tune Cinnamon for daily use."
date: 2026-09-12 10:15:00 +0600
categories: [linux, mint]
tags: [linux, mint, linux mint 22, post-install, cinnamon, apt, flatpak, nvidia]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-09-12-linux-mint-22-post-install-guide/banner.webp
  lqip: data:image/webp;base64,UklGRrYAAABXRUJQVlA4IKoAAADwAwCdASoUAAsAPpE6l0eloyIhMAgAsBIJaACdMoABre4qO7DNyZYAAP7t17pSqJqJrE7zkh8gDSKzfk/PHPgove3tknJdA9oO+pNRdMWQhL2yJFhdMZXTikkbk5ChZFznwnL517a7aUGh2Jx1dNvkZwUpivXOP4za3u/3D+dyvh61rivz/Nr8n+KfpUfQDPOa48fQesa598ZPIScyKDEljg3jlEOboAAAAA==
  alt: Linux Mint 22 Cinnamon desktop after a fresh install
---

Linux Mint 22 ships with an updated Ubuntu LTS base, modern Linux kernel support, PipeWire as the default audio server, and the refined Cinnamon desktop. Out of the box, Mint is one of the most reliable desktop distributions available, but a few critical post-installation adjustments are needed to ensure maximum download speeds, hardware acceleration, and system recovery.

This guide walks through the essential steps to configure a fresh Linux Mint 22 installation for daily workstation and development use.

---

## 1. Select the Fastest Local Mirrors

By default, Linux Mint connects to worldwide default mirrors. Switching to mirrors physically closer to your location significantly speeds up package downloads and system upgrades.

1. Open the application menu and launch **Software Sources** (or run `pkexec mintsources` in the terminal).
2. Under the **Mirrors** section, click on the **Main (wilma)** mirror. The tool will benchmark available servers; pick the one with the highest speed.
3. Next, click on the **Base (noble)** mirror and select the fastest nearby mirror.
4. When prompted, click **OK** to refresh your APT package cache.

---

## 2. Update System Packages and Kernel

With the fastest mirrors active, perform a complete update to apply the latest security patches and bug fixes:

```bash
sudo apt update && sudo apt upgrade -y
```

If a new kernel or systemd update was pulled, reboot before continuing:

```bash
sudo reboot
```

---

## 3. Set Up Timeshift System Snapshots

Linux Mint includes **Timeshift** by default. Setting up an initial snapshot now gives you a safe recovery point if a future configuration or driver update breaks your system.

1. Launch **Timeshift** from the application menu.
2. Select **RSYNC** as the snapshot type and click **Next**.
3. Select your target system drive.
4. Configure your schedule:
   - **Daily:** Keep 2 to 3 snapshots.
   - **Boot:** Keep 1 snapshot (optional, convenient for rollback on bad updates).
5. **Important:** Leave `/root` and `/home` excluded by default. Timeshift is meant for system files, not personal documents. Use tools like `rclone`, `BorgBackup`, or external drives for personal data.
6. Click **Create** to trigger your first baseline snapshot.

---

## 4. Install Multimedia Codecs

If you did not check the "Install multimedia codecs" box during the OS installation, patent-restricted audio and video formats (such as H.264/H.265, AAC, and specific MP3 decoders) won't play out of the box.

Install the meta-package via terminal:

```bash
sudo apt install -y mint-meta-codecs
```

To install Microsoft TrueType Core Fonts (Arial, Times New Roman, etc.):

```bash
sudo apt install -y ttf-mscorefonts-installer
```

Accept the EULA prompt using the `Tab` key and `Enter`.

---

## 5. Install Hardware and NVIDIA Drivers

Linux Mint has one of the cleanest driver managers in the Linux ecosystem.

1. Open **Driver Manager** from the application menu.
2. Enter your password and allow it to scan your hardware.
3. If you are using an NVIDIA graphics card, select the latest recommended **proprietary-tested** driver branch (e.g., `nvidia-driver-550` or newer).
4. For Wi-Fi adapters (such as Broadcom or Realtek chips), enable the recommended proprietary kernel module if listed.
5. Click **Apply Changes** and reboot when finished.

Verify that your NVIDIA driver is active:

```bash
nvidia-smi
```

---

## 6. Configure Flatpak and Unconfined Application Settings

Linux Mint 22 integrates Flathub natively into the Software Manager. Starting in Mint 22, the Software Manager highlights unverified and unconfined Flatpaks for security transparency.

Update your Flatpak repository metadata:

```bash
flatpak update
```

To easily manage fine-grained Flatpak permissions (such as file system access and Wayland socket permissions) via a GUI, install **Flatseal**:

```bash
flatpak install flathub com.github.tchx84.Flatseal -y
```

---

## 7. Enable the UFW Firewall

Linux Mint comes with the Uncomplicated Firewall (`ufw`) pre-installed, but it is disabled by default.

Enable it to block unauthorized incoming connections while allowing normal outbound traffic:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

Check its operational status:

```bash
sudo ufw status verbose
```

If you prefer a GUI, search for **Firewall Configuration** (`gufw`) in the application menu.

---

## 8. Optimize Laptop Battery and Power Management

If you are running Linux Mint 22 on a laptop, installing **TLP** or using `power-profiles-daemon` helps maximize battery life and reduce thermal throttling.

### Option A — TLP (Recommended for maximum battery savings)

```bash
sudo apt install -y tlp tlp-rdw
sudo systemctl enable --now tlp
```

Check active battery state and throttling parameters:

```bash
sudo tlp-stat -s
```

### Option B — Power Profiles Daemon (Best for GUI switching)

If you prefer toggling between Power Saver, Balanced, and Performance directly from the system tray:

```bash
sudo apt install -y power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon
```

> [!NOTE]
> Do not run both `tlp` and `power-profiles-daemon` simultaneously, as they will conflict. Choose one.

---

## 9. Limit Systemd Journal Log Size and Clean APT

Over time, systemd log files can accumulate and take up gigabytes of disk space. Set a reasonable cap on the journal log size:

```bash
sudo journalctl --vacuum-size=100M
```

To make this persistent across reboots, edit the journal configuration:

```bash
sudo sed -i 's/#SystemMaxUse=/SystemMaxUse=100M/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
```

Remove unused dependencies and purge residual configuration files left from older packages:

```bash
sudo apt autoremove --purge -y
sudo apt clean
```

---

## 10. Essential Cinnamon Desktop Tweaks

Cinnamon 6 in Linux Mint 22 is clean, responsive, and highly customizable. Here are practical settings to tweak:

### Enable Fractional Scaling (For High-DPI Displays)
1. Go to **System Settings > Display**.
2. Toggle on **Fractional scaling**.
3. Choose your preferred scaling factor (e.g., 125% or 150%).

### Enable Redshift (Night Light)
1. Go to the application menu and search for **Redshift**.
2. Right-click the Redshift tray icon, select **Autostart**, and turn it on to reduce blue light strain during evening hours.

### Configure Window Snapping and Hot Corners
1. Open **System Settings > Window Tiling**.
2. Ensure edge-snapping and fullscreen tiling shortcuts (`Super + Arrow keys`) are enabled to manage side-by-side multitasking smoothly.

---

## 11. Install Essential Daily and Developer Tools

Finally, install a base suite of terminal and system administration utilities:

```bash
sudo apt install -y \
  build-essential \
  curl \
  wget \
  git \
  htop \
  btop \
  fastfetch \
  micro \
  vim \
  p7zip-full \
  unrar
```

Your Linux Mint 22 installation is now fast, secure, backed up by Timeshift, and ready for day-to-day productivity.
