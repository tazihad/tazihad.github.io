---
title: "How to Transfer Files to Steam Deck Wirelessly (LocalSend & SSH Guide)"
description: "Stop unplugging USB flash drives. Learn the fastest, easiest ways to transfer ROMs, mods, and game files wirelessly from Windows, Mac, or Linux to your Steam Deck using LocalSend and SSH/SFTP."
date: 2026-09-23 10:00:00 +0600
categories: [gaming, steam-deck]
tags: [steam deck, steamos, gaming, ssh, localsend, wireless, linux, transfer]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-09-23-how-to-transfer-files-to-steam-deck-wirelessly/banner.webp
  lqip: data:image/webp;base64,UklGRlgAAABXRUJQVlA4IEwAAABQAwCdASoUAAsALmlIpFIiJaWlhYBoS0gABc6KtHJP0KIQAAD++pix4pxRz0FUidBPwxOf/X4F+fbxNN+mshPyscJSJfJoEv+ElwAA
  alt: Steam Deck handheld gaming PC for wireless file transfer
---

In our previous guide on [how to mount an ISO on the Steam Deck](https://zihad.com.bd/posts/how-to-mount-iso-steam-deck/), we explored how SteamOS’s underlying Linux foundation unlocks massive flexibility. But before you can mount ISOs, install game mods, or manage emulation ROMs, you first have to get those large files onto the device.

Constantly plugging and unplugging USB-C thumb drives or swapping MicroSD cards is tedious and can wear out your ports.

Here are the two best, fastest methods to transfer files wirelessly over your local Wi-Fi network between your PC (Windows, Mac, or Linux) and your Steam Deck.

---

## Method 1: LocalSend (Easiest, Zero Setup, Open Source)

**LocalSend** is a free, open-source cross-platform file sharing tool that works like Apple AirDrop over your local Wi-Fi network. It requires no accounts, no command line, and no password setup.

### Step 1: Install LocalSend on Steam Deck
1. Switch to **Desktop Mode** (Press the `STEAM` button > **Power** > **Switch to Desktop**).
2. Open the **Discover Software Center**.
3. Search for **LocalSend** and click **Install**.

### Step 2: Install LocalSend on Your PC
Download the official client on your main computer:
- Windows: Available on the Microsoft Store, winget (`winget install localsend`), or [localsend.org](https://localsend.org).
- macOS / Linux: Available via Homebrew, DMG, or Flathub.

### Step 3: Send Files
1. Open LocalSend on both your computer and your Steam Deck (ensure both devices are connected to the same Wi-Fi network).
2. On your PC, click **Send** > **File** or **Folder** and choose your games, ISOs, or mod archives.
3. Your Steam Deck will appear in the nearby devices list. Click it.
4. On the Steam Deck, tap **Accept**.
5. Transferred files save to your Deck's `Downloads` folder by default.

> [!TIP]
> You can also add LocalSend as a non-Steam game in Desktop Mode so you can launch it directly inside **Gaming Mode** without switching to Desktop!

---

## Method 2: SSH & SFTP (Best for Power Users & Large Transfers)

If you regularly transfer gigabytes of ROMs, emulator saves, or custom game files, enabling the native OpenSSH server on SteamOS gives you a persistent file browser inside **FileZilla**, **WinSCP**, or VS Code.

### Step 1: Set a Password for User `deck`
By default, the Steam Deck’s `deck` user has no password set. Open the **Konsole** terminal in Desktop Mode and set one:

```bash
passwd
```

Enter a secure password and confirm it. *(Keep this password safe—it also acts as your `sudo` root password on the Deck).*

### Step 2: Enable and Start the SSH Service
In Konsole, start the SSH daemon:

```bash
sudo systemctl enable --now sshd
```

### Step 3: Find Your Steam Deck’s Local IP Address
Run:

```bash
ip -br a
```

Look for `wlan0` (e.g., `192.168.1.145`).

### Step 4: Connect from Your PC via FileZilla or WinSCP
1. On your PC, open **FileZilla** or **WinSCP**.
2. Create a new **SFTP** connection with the following credentials:
   - **Protocol:** `SFTP - SSH File Transfer Protocol`
   - **Host:** Your Steam Deck's IP address (e.g., `192.168.1.145`)
   - **Port:** `22`
   - **Username:** `deck`
   - **Password:** The password you set in Step 1.
3. Click **Connect** and accept the host key fingerprint prompt.

---

## Important Steam Deck File Paths to Bookmark

Once connected via SFTP or using the Dolphin file manager, here are the most important directory paths on SteamOS:

- **Internal Storage Games:**
  `/home/deck/.local/share/Steam/steamapps/common/`
- **MicroSD Card Games:**
  `/run/media/mmcblk0p1/steamapps/common/`
- **Emulation ROMs (Emudeck):**
  `/run/media/mmcblk0p1/Emulation/roms/` (or `/home/deck/Emulation/roms/`)
- **Proton Compatibility Prefixes (Saves / Windows AppData):**
  `/home/deck/.local/share/Steam/steamapps/compatdata/<AppID>/pfx/drive_c/`

*(Note: Folders starting with a dot like `.local` are hidden. In Dolphin, press `Ctrl + H` to reveal hidden files).*
