---
title: "openSUSE Tumbleweed Post-Install Guide: First Things to Do After Installation"
description: "Just installed openSUSE Tumbleweed? This post-install guide covers zypper updates, Packman codecs, Flatpak, NVIDIA drivers, firewall setup, YaST tips, and essential apps to get your rolling release ready."
date: 2026-09-11 10:00:00 +0600
categories: [linux, opensuse]
tags: [linux, opensuse, tumbleweed, post-install, zypper, kde, gnome]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-09-11-opensuse-tumbleweed-post-install/banner.webp
  lqip: data:image/webp;base64,UklGRroAAABXRUJQVlA4IK4AAADQBACdASoUAAsAPpE4l0eloyIhMAgAsBIJZgCdMoRwH1/AUD0bssCt7qlcJqw8AAD+44hm8FmJg+7GcBfg1cag8zPG2EMp70dhzWXIa/6XzTg+g3fqxKWN58rKh934m2rXADZg7LHQSRs5V2A+67OYbYz2Uiq9P5Jhm89RiR2O4xTLW9ztpAWXxPTeBP+Q9ck+w3Op+aDc28YYALDdwiFQOtjHYk+xxysDQ3+gAAA=
  alt: openSUSE Tumbleweed post-install guide banner
---

openSUSE Tumbleweed is one of the most polished rolling-release distributions out there. Unlike Arch, it gives you a stable base with tested snapshots — meaning rolling doesn't mean broken. But fresh off the installer, there are a handful of things you should do before treating it as your daily driver.

This guide covers everything from updating the system and enabling the Packman repository to setting up NVIDIA drivers, Flatpak, and snapshots.

---

## 1. Update the System with zypper

First things first — bring the system fully up to date. Tumbleweed snapshots are released frequently, and the installer image you used could be weeks old.

```bash
sudo zypper refresh
sudo zypper dist-upgrade
```

Use `dist-upgrade` (or `dup`) on Tumbleweed, not just `upgrade`. This is the correct command for a rolling release — it handles package additions, removals, and replacements that a plain upgrade won't.

Reboot after this if a kernel update was pulled in:

```bash
sudo reboot
```

---

## 2. Enable the Packman Repository for Codecs

openSUSE ships without patent-encumbered multimedia codecs by default. The **Packman** community repository fills that gap — it provides GStreamer plugins, FFmpeg, libdvdcss, and codec-complete builds of apps like VLC.

Add Packman and switch codec packages to it:

```bash
sudo zypper addrepo -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
sudo zypper refresh
sudo zypper dist-upgrade --from packman --allow-vendor-change
```

The `--allow-vendor-change` flag is important — it replaces openSUSE's codec-limited packages with Packman's full-featured builds.

---

## 3. Install Multimedia Codecs via `opi`

The easier route to codecs is `opi` (OBS Package Installer), which is available in the main repos:

```bash
sudo zypper install opi
```

Then just run:

```bash
opi codecs
```

This automatically adds Packman, installs the right codec packages, and handles vendor switching for you. It's the recommended method if you don't want to deal with manual repo management.

After installing codecs, test playback:

```bash
sudo zypper install vlc mpv
```

---

## 4. Set Up Flatpak and Flathub

Tumbleweed includes Flatpak in its repos. Install it and add the Flathub remote:

```bash
sudo zypper install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

If you're on **KDE Plasma**, Discover already has Flatpak backend support. If you're on **GNOME**, install the plugin:

```bash
sudo zypper install gnome-software-plugin-flatpak
```

Log out and back in (or reboot) for the Flathub integration to appear in your software center.

---

## 5. Install NVIDIA Drivers

openSUSE makes NVIDIA driver installation straightforward via the official NVIDIA repository.

### Add the NVIDIA repo

```bash
sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
sudo zypper refresh
```

### Install the driver

```bash
sudo zypper install-new-recommends --repo NVIDIA
```

Or install explicitly:

```bash
sudo zypper install nvidia-glG06 nvidia-computeG06 nvidia-gfxG06-kmp-default
```

> [!NOTE]
> The `G06` suffix covers current-generation cards (RTX 20-series and newer). Older cards may need `G05` or `G04`. Check the NVIDIA repo listing to confirm the right package for your GPU generation.

Reboot after installation:

```bash
sudo reboot
```

Verify the driver is loaded:

```bash
nvidia-smi
```

### For AMD and Intel GPUs

Mesa drivers are installed by default on Tumbleweed. AMD and Intel users generally don't need to do anything extra — `amdgpu` and `i915` are already in the kernel.

---

## 6. Configure the Firewall with firewalld

openSUSE uses **firewalld** by default, and it's enabled out of the box. You can manage it with the `firewall-cmd` CLI or through **YaST Firewall**.

Check current status:

```bash
sudo firewall-cmd --state
```

List active zones:

```bash
sudo firewall-cmd --get-active-zones
```

Allow a service (e.g., SSH):

```bash
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

