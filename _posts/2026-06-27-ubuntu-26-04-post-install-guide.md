---
title: "Top 10 Things to Do After Installing Ubuntu 26.04 LTS"
description: A complete step-by-step post-installation guide for Ubuntu 26.04 LTS (Resolute Raccoon) to set up your system for development, gaming, and daily use.
date: 2026-06-27 17:10:00 +0600
categories: [linux, ubuntu]
tags: [linux, ubuntu, tutorial, post-install]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: /assets/images/2026-06-27-ubuntu-26-04-post-install-guide/banner.webp
  lqip: data:image/webp;base64,UklGRlQAAABXRUJQVlA4IEgAAADwAwCdASoUAAsAP3Ggxli0q6ejsAgCkC4JZQC+SBukLqFsxlu6vv4AAP7ZT0Nw180AcsjcpOd1squzNVrZBq+XqLh868aAAAA=
  alt: Ubuntu 26.04 LTS post install guide banner featuring the Ubuntu logo and installation HUD.
---

Ubuntu 26.04 LTS (**Resolute Raccoon**) has arrived, bringing a polished GNOME desktop experience, updated Linux kernel, improved security profiles, and long-term support for the next five years. 

While the default installation is functional out of the box, you can significantly improve your daily workflow, system performance, and visual aesthetics with a few post-installation configurations.

Here is a step-by-step guide to the top 10 things you should do after installing Ubuntu 26.04 LTS.

---

## 1. Update and Upgrade System Repositories

Before changing any settings or installing apps, ensure your system package manager is fully up-to-date and any security patches are applied.

Open your terminal (`Ctrl + Alt + T`) and run the following command:

```bash
sudo apt update && sudo apt upgrade -y
```

If a kernel upgrade is performed, restart your system to apply the updates:

```bash
sudo reboot
```

---

## 2. Enable Restricted and Multiverse Repositories

By default, Ubuntu enables free and open-source software repositories. To install proprietary drivers, third-party software, and patent-encumbered media codecs, you should enable the `restricted` and `multiverse` repositories.

Run these commands to add the repositories and update the system:

```bash
sudo add-apt-repository restricted
sudo add-apt-repository multiverse
sudo apt update
```

---

## 3. Install Essential Media Codecs

Due to copyright and patent restrictions in various countries, Ubuntu does not bundle codecs for proprietary audio/video formats (like MP3, MP4, AAC, and H.264) by default.

To play all media files without issues, install the Ubuntu restricted extras package:

```bash
sudo apt install ubuntu-restricted-extras -y
```

> [!NOTE]
> During installation, a Microsoft EULA license agreement prompt will appear. Use the `Tab` key to highlight **OK** or **Yes**, then press `Enter` to accept and proceed.

---

## 4. Setup Flatpak and Flathub Integration

While Canonical pushes its native **Snap** package format, the Linux community heavily uses **Flatpak** via **Flathub** due to faster startup times and a broader repository of community-managed software.

To configure Flatpak support alongside Snap:

1. Install Flatpak:
   ```bash
   sudo apt install flatpak -y
   ```
2. Install the GNOME Software Flatpak plugin (makes search and click-to-install work in the App Store):
   ```bash
   sudo apt install gnome-software-plugin-flatpak -y
   ```
3. Add the Flathub repository:
   ```bash
   flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
   ```

Restart your system to complete the Flathub integration.

---

## 5. Install NVIDIA Proprietary Drivers (If Applicable)

If you have a dedicated NVIDIA GPU, using the default open-source *Nouveau* driver will bottleneck gaming, machine learning, and hardware video decoding performance.

To install the official, proprietary NVIDIA drivers:

1. Open the **Software & Updates** app from the application menu.
2. Select the **Additional Drivers** tab.
3. Choose the latest recommended NVIDIA proprietary driver (e.g., `nvidia-driver-xxx`).
4. Click **Apply Changes** and reboot your PC when finished.

Alternatively, you can install the driver from the CLI:

```bash
sudo ubuntu-drivers install
```

---

## 6. Customize the GNOME Desktop (Tweaks and Extensions)

Ubuntu 26.04 uses the GNOME desktop environment. To unlock advanced desktop customization (changing themes, mouse acceleration, windows behavior, and menu layouts), install GNOME Tweaks:

```bash
sudo apt install gnome-tweaks gnome-shell-extension-manager -y
```

Once installed, open **Extension Manager** to search and install helpful user extensions like:
*   **Dash to Dock** or **Dash to Panel** for alternative dock/taskbar alignments.
*   **Caffeine** to prevent your computer from going to sleep during presentation or compilation tasks.
*   **Just Perfection** to toggle UI elements off and customize animations.

---

## 7. Optimize Laptop Battery and Heat Management

If you installed Ubuntu 26.04 on a laptop, you can improve battery life and prevent thermal throttling by configuring battery daemon tools. 

Ubuntu 26.04 comes with `power-profiles-daemon` built-in, but power users on older laptops might prefer the robust optimization options provided by `TLP`. 

To install and activate TLP:

```bash
sudo apt install tlp tlp-rdw -y
sudo tlp start
```

Verify TLP is running successfully:

```bash
tlp-stat -s
```

---

## 8. Setup Firewall and Security Hardening

Security should be a priority. Ubuntu comes with a built-in firewall manager called `ufw` (Uncomplicated Firewall), but it is disabled by default.

To enable the firewall and block unauthorized incoming connections:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

To verify the status of your firewall rules:

```bash
sudo ufw status verbose
```

---

## 9. Install Everyday Essential Apps

With repositories, Flatpak, and Snap set up, you can install your daily driver applications. Here is a quick terminal command to install common utilities:

```bash
# General Tools
sudo apt install curl git vlc build-essential gparted -y

# Flatpak Apps (from Flathub)
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub org.mozilla.Thunderbird -y
flatpak install flathub org.telegram.desktop -y
```

---

## 10. Clean Up Unused Packages and Cache

After setting up your system and installing all necessary apps, tidy up system repositories and free up disk space by removing leftover dependencies:

```bash
sudo apt autoremove -y
sudo apt clean
flatpak uninstall --unused -y
```

---

## Conclusion

Your Ubuntu 26.04 LTS (Resolute Raccoon) environment is now fully updated, secure, optimized for performance, and ready for work, development, or entertainment. 

What are your favorite post-install configurations or extensions? Let us know in the comments below!
