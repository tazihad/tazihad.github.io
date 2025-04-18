---
title: How to run virt-manager in Fedora Silverblue / Kinoite using Distrobox
description: Guide to running Virt-Manager on Fedora Silverblue / Kinoite using Distrobox for seamless virtualization management.
date: 2023-01-07 8:33:00 +0600
categories: [linux, silverblue]
tags: [linux, silverblue, kinoite, virt-manager]
---

It's better we create a seperate home folder for our new distrobox.  
```bash
distrobox create --root --image quay.io/toolbx/ubuntu-toolbox:20.04 --name ubuntu-virt-manager --home ~/.var/distrobox/ubuntu-virt-manager --init
```

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
sudo apt install -y virt-manager
```

add your username to to libvirt group.
```bash
sudo usermod -aG libvirt $USER
```

update `libvirtd.service`
```bash
sudo systemctl daemon-reload
sudo systemctl restart libvirtd.service
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

NIC -> Virtual Network Interface -> Network Sourcea.  
Change to Macvtap device...
set device name: eg- `enp4s0f1`

![Macvtap]({{ BASE_PATH }}/assets/images/2023-01-07-how-to-run-virt-manager-with-distrobox-in-fedora-silverblue-kinoite/Screenshot_20230108_000536.webp)
