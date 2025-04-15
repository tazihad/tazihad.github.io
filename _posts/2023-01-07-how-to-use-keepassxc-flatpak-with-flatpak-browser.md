---
title: How to Use flatpak KeepassXC with flatpak Firefox or Chromium based browser.
categories: [linux]
tags: [linux,flatpak,keepassxc]
---

At the moment January 2023. Flatpak Keepassxc doesn't connect with Flatpak Firefox or other chromium based browsers. But we will use some tricks to fix this issue.  

### Firefox

1. Granted the browser access to KeePassXC flatpak app and KDE runtime installations, and to the KeePassXC proxy socket:  

   ```bash
   flatpak override --user \
     --filesystem={/var/lib,xdg-data}/flatpak/{app/org.keepassxc.KeePassXC,runtime/org.kde.Platform}:ro \
     --filesystem=xdg-run/app/org.keepassxc.KeePassXC:create \
     org.mozilla.firefox
   ```

2. Created a wrapper script that will launch the official keepassxc-proxy from KeePassXC flatpak, at a path accessible by the Firefox flatpak, e.g.   

	`mkdir -p ~/.var/app/org.mozilla.firefox/data/bin/`  
	
	`nano ~/.var/app/org.mozilla.firefox/data/bin/keepassxc-proxy-wrapper.sh`   

   ```bash
   #!/bin/bash
   
   APP_REF="org.keepassxc.KeePassXC/x86_64/stable"
   
   for inst in "$HOME/.local/share/flatpak" "/var/lib/flatpak"; do
       if [ -d "$inst/app/$APP_REF" ]; then
           FLATPAK_INST="$inst"
           break
       fi
   done
   [ -z "$FLATPAK_INST" ] && exit 1
   
   APP_PATH="$FLATPAK_INST/app/$APP_REF/active"
   
   RUNTIME_REF=$(awk -F'=' '$1=="runtime" { print $2 }' < "$APP_PATH/metadata")
   RUNTIME_PATH="$FLATPAK_INST/runtime/$RUNTIME_REF/active"
   
   exec flatpak-spawn \
       --env=LD_LIBRARY_PATH=/app/lib \
       --app-path="$APP_PATH/files" \
       --usr-path="$RUNTIME_PATH/files" \
       -- keepassxc-proxy "$@"
   ```

    
   `chmod +x ~/.var/app/org.mozilla.firefox/data/bin/keepassxc-proxy-wrapper.sh`  

3. Put the native messaging host json manifest to a the path where flatpaked Firefox will look for it, e.g.   
    `mkdir -p ~/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts`
    
   `nano ~/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json`  
   
   ```json
   {
       "allowed_extensions": [
           "keepassxc-browser@keepassxc.org"
       ],
       "description": "KeePassXC integration with native messaging support",
       "name": "org.keepassxc.keepassxc_browser",
       "path": "/home/username/.var/app/org.mozilla.firefox/data/bin/keepassxc-proxy-wrapper.sh",
       "type": "stdio"
   }
   ```

   
	Restart Keepassxc & Firefox.

###  Brave
1. put `keepassxc-proxy-wrapper.sh` to `~/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/keepassxc-proxy-wrapper.sh`. make sure `keepassxc-proxy-wrapper.sh` is executable.  

2. Copy Native messaging host from `~/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts/` to `~/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/NativeMessagingHosts/`  
and edited the line  

   ```json
   {
       "allowed_origins": [
           "chrome-extension://pdffhmdngciaglkoonimfcmckehcpafo/",
           "chrome-extension://oboonakemofpalcgghocfoadofidjkkk/"
       ],
       "description": "KeePassXC integration with native messaging support",
       "name": "org.keepassxc.keepassxc_browser",
       "path": "/home/username/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/keepassxc-proxy-wrapper.sh",
       "type": "stdio"
   }
   ```
