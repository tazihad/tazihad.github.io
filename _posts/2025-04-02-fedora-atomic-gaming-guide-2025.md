---
title: Gaming guide for Fedora Atomic (Silverblue, Kinoite) 2025
description: A 2025 guide for Fedora Atomic gaming.
date: 2025-04-02 16:33:00 +0600
categories: [gaming, silverblue, fedora atomic]
tags: [fedora, gaming, silverblue, kinoite, steam, lutris]
image: 
  path: /assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/fedora-atomic-gaming.webp
  lqip: data:image/webp;base64,UklGRmwAAABXRUJQVlA4IGAAAADwAwCdASoUAAsAPzmEuVOvKKWisAgB4CcJbACdACIOmP806b/MLAAAAP7Lxnlc1r1VFc2uFnlz9eTvJQDMXZ4Ewvg2F5B2TJeOqbJs0j0ZxiGNRuXzTH1kNWMMcaRgAAA=
  alt: fedora atomic gaming poster
---

Fedora Atomic is getting more popular. Because Bazzite is based on Fedora Kinoite. Bazzite is now sky rocket.

But how do you game on this?

Will be using different apps from flathub to play and run games.

Flatseal. To manager permissions. KDE includes `Flatpak Permissions` by default on system settings.

```
flatpak install flathub com.github.tchx84.Flatseal
```

Make sure you have added flathub as remote.


```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Steam

Steam is straight forward. Valve support of linux is first class. We just need to install steam. 

![steam flathub](</assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot 2025-04-03 at 00-57-47 Install Steam on Linux Flathub.webp>)

Open terminal and run this: 

```bash
flatpak install flathub com.valvesoftware.Steam
```

This will install steam on your system. 

Next log in to steam. Go to settings -> Compatibility -> Enable steam play for all other titles. Enable this. This will install proton for steam.

![steam compatibility setting](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot_20250403_110911.webp)

Now you will see all library are available on steam.

![steam library](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot_20250403_111243.webp)

[ProtonDB](https://www.protondb.com/) is a great tool to check steam compatibility.

![protondb](</assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot 2025-04-03 at 11-16-22 ProtonDB Gaming know-how from the Linux and Steam Deck community.webp>)

## Heroic Games Launcher

Epic Games doesn't support linux. But it can be playable through Heroic Luncher. It will bring all your Epic games as well as GOG gameslibrary in your system.

![flathub heroic](</assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot 2025-04-03 at 01-01-19 Install Heroic Games Launcher on Linux Flathub.webp>)

```bash
flatpak install flathub com.heroicgameslauncher.hgl
```

Heroic Launcher is straight forward. Login to Epic or GOG. Than install:

![epic games](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot_20250403_121557.webp)

## Lutris

Lutris is another laucnher that can run windows games on linux. It is also good launcher to run any copy of games you own. You can setup manually.

![flathub lutris](</assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot 2025-04-03 at 01-04-14 Install Lutris on Linux Flathub.webp>)

```bash
flatpak install flathub net.lutris.Lutris
```

![lutris](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot_20250403_113633.webp)

## Bottles

Bottles is another launcher. Though it's better to use this if you have a game copy. This laucnher needs more manual control. If you have problem with any games that doesn't work on laucnher above you can use this to mannaly tinker and run games.

![flathub bottles](</assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot 2025-04-03 at 01-07-21 Install Bottles on Linux Flathub.webp>)

```bash
flatpak install flathub com.usebottles.bottles
```

Create a gaming bottle. 

![bottle gaming](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot_20250403_120425.webp)

Bottle Installers. Now Install Program you want.

![bottle installers](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot_20250403_120508.webp)

### Mangohud

Mangohud is a nice gaming tools that show you stats of your pc.

install:

```bash
flatpak install org.freedesktop.Platform.VulkanLayer.MangoHud
```

To enable MangoHud for all Steam games. You can either set `MANGOHUD=1` in `Environment` with flatseal. Or from Command. 

![mangohud](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/image.webp)

command:

```bash
flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam
```

Now right click on steam game from library. Go to general -> launch options -> put `mangohud %command%`. This will enable mangohud for that game.

![mangohud](/assets/images/2025-04-02-fedora-atomic-gaming-guide-2025/Screenshot_20250403_113459.webp)

