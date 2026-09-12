---
title: "CachyOS Post-Install & Gaming Tuning Guide: Official Wiki Optimizations"
description: "Configure and fine-tune your fresh CachyOS installation for maximum gaming throughput and responsiveness. Covers mirror ranking, kernel selection, gaming meta-packages, Proton-CachyOS anti-cheat setup, game-performance wrapper, shader cache expansion, and sched-ext integration."
date: 2026-09-15 10:00:00 +0600
categories: [linux, cachyos]
tags: [linux, cachyos, arch, gaming, kernel, bore, sched-ext, proton, wayland]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-09-15-cachyos-post-install-guide/banner.webp
  lqip: data:image/webp;base64,UklGRrYAAABXRUJQVlA4IKoAAADwBACdASoUAAsAPpE4l0eloyIhMAgAsBIJQBWGUJclF02+chjVQaEh1l8eDlkp1MAA/rteZjEU8NgQj3kdF+vB1UJ99erOKhfffTMwhGtyS/xrpGm/KCHp4IM5ly2fsQZSTZ5sR1tWrZUnADH3fPKnWYooWDHVEGsUiy7vg+2wsFoIViUDVph/zsffmo6G/QiAIQTumVb6m/k1+/vMeltiPP6jwdkTVrDgAA==
  alt: CachyOS gaming configuration and performance tuning
---

CachyOS is an Arch-based distribution engineered for low-latency desktop performance and gaming throughput. It ships packages compiled with aggressive optimizations (`-O3`, LTO, `x86-64-v3/v4`), custom kernels with schedulers like BORE and sched-ext (`scx`), and an extensive gaming ecosystem.

