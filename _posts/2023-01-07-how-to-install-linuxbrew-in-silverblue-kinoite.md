---
title: How to install Brew / LinuxBrew in Fedora Silverblue & Kinoite
categories:
- linux
- silverblue
---

Prerequisite: **Distrobox**    

`rpm-ostree install distrobox`

1. Install homebrew from host.
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   
2. install distrobox container in linuxbrew folder with `--root`
   ```bash
   distrobox create --root --name linuxbrew --image quay.io/toolbx-images/ubuntu-toolbox:22.04 --home /var/home/linuxbrew
   ```
    
3. give user permission to linuxbrew folder. Change your own user.  
   ```bash
   sudo setfacl -R -m u:zihad:rwx /var/home/linuxbrew
   ```
    
4. install build tools   
If you using ubuntu container.  
   ```bash
   distrobox enter --root linuxbrew
   sudo apt install build-essential
   ``` 

   for fedora, centOS  container  
       ```bash
      distrobox enter --root linuxbrew  
      sudo yum groupinstall 'Development Tools'
      sudo yum install procps-ng curl file git perl openssl
      ```  
5. Follow the Next steps instructions to add Linuxbrew to  your PATH of **host** system and to your **container** bash shell profile script, either `~/.profile` on Debian/Ubuntu or `~/.bash_profile` on CentOS/Fedora/RedHat. The best place is to put it in `~/.bashrc`.  
   ```bash
   eval $(/var/home/linuxbrew/.linuxbrew/bin/brew shellenv)
   ```
6. Now install any application which will be available in host os.  
Make sure you install package from **inside** linuxbrew distrobox container. But those packages will be available from host. Example trying installing `neofetch`. Now you can access `neofetch` binary from host os. 
   ```bash
   distrobox enter --root linuxbrew
   brew install neofetch
   ```
   
Uninstall:  
To completely remove linuxbrew from system. 
```bash
distrobox stop --root linuxbrew
distrobox rm --root linuxbrew
sudo rm -rf /var/home/linuxbrew
```
and remove the linuxbrew env from `~/.bashrc`
