---
title: "Fedora 45 Post-Install Guide: Everything You Need to Set Up a Perfect System"
description: "Just installed Fedora 45? This complete post-install guide covers system updates, RPM Fusion, codecs, Flatpak, NVIDIA drivers, fonts, gaming, and daily-use tweaks to get your Fedora setup running at its best."
date: 2026-09-10 14:09:00 +0600
categories: [linux, fedora]
tags: [linux, fedora, fedora 45, post-install, dnf, rpm-fusion, flatpak, nvidia, gaming]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-09-10-fedora-45-post-install-guide/banner.webp
  lqip: data:image/webp;base64,UklGRtAAAABXRUJQVlA4IMQAAAAQBQCdASoUAAsAPpE4l0eloyIhMAgAsBIJbACdMoMYLIAKe4VwRrynbxFPCafc1rygAP7yc7EaBFpuLodGXA0edPEu5a1oV3C2jre5ZR6P5qIgc5r1HSuwseKU4ivk1Vkp1bgkR1lRDetnQWQJde5HIcoiiySj124SUGmMgxM8YbVylmuKGERHOqpFyMMfYd7Zla5Dtgz9C0f44b+sP8uw6753CvB7O71VP5pxSwOgg01p3QYdPRmjGATzhCAnn1A2wfoA
  alt: Fedora 45 desktop after a fresh install
---

Fedora 45 is out, and it ships with a freshly updated kernel, a polished GNOME 48 desktop, and plenty of under-the-hood improvements. But right after the installer reboots, there are a handful of things you will want to do before you actually start using the system day-to-day.

This guide walks through everything — from the first `dnf` command you should run, to setting up RPM Fusion, getting proprietary codecs, enabling Flatpak, installing NVIDIA drivers, and tweaking the desktop. No bloat, just the stuff that matters.

---

## 1. Update the System First

Before anything else, pull in the latest package updates and kernel patches.

```bash
sudo dnf upgrade --refresh -y
```

If a new kernel was installed, reboot to load it:

```bash
sudo reboot
```

After reboot, update your firmware as well. Many laptops and some desktops have firmware updates available through `fwupd`:

```bash
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update
```

---

## 2. Speed Up DNF

Fedora's package manager is solid, but it can feel slow on the first run after a fresh install. Open the DNF configuration file and add these two options:

```bash
sudo nano /etc/dnf/dnf.conf
```

Add to the bottom of the `[main]` section:

```ini
max_parallel_downloads=10
fastestmirror=True
```

This tells DNF to download up to 10 packages at once and pick the fastest available mirror. Save and close the file. You will notice the difference immediately on the next upgrade.

---

## 3. Enable RPM Fusion Repositories

Fedora, by design, only ships free and open-source software in its default repositories. This means no H.264 codec, no proprietary drivers, and no ffmpeg with restricted format support right out of the box.

