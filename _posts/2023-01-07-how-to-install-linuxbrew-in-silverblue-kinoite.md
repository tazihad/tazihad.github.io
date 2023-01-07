---
title: How to install Brew / LinuxBrew in Fedora Silverblue & Kinoite
---

Prerequisite: Distrobox  
`rpm-ostree install distrobox`

1. Install homebrew from host.
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   
2. install distrobox in linuxbrew folder
   ```bash
   distrobox create --name linuxbrew --image registry.fedoraproject.org/fedora-toolbox:37 --home /var/home/linuxbrew
   ```
    
3. give permission to linuxbrew folder or distrobox  
   ```bash
   sudo chmod 777 /var/home/linuxbrew
   ```
    
4. install build tools for fedora, centOS  
    ```bash
   distrobox enter linuxbrew  
   sudo yum groupinstall 'Development Tools'  
   sudo yum install procps-ng curl file git perl openssl  
    ```
5. Follow the Next steps instructions to add Linuxbrew to your PATH and to your bash shell profile script, either `~/.profile` on Debian/Ubuntu or `~/.bash_profile` on CentOS/Fedora/RedHat. The best place is to put it in `~/.bashrc`.  
   ```bash
   echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
   ```
6. Now install any application which will be available in host os.  
Make sure you install package from inside distrobox. But those packages will be available from host. Example trying installing `neofetch`.
   ```bash
   distrobox enter linuxbrew
   brew install neofetch
   ```
