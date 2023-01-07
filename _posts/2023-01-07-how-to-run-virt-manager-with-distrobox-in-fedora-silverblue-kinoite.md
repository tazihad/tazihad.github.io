---
title: How to run virt-manager in Fedora Silverblue / Kinoite using Distrobox
---

It's better we create a seperate home folder for our new distrobox.  
```bash
distrobox create --root --image quay.io/toolbx-images/ubuntu-toolbox:22.04 --name ubuntu-virt-manager --home /home/zihad/.var/distrobox/home/ubuntu-virt-manager --init
```
> Change your username.

Enter distrobox with root.  
```bash
distrobox enter --root ubuntu-virt-manager
```  
let it install everything.  
```bash
sudo apt update && sudo apt upgrade
```
Install `virt-manager`.
```bash
sudo apt install virt-manager
```

update `libvirtd.service`
```bash
sudo systemctl daemon-reload
sudo systemctl restart libvirtd.service
sudo systemctl status libvirtd.service
```
add your username to to libvirt group.
```bash
sudo usermod -a -G libvirt YOUR_USERNAME
```
Check Status.  
```bash
cat /etc/group | grep libvirt
sudo systemctl status libvirtd
```
Run virt-manager.

```bash
sudo virt-manager
```

If Internet doesn't work inside virtual box. Make sure you route your network directly from your device.  
Check what's your network interface: `ip link show`.  
Change your Network from `virt-manager`.  

NIC -> Virtual Network Interface -> Network Source.  
Change to Macvtap device...
set device name: eg- `enp4s0f1`

![Macvtap](https://raw.githubusercontent.com/tazihad/tazihad.github.io/main/assets/images/Screenshot_20230108_000536.png)