Drawing directly from the [official CachyOS Gaming Wiki](https://wiki.cachyos.org/configuration/gaming/), this guide walks through the essential post-install steps and performance configurations to get the most out of your hardware.

---

## 1. Rank CachyOS Mirrors and Update System

CachyOS hosts its own optimized repositories in addition to upstream Arch mirrors. Always benchmark and rank your mirrors immediately after installation:

```bash
sudo cachyos-rate-mirrors
sudo pacman -Syu
```

Reboot if a new kernel or system library was updated:

```bash
sudo reboot
```

---

## 2. Select the Right CachyOS Kernel

CachyOS provides several kernels fine-tuned for different scheduling behavior:

```bash
# Graphical kernel selector and manager
cachyos-kernel-manager
```

Via CLI:
- **`linux-cachyos`** (Default): Uses the BORE (Burst-Oriented Response Enhancer) scheduler. Best for general desktop responsiveness and gaming.
- **`linux-cachyos-sched-ext`**: Includes support for BPF-based `scx` schedulers (like `scx_lavd`, `scx_rusty`, or `scx_bpfland`), dynamically swappable in userspace.
- **`linux-cachyos-eevdf`**: Standard upstream Linux scheduler with CachyOS compiler and memory patches.

To install a kernel and its matching headers:

```bash
sudo pacman -S linux-cachyos linux-cachyos-headers
```

---

## 3. Install the Official Gaming Meta-Packages

CachyOS splits gaming software into two focused packages: libraries/backends and user applications:

### Step 1: Core Gaming Stack (`cachyos-gaming-meta`)
Installs Wine dependencies, 32-bit graphics libraries, Vulkan loaders, Gamemode, and Proton dependencies:

```bash
sudo pacman -S cachyos-gaming-meta
```

### Step 2: Gaming Applications (`cachyos-gaming-applications`)
Installs launchers and diagnostic tools (Steam, Lutris, Heroic Games Launcher, MangoHud, Gamescope, and GOverlay):

```bash
sudo pacman -S cachyos-gaming-applications
```

*(Alternatively, open **CachyOS Hello > Apps/Tweaks** and click **Install Gaming packages** to install both).*

---

## 4. Choose the Right Proton Flavor and Fix Anti-Cheat

CachyOS maintains custom Proton builds featuring bleeding-edge Wine-staging patches, Wine Fullscreen FSR, cutscene video/audio decoders, and default NTSync support.

### Proton Packages
- **`proton-cachyos-slr` (Recommended):** Built against the Steam Linux Runtime. **Use this version for games using Easy Anti-Cheat (EAC) or BattlEye (BE)** to prevent server kicks and authentication drops.
- **`proton-cachyos-native`:** Built directly against host system libraries.

```bash
sudo pacman -S proton-cachyos-slr
```

### Steam Configuration Best Practices
The CachyOS team strongly recommends keeping **Valve's official Proton (or Proton Experimental)** as your global default in Steam, and enabling custom Proton versions on a per-game basis:

1. In Steam, open **Settings > Compatibility**.
2. Keep the default tool set to **Proton Experimental** or the latest stable Valve release.
3. For games needing custom hotfixes or extra performance, right-click the specific game in your Library > **Properties > Compatibility**, check **Force the use of a specific Steam Play compatibility tool**, and choose **Proton-CachyOS-SLR**.

> [!TIP]
> If a game stutters or has synchronization bugs with NTSync, disable it for that title by adding `PROTON_NO_NTSYNC=1 %command%` to the game's Launch Options.

---

## 5. Master Steam Launch Options Syntax

When configuring wrappers and environment variables in Steam, adhere to the standard launch option format:

```text
[env variables] [wrappers] %command% [application arguments]
```

### Practical Examples:
- **Run with performance wrapper and MangoHud:**
  ```text
  mangohud game-performance %command%
  ```
- **Force DirectX 11 backend:**
  ```text
  game-performance %command% -dx11
  ```
- **Run inside Gamescope with FSR upscaling:**
  ```text
  gamescope -W 1920 -H 1080 -w 1280 -h 720 -S fit -F fsr --mangoapp -- %command%
  ```

---

## 6. Use `game-performance` Wrapper (On-Demand Performance Profile)

CachyOS includes a custom wrapper script called `game-performance`. It uses `power-profiles-daemon` to dynamically:
- Switch the system power profile and CPU governor to **performance**.
- Switch any active `scx` scheduler to its gaming profile.
- Automatically revert back to your previous balanced/powersave profile when the game closes.

### How to use it:
- **Steam:** Add `game-performance %command%` to the game's Launch Options.
- **Heroic Games Launcher:** Go to **Settings > Game Defaults > Advanced > Wrapper command** and enter `game-performance`.
- **Lutris:** Open **Preferences > Global options > Command prefix** and enter `game-performance`.

---

## 7. Performance Warning: Do NOT Combine Gamemode and Ananicy-CPP

CachyOS enables `ananicy-cpp` (auto-nice daemon) by default to balance CPU priorities dynamically.

> [!WARNING]
> **Do not run both `gamemode` and `ananicy-cpp` simultaneously.** Both utilities attempt to adjust process niceness and CPU affinity at the same time, leading to scheduling race conditions and frame stutters.

- If you rely on `ananicy-cpp` (default on CachyOS), do **not** add `gamemoderun` to your game launch commands.
- If you specifically need `gamemode` for custom launch scripts, stop `ananicy-cpp` first:
  ```bash
  sudo systemctl stop ananicy-cpp
  ```

To ensure `ananicy-cpp` rules are up to date:

```bash
sudo systemctl enable --now ananicy-cpp
sudo ananicy-cpp-community-rules-sync
```

---

## 8. Expand Global Shader Cache Size to Eliminate Stutter

By default, graphics drivers set conservative limits on disk shader caches. When large modern games exceed this limit, older shaders are deleted, forcing real-time compilation and severe micro-stuttering on subsequent launches.

Increase the global shader cache cap to 12GB:

1. Create the environment configuration directory:
   ```bash
   mkdir -p ~/.config/environment.d
   ```
2. Create or edit `~/.config/environment.d/gaming.conf`:
   ```bash
   micro ~/.config/environment.d/gaming.conf
   ```
3. Add the appropriate variable for your GPU:

**For AMD (Mesa):**
```ini
MESA_SHADER_CACHE_MAX_SIZE=12G
```

**For NVIDIA:**
```ini
__GL_SHADER_DISK_CACHE_SIZE=12000000000
```

4. Save the file and restart your user session.

---

## 9. Setting Up Wine-CachyOS for Lutris & Heroic

For running non-Steam games inside Lutris, Bottles, or Heroic, CachyOS provides standalone Wine builds.

CachyOS offers two packages:
- **`wine-cachyos`**: Replaces the system Wine binary.
- **`wine-cachyos-opt` (Recommended)**: Installs to `/opt/wine-cachyos`, allowing gaming patches to co-exist with standard `wine` or `wine-staging` without breaking desktop applications.

```bash
sudo pacman -S wine-cachyos-opt
```

In Lutris:
1. Open **Preferences > Runners > Wine**.
2. Point the Wine binary path to `/opt/wine-cachyos/bin/wine`.
3. In **Runner Options**, enable **DXVK** and set **Disable Lutris Runtime** to enabled (preferring optimized system libraries).

---

## 10. Enable Wayland VRR and HDR

### KDE Plasma 6:
1. Open **System Settings > Display Configuration**.
2. Set **Adaptive Sync** to **Always** or **Automatic**.
3. Toggle **High Dynamic Range (HDR)** if supported by your panel.

### Hyprland:
Add to `~/.config/hypr/hyprland.conf`:
```ini
misc {
    vrr = 1
}
```

---

## 11. System Maintenance Checklist

Keep package caches clean and prune orphan libraries:

```bash
# Prune pacman cache to the last 2 versions
sudo paccache -r

# Remove unneeded orphaned dependencies
sudo pacman -Qtdq | sudo pacman -Rns -
```
