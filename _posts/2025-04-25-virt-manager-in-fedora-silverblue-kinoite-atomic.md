---
title: How to Use Virt Manager on Fedora Atomic, Silverblue, and Kinoite - Easy VM Setup Guide
description: Learn how to install and use Virt Manager on Fedora Atomic desktops like Silverblue, Kinoite, and Sericea. This guide covers VM setup using Toolbox and Flatpak for seamless virtualization on immutable systems.
date: 2025-04-25 08:33:00 +0600
categories: [linux]
tags: [linux]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
published: true # publish post
image:
  path: ../assets/images/2025-04-24-virt-manager-in-fedora-silverblue-kinoite-atomic/virt-manager-poster.webp
  lqip: data:image/webp;base64,UklGRlQAAABXRUJQVlA4IEgAAABwAwCdASoUAAsAPzmEuVOvKKWisAgB4CcJagCdABj0JzwgpAAA/uMDmHI4wpu5pSPwNURWM+sXDe9gdxf4bBCY6YmWaqMLIAA=
  alt: install virt manager on fedora atomic
---

If you're running Fedora Silverblue, Kinoite, or any other immutable Fedora variant, installing traditional software can be a bit different from the usual package manager approach. Luckily, Virt Manager, a popular tool for managing virtual machines, is available on Flathub as a Flatpak package, making it easy to install on your system.

In this guide, I'll walk you through the simple steps to install Virt Manager from Flathub, get your virtual machines up and running, and optimize the setup using Toolbox on your immutable desktop. Whether you're testing other operating systems, running legacy apps, or exploring the world of virtualization, this post will help you get started in no time.

## Installation
Make your you have (flathub)[https://flathub.org/setup/Fedora] enabled.

1. To install Virt Manager, run the following command in your terminal:
```sh
flatpak install flathub org.virt_manager.virt-manager
```

2. Now that you have Virt Manager installed, you’ll need to install an additional extension to enable QEMU, which is a necessary backend for running virtual machines. This extension helps Virt Manager interact with QEMU/KVM, allowing you to manage virtual machines effectively.  
To install the QEMU **Extension** for Virt Manager, use the following command:
```sh
flatpak install org.virt_manager.virt_manager.Extension.Qemu
```
> This only allow `libvirt` user instance

## Usage
Run Virt Manager from application launcher.

You would see warning: Could not detect a default hypervisor. Because it can only run user instance.  
![warning](../assets/images/2025-04-25-virt-manager-in-fedora-silverblue-kinoite-atomic/Screenshot_20250425_023436.webp)  

Let's add **Add Connection**  
![add connection](../assets/images/2025-04-25-virt-manager-in-fedora-silverblue-kinoite-atomic/Screenshot_20250425_023555.webp)  

Add `QEMU/KVM user session`  
![user session](../assets/images/2025-04-25-virt-manager-in-fedora-silverblue-kinoite-atomic/Screenshot_20250425_023611.webp)  

You should see user session created.  
![user session created](../assets/images/2025-04-25-virt-manager-in-fedora-silverblue-kinoite-atomic/Screenshot_20250425_023625.webp)  

Now you can start creating VM as usuals
![create vm](../assets/images/2025-04-25-virt-manager-in-fedora-silverblue-kinoite-atomic/Screenshot_20250425_023645.webp)  

Hope this guide helped you get started! If you have any questions, feel free to drop them in the comments. Happy virtualizing! 😄