For most desktop users, the defaults are fine. The GUI approach through **YaST → Security → Firewall** is also solid if you prefer clicking over typing.

---

## 7. YaST: Your Swiss Army Knife

**YaST** (Yet another Setup Tool) is what sets openSUSE apart from other distros. It's a powerful system management UI that handles almost everything:

- **Software Management** — GUI for zypper
- **Online Update** — equivalent of `zypper up`
- **Network Settings** — static IPs, Wi-Fi, VPN
- **User and Group Management**
- **Bootloader Configuration** — tweak GRUB without editing text files
- **Partitioner** — resize, format, manage disks
- **Printer Setup**

Access it from the application menu, or run:

```bash
sudo yast2
```

For terminal-only environments, use the ncurses version:

```bash
sudo yast
```

Get comfortable with YaST — it saves a lot of time on tasks that would require editing config files by hand on other distros.

---

## 8. Snapper Snapshots Are Already Set Up

Tumbleweed comes with **Snapper** pre-configured for automatic Btrfs snapshots. Every time you install, update, or remove packages with zypper, a before/after snapshot pair is created automatically.

Check existing snapshots:

```bash
sudo snapper list
```

Create a manual snapshot:

```bash
sudo snapper create --description "before big changes"
```

Roll back to a previous snapshot (the number comes from `snapper list`):

```bash
sudo snapper rollback 5
```

> [!IMPORTANT]
> Rolling back boots you into the selected snapshot. After reboot, run `sudo snapper rollback` without arguments to confirm the rollback permanently, or it'll revert on the next boot.

The GRUB bootloader also lists snapshots at boot time — so even if your system won't boot, you can select an older working snapshot right from the boot menu. This is one of Tumbleweed's biggest practical advantages over other rolling releases.

---

## 9. Desktop Environment Tweaks

### KDE Plasma

KDE is the default desktop on Tumbleweed and it's very well integrated. A few things worth doing:

Install KDE Connect to link your Android or iOS device:

```bash
sudo zypper install kdeconnect-kde
```

Enable Wayland session if you're still on X11 — select **Plasma (Wayland)** from the login screen session menu. Tumbleweed ships a well-tested Wayland stack.

Adjust global scale for HiDPI displays via **System Settings → Display & Monitor → Display Configuration**.

### GNOME

If you installed the GNOME variant:

```bash
sudo zypper install gnome-tweaks
```

Install the Extension Manager from Flathub for a better extension experience:

```bash
flatpak install flathub com.mattjakeman.ExtensionManager
```

---

## 10. Install Essential CLI Tools

A handful of tools that make Tumbleweed life more comfortable:

```bash
sudo zypper install \
  git \
  curl \
  wget \
  htop \
  btop \
  fastfetch \
  neovim \
  tmux \
  zsh \
  ripgrep \
  fd \
  bat \
  eza
```

Switch to Zsh if you prefer it:

```bash
chsh -s /bin/zsh
```

Install **Oh My Zsh** for a decent out-of-the-box shell experience:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

## 11. Install Everyday Applications

### Via zypper

```bash
sudo zypper install \
  vlc \
  mpv \
  libreoffice \
  gimp \
  inkscape \
  gparted
```

### Via Flatpak (Flathub)

```bash
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub io.github.kolunmi.Bazaar -y
```

---

## 12. Keep the System Updated

On a rolling release, regular updates matter. Make it a habit:

```bash
sudo zypper refresh && sudo zypper dist-upgrade
```

You can also use **YaST Online Update** for a GUI approach, or enable automatic updates through **YaST → System → Online Update Configuration**.

> [!NOTE]
> The [openSUSE Tumbleweed snapshot review](https://review.tumbleweed.boombatower.com/) gives you a quick at-a-glance view of snapshot quality before you update. Useful if you've had bad luck with a particular snapshot.

---

With these steps done, your Tumbleweed system is properly configured, secure, and set up for the long haul. The combination of Snapper rollbacks, YaST, and a well-tested rolling cadence makes it one of the most comfortable rolling distros to actually live in day-to-day.
