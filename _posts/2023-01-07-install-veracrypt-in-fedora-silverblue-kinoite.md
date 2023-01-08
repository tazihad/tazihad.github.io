---
title: Install Veracrypt in Fedora Silverblue & Kinoite
categories:
- linux
- silverblue
---

Download Generic Installer *tar.bz2 from [source](https://www.veracrypt.fr/en/Downloads.html "source").  

Extract it. 
Then run the console setup from Terminal. It will extract veracrypt*.tar.gz in /tmp.  
Extract again and inside you find bin and sbin folder.  
Copy `veracrypt` and `mount.veracrypt` from `/usr/bin/veracrypt` and `/usr/sbin/mount.veracrypt` and put both file in `~/.local/bin`. Now restart.  
start with “veracrypt –help”  

This just installed veracrypt terminal edition. If you want the gui. You have to follow the same step but extract the gtk edition. non-gtk edition has some library missing issue.
