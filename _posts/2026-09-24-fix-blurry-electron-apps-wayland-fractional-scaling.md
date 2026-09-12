---
title: "How to Fix Blurry Electron Apps on Wayland (VS Code, Discord, Spotify, Chrome)"
description: "Tired of blurry text in VS Code, Discord, and Chrome when using fractional scaling on Wayland? Here is how to force native Wayland rendering with Ozone flags, Flatpak overrides, and global environment variables."
date: 2026-09-24 10:00:00 +0600
categories: [linux, wayland]
tags: [wayland, electron, fractional-scaling, vscode, discord, chrome, spotify, linux]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-09-24-fix-blurry-electron-apps-wayland-fractional-scaling/banner.webp
  lqip: data:image/webp;base64,UklGRpQAAABXRUJQVlA4IIgAAAAwBACdASoUAAsAPpE6l0eloyIhMAgAsBIJZACdACG8blC4DKeTYCiC6SAA+X711FSUtrfgz375TqwQx6Uymg+XCRmiwTRqhCwoZpUn6+Fq5sRaCf6k9lQ+YHXTJ4Yg0yI9MgAg8+D4MFeQhwpm22FopfV/CudDSvJF3D2dHm2uxtxq+tUgNAAA
  alt: Modern developer laptop running crisp code editor on Linux Wayland
---

If you use fractional display scaling (such as 125%, 150%, or 175%) on modern Linux desktops running Wayland (GNOME 46/48 or KDE Plasma 6), you have almost certainly noticed that native GTK and Qt apps look razor sharp, while applications like **VS Code, Discord, Spotify, Slack, Obsidian, and Google Chrome** look fuzzy and pixelated.

This blurriness is not a bug in your graphics drivers. It happens because Chromium and Electron applications default to running through **XWayland** (the X11 backward compatibility layer). When fractional scaling is active, the Wayland compositor renders XWayland apps at a higher integer resolution and scales them back down like a bitmap image.

Here is how to force Electron and Chromium apps to run natively on Wayland with crisp, pixel-perfect text rendering.

---

## The Magic Fix: Ozone Platform Flags

Chromium and modern Electron (versions 28+) include built-in support for Wayland via the **Ozone** abstraction layer. You simply need to instruct the application to prefer Wayland over X11:

```bash
--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations
```

---

## 1. Fix VS Code Permanently

You don't need to modify `.desktop` launcher files every time VS Code updates. VS Code includes a persistent runtime configuration file.

1. Open VS Code.
2. Open the Command Palette (`Ctrl + Shift + P`).
3. Type and select: **Preferences: Configure Runtime Arguments** (this opens `~/.vscode/argv.json`).
4. Add the following key-value pairs:

```json
{
  "ozone-platform": "wayland",
  "enable-features": "WaylandWindowDecorations"
}
```

5. Save the file and restart VS Code. Your text, sidebar icons, and terminal will immediately render with native HiDPI clarity.

---

## 2. Set Global Environment Variable for All Electron Apps

Starting with Electron 28, apps check for the `ELECTRON_OZONE_PLATFORM_HINT` environment variable. Setting this globally enables native Wayland for any compliant Electron app automatically.

Create or edit your user environment configuration:

```bash
mkdir -p ~/.config/environment.d
nano ~/.config/environment.d/wayland-electron.conf
```

Add the following line:

```ini
ELECTRON_OZONE_PLATFORM_HINT=auto
```

Log out and log back in to activate the variable.

---

## 3. Fix Flatpak Apps (Discord, Spotify, Obsidian, Slack)

Flatpaks run inside sandboxes that often block direct access to the Wayland display socket by default, forcing them back to XWayland.

### Option A: Using Flatseal (GUI)
1. Open **Flatseal** (install from Flathub if not present: `flatpak install flathub com.github.tchx84.Flatseal`).
2. Select your application (e.g., **Discord** or **Spotify**).
3. Scroll to **Socket**:
   - Enable **Wayland windowing system (`wayland`)**.
   - Disable **X11 windowing system (`x11`)** if you want to force pure Wayland.
4. Scroll to **Environment**:
   - Click `+` and add: `ELECTRON_OZONE_PLATFORM_HINT=auto`.

### Option B: Terminal Command Overrides (CLI)
Apply the override directly via terminal:

```bash
# For Discord
flatpak override --user --socket=wayland --env=ELECTRON_OZONE_PLATFORM_HINT=auto com.discordapp.Discord

# For Spotify
flatpak override --user --socket=wayland --env=ELECTRON_OZONE_PLATFORM_HINT=auto com.spotify.Client

# For Obsidian
flatpak override --user --socket=wayland --env=ELECTRON_OZONE_PLATFORM_HINT=auto md.obsidian.Obsidian
```

---

## 4. Fix Google Chrome, Brave, and Microsoft Edge

Chromium browsers can read persistent launch flags from a dedicated config file in your user directory.

Create the matching flags file for your browser:

### For Google Chrome:
```bash
echo "--ozone-platform-hint=auto" >> ~/.config/chrome-flags.conf
```

### For Brave Browser:
```bash
echo "--ozone-platform-hint=auto" >> ~/.config/brave-flags.conf
```

### For Chromium:
```bash
echo "--ozone-platform-hint=auto" >> ~/.config/chromium-flags.conf
```

Restart your browser.

---

## How to Verify Native Wayland Execution

To confirm an application is running natively under Wayland rather than through XWayland:

1. Open a terminal and run:
   ```bash
   xlsclients
   ```
2. If the application is **absent** from `xlsclients` output, it is running natively on **Wayland**.
3. If it appears in `xlsclients`, it is still routing through XWayland.

Alternatively, in GNOME, press `Alt + F2`, type `lg` (Looking Glass), go to **Windows**, and verify that the target application has `Window type: Wayland` rather than `X11`.
