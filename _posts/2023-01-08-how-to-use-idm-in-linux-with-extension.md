---
title: How to use IDM in linux with extension support
categories:
- linux
---

Prerequisite: [Flatpak](https://flatpak.org/setup/).  

Install WINE using Flatpak.  
```bash
flatpak install flathub org.winehq.Wine
```

Create a 32-Bit WINEPREFIX named "IDM" using flatpak winetricks. Install IDM in default location.  

```bash
flatpak run --command=winetricks org.winehq.Wine
```

put below script as `idm` in `~/.local/bin/`.  
Make it executable. `chmod +x ~/.local/bin/idm`  
> Change username inside it.  

```bash
#!/bin/bash

if  [[ $1 == '-d' ]]; then
   flatpak run --env="WINEPREFIX=/var/home/zihad/.var/app/org.winehq.Wine/data/wineprefixes/IDM/" org.winehq.Wine "/var/home/zihad/.var/app/org.winehq.Wine/data/wineprefixes/IDM/drive_c/Program Files/Internet Download Manager/IDMan.exe" /d "$2"
elif [[ $1 == *://* ]]; then
  flatpak run --env="WINEPREFIX=/var/home/zihad/.var/app/org.winehq.Wine/data/wineprefixes/IDM/" org.winehq.Wine "/var/home/zihad/.var/app/org.winehq.Wine/data/wineprefixes/IDM/drive_c/Program Files/Internet Download Manager/IDMan.exe" /d "$1"
else
  echo "Usage: idm [URL] or idm -d [URL]"
fi
```

put `idm.png` icon in `~/.local/share/icons`.  
[idm.png source](https://github.com/tazihad/idm-linux)

create application launcher in `~/.local/share/applications`.

`nano ~/.local/share/applications/idm.desktop`  

```desktop
[Desktop Entry]
Name=Internet Download Manager
Exec=flatpak run --env="WINEPREFIX=/var/home/zihad/.var/app/org.winehq.Wine/data/wineprefixes/IDM/" org.winehq.Wine "/var/home/zihad/.var/app/org.winehq.Wine/data/wineprefixes/IDM/drive_c/Program Files/Internet Download Manager/IDMan.exe" @@u %U @@
Type=Application
Terminal=false
Categories=Internet;
Icon=idm.png
Comment=Launch Internet Download Manager.
StartupWMClass=Internet Download Manager
```  
> Change your username.

**NOTE:** Change IDM Directory, Home directory & Username as per your distribution. Make sure you have node installed in system. Or use NVM to install node in local.


### Extension

Download for your browser.  
https://add0n.com/download-by.html  
[Chromium based browser](https://chrome.google.com/webstore/detail/download-by-idm/lgbipmmmnjifkiiikaffhceflifbmhib)  
[Firefox](https://addons.mozilla.org/en-US/firefox/addon/download-by-idm/)  

Turn on the Extension by clicking it. Try Download something. It will prompt you to install Native Messaging. Install it.  
[Native Messaging source](https://github.com/Emano-Waldeck/native-client/releases/tag/0.1.5).  

Open a terminal window on the top level of the extracted directory and run .`/install.sh`

That should be it.
