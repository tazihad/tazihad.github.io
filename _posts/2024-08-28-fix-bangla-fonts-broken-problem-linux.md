---
layout: post
title: "Fix broken Bangla fonts problem in linux"
date: 2024-08-28 16:25 +0600
description: "Fix small or broken Bangla fonts problem in any linux distro"
categories:
- linux
tags:
- font
- bangla-font
author:
---

If you have broken or boxed bangla fonts problem. Or you see small bangla fonts. You can fix it by following the commands.

You must have `curl` installed. Although most distribution preincludes this. If you don't have it install it first.
```bash
sudo apt install curl # Ubuntu, Debian, Linux Mint based distros
sudo dnf install curl # Fedora based distros
```

Open your terminal. And copy paste this commands.
1. First download **most used Bangla fonts** for linux. This will install Bangla fonts for local user.
```bash
curl -sSL https://raw.githubusercontent.com/tazihad/bangla-font-fix-linux/main/fonts-bangla-download.sh | sh
```
2. Windows 10 has Nirmala UI as default Bangla font. It's made by Microsoft. **Download this config** it make it default for Bangla font. 
```bash
curl -sSL https://raw.githubusercontent.com/tazihad/bangla-font-fix-linux/main/bangla-nirmalaui-default.sh | sh
```
3. (Optional) This will download all Windows 10 fonts for linux.
```bash
curl -sSL https://raw.githubusercontent.com/tazihad/bangla-font-fix-linux/main/msfonts-download.sh | sh
```
 
**Logout from session and Login again to see font change.**


Although Google Chrome has better font rendering for Bangla language. But Firefox is often not good. Let's change the default fonts for better readability.

#### Extra Steps for Firefox Users

Follow these steps to configure fonts for Bengali and Latin text in Firefox:

1. **Open Firefox Settings:**
   - Navigate to `Settings`.

2. **Navigate to Fonts & Colors:**
   - Go to `Language & Appearance` -> `Fonts & Colors`.
   - Click on the `Advanced...` button.

3. **Configure Bengali Fonts:**
   - **Fonts for:** Select `Bengali`.
   - **Proportional:** Set to `Serif`, Size to `16`.
   - **Serif:** Set to `Nirmala UI`.
   - **Sans-serif:** Set to `Nirmala UI`.
   - **Monospace:** Set to `Consolas`, Size to `12`.
   - **Minimum font size:** Leave as `None`.

   - Click `OK` to save.

4. **Configure Latin Fonts:**
   - **Fonts for:** Select `Latin`.
   - **Proportional:** Set to `Serif`, Size to `16`.
   - **Serif:** Set to `Times New Roman`.
   - **Sans-serif:** Set to `Arial`.
   - **Monospace:** Set to `Consolas`, Size to `12`.
   - **Minimum font size:** Leave as `None`.

   - Click `OK` to save.

5. **Set Default Font:**
   - Ensure the default font is set to `Times New Roman`.

This setup ensures that Bengali text is displayed correctly with the desired fonts and sizes in Firefox.