RPM Fusion fills that gap. It is split into two repositories — `free` (open-source but not part of Fedora's guidelines) and `nonfree` (proprietary software). Enable both:

```bash
sudo dnf install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

Then update the AppStream metadata so your software center picks up the new repositories:

```bash
sudo dnf update @core
```

---

## 4. Install Multimedia Codecs

Fedora ships a restricted version of FFmpeg called `ffmpeg-free` that strips out H.264 and H.265 support due to US patent law. Once RPM Fusion is enabled, you have two ways to fix this.

### Option A — Install libavcodec-freeworld (Recommended)

This adds the missing H.264/H.265 decoders on top of the existing `ffmpeg-free` without replacing any system libraries. It is the cleanest approach:

```bash
sudo dnf install libavcodec-freeworld
```

### Option B — Replace ffmpeg entirely

If you want the full ffmpeg binary for encoding, streaming, or conversion tasks:

```bash
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
```

### GStreamer plugins for GNOME apps

GNOME Videos, Rhythmbox, and other GTK apps rely on GStreamer. The default plugins only handle open formats. Install the full set:

```bash
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
```

### OpenH264 from Cisco

Cisco pays the patent licensing fees for a specific H.264 implementation and distributes it for free. You can enable it as an additional fallback:

```bash
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf install mozilla-openh264 gstreamer1-plugin-openh264
```

---

## 5. Set Up Flatpak and Flathub

Fedora 45 includes Flatpak by default, but the Flathub repository is not added out of the box. Add it now:

```bash
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Restart your session (or reboot) to apply the changes. After that, install apps directly from Flathub either through GNOME Software or the terminal.

Some useful apps to grab right away:

```bash
# Web browser
flatpak install flathub com.brave.Browser

# Communication
flatpak install flathub org.signal.Signal
flatpak install flathub org.telegram.desktop
flatpak install flathub com.discordapp.Discord

# Media
flatpak install flathub org.videolan.VLC

# Development
flatpak install flathub com.visualstudio.code

# Flatpak permission manager
flatpak install flathub com.github.tchx84.Flatseal
```

---

## 6. Install NVIDIA Drivers

The open-source Nouveau driver that ships by default with Fedora does not support CUDA, hardware video decoding, or proper gaming performance. Here is how to install the official NVIDIA driver from RPM Fusion.

> [!IMPORTANT]
> Make sure RPM Fusion nonfree is enabled before running these commands (covered in Step 3).

Install the kernel module and CUDA libraries:

```bash
sudo dnf install akmod-nvidia
sudo dnf install xorg-x11-drv-nvidia-cuda
```

After installing, **wait at least 5 minutes** before rebooting. The `akmods` service builds the kernel module in the background. Rebooting too early will result in a black screen or fallback display mode.

Verify the driver loaded correctly after reboot:

```bash
nvidia-smi
```

### Hardware-accelerated video decoding with NVIDIA

```bash
sudo dnf install libva-nvidia-driver
```

For gaming with Steam or Wine (needs 32-bit support too):

```bash
sudo dnf install libva-nvidia-driver.{i686,x86_64}
```

---

## 7. Hardware Acceleration for Intel and AMD GPUs

If you do not have an NVIDIA card, you still want hardware-accelerated video decoding for smooth 4K playback and reduced CPU load.

### Intel (Gen 8 / Broadwell and newer — 2015 and later)

Covers Skylake, Kaby Lake, Coffee Lake, Tiger Lake, and Intel Arc:

```bash
sudo dnf install intel-media-driver
```

### Intel (Gen 7.5 / Haswell and older — 2014 and earlier)

Covers Haswell, Ivy Bridge, Sandy Bridge:

```bash
sudo dnf install libva-intel-driver
```

Not sure which generation your CPU is? Check with:

```bash
lscpu | grep "Model name"
```

### AMD GPUs

Fedora's default Mesa build removes H.264/H.265 hardware decode support for legal reasons. Swap in the freeworld versions from RPM Fusion:

```bash
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
```

For 32-bit support (required for Steam and Wine):

```bash
sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
```

---

## 8. Enable and Verify the Firewall

Fedora ships with `firewalld` active by default. You can verify this with:

```bash
sudo firewall-cmd --state
sudo firewall-cmd --get-default-zone
```

The default zone is `FedoraWorkstation`, which blocks unsolicited incoming connections while allowing outgoing traffic. This is a sensible default — leave it as is unless you have a specific reason to change it.

To allow a specific service, for example KDE Connect for phone-to-PC sync:

```bash
sudo firewall-cmd --permanent --add-service=kdeconnect
sudo firewall-cmd --reload
```

---

## 9. Install Microsoft Font Alternatives

If you regularly open documents created on Windows — Word files, PowerPoint presentations — the fonts will look wrong unless you install compatible replacements. Google created metric-compatible substitutes for the two most common Microsoft fonts:

- **Carlito** replaces Calibri
- **Caladea** replaces Cambria

```bash
sudo dnf install 'google-carlito-fonts' 'google-caladea-fonts'
```

These are drop-in replacements that preserve the same character spacing, so documents will look nearly identical to how they appear on Windows.

---

## 10. Set Up Gaming

Fedora is a solid gaming platform. Getting it configured properly takes just a few commands.

### Install Steam

```bash
sudo dnf install steam
```

Inside Steam, go to **Settings → Compatibility** and enable **Steam Play for all titles**. Select the latest Proton version. This lets you run most Windows games through the Proton compatibility layer without any extra work.

### Install Lutris

Lutris manages non-Steam games, GOG titles, Epic Games, and other storefronts:

```bash
sudo dnf install lutris
```

### MangoHud — In-game Performance Overlay

MangoHud overlays FPS, GPU usage, CPU temperature, and frametime directly inside any Vulkan or OpenGL game:

```bash
sudo dnf install mangohud
```

To enable it for a Steam game, add this to the game's launch options:

```
mangohud %command%
```

### GameMode

GameMode temporarily applies performance tweaks when a game is launched — disabling power saving, boosting the CPU governor, and requesting performance mode from the GPU:

```bash
sudo dnf install gamemode
```

Add `gamemoderun %command%` to Steam launch options to enable it per game. You can combine both:

```
gamemoderun mangohud %command%
```

---

## 11. Mount Additional Drives Permanently

If you have a secondary drive or partition you want available at boot, add it to `/etc/fstab`.

Find the UUID of the partition:

```bash
lsblk -f
```

Open `/etc/fstab` and add a line at the bottom:

```
UUID=your-uuid-here  /home/your_user/data  ext4  defaults,noatime,x-gvfs-show  0  0
```

Replace `your-uuid-here` with the actual UUID from `lsblk -f`, and `/home/your_user/data` with whatever mount point you want. The `x-gvfs-show` flag makes the drive appear in the GNOME Files sidebar.

Test the entry without rebooting to make sure there are no typos:

```bash
sudo mount -a
```

If no errors appear, the fstab entry is correct.

---

## 12. Enable Magic SysRq — Emergency Reboot

Every Linux user eventually hits a full system freeze where the mouse stops, the keyboard does nothing, and the system is completely unresponsive. The Magic SysRq key gives you a way to safely reboot even in that state, without holding the power button and risking disk corruption.

Create the sysctl configuration file:

```bash
sudo nano /etc/sysctl.d/90-sysrq.conf
```

Add this line:

```
kernel.sysrq = 1
```

Apply it immediately without rebooting:

```bash
sudo sysctl -p /etc/sysctl.d/90-sysrq.conf
```

When your system freezes, hold **Alt + SysRq** (the Print Screen key on most keyboards) and type the following sequence, one key at a time, with a short pause between each:

**R → E → I → S → U → B**

The mnemonic to remember the order: **Reboot Even If System Utterly Broken**. The system will sync disks and reboot cleanly.

---

## 13. Install Essential CLI Tools

A handful of terminal utilities that are genuinely useful every day:

```bash
sudo dnf install \
  htop \
  fastfetch \
  neovim \
  git \
  curl \
  wget \
  ripgrep \
  fd-find \
  ncdu \
  bat \
  unzip \
  p7zip \
  p7zip-plugins
```

What each one does:

| Package | Purpose |
|---|---|
| `htop` | Interactive process viewer, better than `top` |
| `fastfetch` | System info display, modern neofetch replacement |
| `neovim` | Terminal text editor |
| `ripgrep` | Very fast `grep` replacement |
| `fd-find` | Intuitive `find` replacement |
| `ncdu` | Disk usage analyzer — shows what is eating your storage |
| `bat` | `cat` with syntax highlighting and line numbers |
| `p7zip` | Extract `.7z`, `.rar`, and other archive formats |

---

## 14. Clean Up

After setting everything up, remove unused packages and clear the package cache:

```bash
sudo dnf autoremove -y
sudo dnf clean all
flatpak uninstall --unused -y
```

---

## Done

Your Fedora 45 system is now properly configured for daily use. The non-negotiable steps are enabling RPM Fusion and installing codecs — without those, most video files and streaming sites with H.264 content will not play correctly. Everything else on this list is an improvement worth doing, not a strict requirement.

Got a question or ran into something that did not work on your hardware? Leave a comment below.
