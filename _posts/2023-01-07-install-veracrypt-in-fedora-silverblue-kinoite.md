---
title: Install Veracrypt in Fedora Silverblue & Kinoite
categories: [linux, silverblue, kinoite, veracrypt]
---

Download Generic Installer *tar.bz2 from [source](https://www.veracrypt.fr/en/Downloads.html "source").  
Extract it. example 
```
tar -xf veracrypt-1.25.9-setup.tar.bz2 -C ~/Downloads/veracrypt
```
Look for *gtk-gui-x64 file and run it.  
```
./veracrypt-1.25.9-setup-gtk3-gui-x64
```
Click on **Extract .tar Package File**. Agree license. This will extract files in `/tmp` folder.  
Look for veracrypt*.tar.gz file in `/tmp`.

Extract it.  
```
tar -xvzf veracrypt_1.25.9_amd64.tar.gz -C ~/Downloads/
```

Look for `/usr` folder from extracted files.  
copy `/usr/bin/veracrypt` and `/usr/sbin/mount.veracrypt` to `~/.local/bin`.  
And `/usr/share/applications` to `~/.local/share/applications.`  
`/usr/share/pixmaps`to `~/.local/share/pixmaps`. 

`veracrypt.desktop` file should look like this.  
```
[Desktop Entry]
Type=Application
Name=VeraCrypt
GenericName=VeraCrypt volume manager
Comment=Create and mount VeraCrypt encrypted volumes
Icon=veracrypt
Exec=veracrypt %f
Categories=Security;Utility;Filesystem
Keywords=encryption,filesystem
Terminal=false
MimeType=application/x-veracrypt-volume;application/x-truecrypt-volume;
```

If you want console version.

Then run the console setup from Terminal. It will extract veracrypt*.tar.gz in /tmp.  
Extract again and inside you find bin and sbin folder.  
Copy `veracrypt` and `mount.veracrypt` from `/usr/bin/veracrypt` and `/usr/sbin/mount.veracrypt` and put both file in `~/.local/bin`. Now restart.  
start with “veracrypt –help”  

This just installed veracrypt terminal edition. If you want the gui. You have to follow the same step but extract the gtk edition. non-gtk edition has some library missing issue.
