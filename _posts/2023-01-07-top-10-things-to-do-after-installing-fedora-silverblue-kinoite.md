---
title: 10 Things to do after installing Fedora Silverblue / Kinoite
categories:
- linux
- silverblue
---

![Silverblue Desktop]({{ BASE_PATH }}/assets/images/Screenshot_20230107_184440.png)

**1. Check system update and upgrades**


`rpm-ostree status`  
`rpm-ostree upgrade --check`  
`rpm-ostree upgrade`  


reboot to updated system.

Upgrading between major versions.

`ostree remote refs fedora`  
`rpm-ostree rebase fedora:fedora/38/x86_64/silverblue`  
or  
`rpm-ostree rebase fedora:fedora/38/x86_64/kinoite`  
> (Change release number ==> 38)


Rollback to previous update  
`rpm-ostree rollback`

**2. Add Flathub Repository**  

`flatpak update`  
`flatpak update --appstream`  
`flatpak remote-delete flathub`  
> Detele previous flathub selection repository to install complete flathub.

`flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`  

Run this command to reinstall fedora flatpak repo applications with ones from flathub.   
```bash
flatpak install --reinstall flathub $(flatpak list --app-runtime=org.fedoraproject.Platform --columns=application | tail -n +1 )
```

**3. Create and test toolbox**

`toolbox create`  
`toolbox list`  
`toolbox enter`  
`podman stop $container_name`  
> stop toolbox  

`toolbox rm $container_name`  
> delete toolbox  

**4. Install NVIDIA Drivers (Optional)**

We have to layer our drivers with OS.  

```bash
sudo rpm-ostree install --apply-live  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

`sudo rpm-ostree install --apply-live akmod-nvidia xorg-x11-drv-nvidia`  

`sudo rpm-ostree install --apply-live akmod-nvidia xorg-x11-drv-nvidia-cuda `
> optional if using nvidia-smi or cuda. Install one of the two.  

`sudo rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1`
> blacklist noveau/open source driver. this might not be needed at some point when silverblue will support the standard way to specify this.  

When RPMFusion was installed, it was tied to a specific version of Fedora, thus rebasing for the next release would be a problem, it can be fixed by uninstalling the currently installed and installing a "general" repo:   
```bash
rpm-ostree update --uninstall rpmfusion-free-release --uninstall rpmfusion-nonfree-release --install rpmfusion-free-release --install rpmfusion-nonfree-release
```


**5. Setup Gaming**

Steam: `flatpak install flathub com.valvesoftware.Steam`  
Lutris: `flatpak install flathub net.lutris.Lutris`  
Bottles: `flatpak install flathub com.usebottles.bottles`  
Heroic Launcher (Epic Games): `flatpak install flathub com.heroicgameslauncher.hgl`  
Manage Wine, Proton: `flatpak install flathub net.davidotek.pupgui2`  

**6. Install Distrobox**

With Distrobox you can have different distro's terminal and repo.   
`rpm-ostree install distrobox`  

**7. Fix Codecs & Thumbnails**

Fix Fedora Firefox x264 codecs: `rpm-ostree install libavcodec-freeworld`  
Fix KDE/Kinoite video thumbnail in Dolphin File manager: `rpm-ostree install ffmpegthumbs`  
Fix Gnome/Silverblue video thumbnail in Nautilus: `rpm-ostree install kffmpegthumbnailer`  

**8. Install Microsoft Fonts**

Copy All Microsoft fonts from any Windows ISO. [Check here](https://wiki.archlinux.org/title/Microsoft_fonts#Extracting_fonts_from_a_Windows_ISO "Check here") about how to extract.   
And put it in:  
`~/.local/share/fonts`  
> fonts will be only available to user.
