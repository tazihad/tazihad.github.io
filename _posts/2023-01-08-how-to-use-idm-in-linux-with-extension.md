---
title: How to use IDM in linux with extension support (2026)
categories: [linux]
tags: [wine]
---

Prerequisite: [Flatpak](https://flatpak.org/setup/).  
## Introduction  
If you're a long-time Windows user who recently switched to Linux, chances are you've missed a few familiar tools—especially Internet Download Manager (IDM). Known for its blazing fast downloads, browser integration, and ability to resume interrupted files, IDM is a favorite among users who frequently download large files or media.

But here's the catch: IDM was built for Windows. There's no official Linux version.

So the question is—how do you get IDM-like functionality on Linux, complete with extension support for Chrome or Firefox? That’s exactly what we’re going to solve in this guide. Let’s get you back to downloading like a boss, the Linux way.

Step by step guide to setu IDM with extension

### Install IDM flatpak
Download latest release of IDM flatpak from [github.com/tazihad/flatpaks/releases](https://github.com/tazihad/flatpaks/releases).
Install using 
```sh
curl -L -o idm.flatpak https://github.com/tazihad/flatpaks/releases/download/wow64/idm.flatpak
flatpak install flathub org.freedesktop.Platform//25.08
flatpak install flathub org.winehq.Wine//wow64-25.08
flatpak install --user idm.flatpak
```

### Extension setup
In this section we going to setup browser extension. I am going to discuss both native **firefox** and **flatpak firefox**.
First go ahead and install [External Application Button (WebExtension)](https://addons.mozilla.org/en-US/firefox/addon/external-application/)
Than Open the option page. If you can't find the option page from extension setting in firefox. Copy this [direct url](moz-extension://a3636e6a-4704-4410-a9ff-65ee1a1e34e6/data/options/index.html) in address bar. Now setup this extension according to your browser.

#### Native Firefox
- Download and install linux.zip from [here](https://github.com/andy-portmen/native-client/releases). Extract and run it.
- Install node. 
```sh
nvm install --lts
```
If you don't have `nvm` installed yet, run this first to install `nvm`:
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh
```
- Now from the Application setup 
Display Name: `Open in IDM`  
Executable Name: `/home/user_name/bin/idm`  
Arguments: `[HREF]`  
You can find the `idm`executable [here](https://github.com/tazihad/idm-linux/blob/master/external-download-button/native-browser/idm). Make sure it had executable permission. `chmod +x idm`.  
![extension setup for native firefox](/assets/images/2023-01-08-how-to-use-idm-in-linux-with-extension/Screenshot_20251214_003531.webp)
- Check **All Contexts**  
![alt text](/assets/images/2023-01-08-how-to-use-idm-in-linux-with-extension/Screenshot_20251216_103004.webp)
- Make sure you click **Add Application** below in List of Application to save the settings.
![alt text](/assets/images/2023-01-08-how-to-use-idm-in-linux-with-extension/Screenshot_20251214_004640.webp)

#### Flatpak Firefox
- Download and install linux.zip from [here](https://github.com/andy-portmen/native-client/releases). Extract and run it.
- install [External Application Button (WebExtension)](https://addons.mozilla.org/en-US/firefox/addon/external-application/)
- Download and install linux.zip from [here](https://github.com/andy-portmen/native-client/releases). Extract and run it.
- copy this folder `~/.config/com.add0n.node` to `~/.var/app/org.mozilla.firefox/data/com.add0n.node`.
- Edit the `run.sh` and inside modify node location `~/.var/app/org.mozilla.firefox/data/node/bin/node host.js` or `../node/bin/node host.js`
- We must install Standalone Node Binary. [Download](https://nodejs.org/en/download) Standalone Node Binary and extract it in as `~/.var/app/org.mozilla.firefox/data/node`
- Now from the Application setup 
Display Name: `Open in IDM (Flatpak)`  
Executable Name: `/home/zihad/.var/app/org.mozilla.firefox/data/bin/idm`  
Arguments: `[HREF]`  
You can find the `idm`executable [here](https://github.com/tazihad/idm-linux/blob/master/external-download-button/flatpak-browser/idm). Make sure it had executable permission. `chmod +x idm`.  
![alt text](/assets/images/2023-01-08-how-to-use-idm-in-linux-with-extension/Screenshot_20251214_003331.webp)
- Check **All Contexts**  
![alt text](/assets/images/2023-01-08-how-to-use-idm-in-linux-with-extension/Screenshot_20251216_103004.webp)
- Make sure you click **Add Application** below in List of Application to save the settings.
![alt text](/assets/images/2023-01-08-how-to-use-idm-in-linux-with-extension/Screenshot_20251214_004640-1.webp)

That's it. Now you can download with idm extension.
![alt text](/assets/images/2023-01-08-how-to-use-idm-in-linux-with-extension/Screenshot_20251214_005605.webp)

