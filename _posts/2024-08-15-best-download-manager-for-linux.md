---
title: Best Download Manager for Linux
categories:
- linux
tags:
- downloader
- docker
- container
---

For years I have searched for best download manager on linux. I think I have found it.
It has multithreading feature and many more. Yes, I am talking about aria2.
Let's setup aria2 and integrate it with linux. We are going to use podman and aria2 in container. It takes very little resources, 650 KB memory when idle. Let's set it up.

We need podman for to run our container.

- Install podman according to your distro
```sh
sudo apt install podman # debian/ubuntu/linux mint
sudo dnf install podman # fedora
sudo pacman -S podman # arch/manjaro
```
- Let's pull the container
```sh
podman pull docker.io/p3terx/aria2-pro:latest
```
- Setup podman container
```sh
mkdir -p ~/Downloads/aria2-pro-downloads
mkdir -p ~/.config/containers/systemd
mkdir -p ~/.config/aria2
touch ~/.config/containers/systemd/aria2-pro.container
nano ~/.config/containers/systemd/aria2-pro.container
```
copy paste the following in aria2-pro.container

    ```
    [Unit]
    Description=Podman aria2-pro.service
    Wants=network-online.target
    After=network-online.target

    [Service]
    Restart=on-failure
    TimeoutStartSec=900

    [Container]
    ContainerName=aria2-pro
    Environment=PUID=1000 PGID=1000 UMASK_SET=022 RPC_SECRET=123456 RPC_PORT=6800 LISTEN_PORT=6888
    Image=docker.io/p3terx/aria2-pro:latest
    PodmanArgs=--log-opt 'max-size=1m'
    AutoUpdate=registry
    PublishPort=6800:6800
    PublishPort=6888:6888
    PublishPort=6888:6888/udp
    Volume=%h/.config/aria2:/config:Z
    Volume=%h/Downloads/aria2-pro-downloads:/downloads:Z

    [Install]
    WantedBy=default.target
    ```

- Let's run the container using systemd.
```sh
systemctl --user daemon-reload
systemctl --user start aria2-pro.service
```

- Before we use the container. we have to fix some permissions. Enter the container and fix permissions.
```
podman exec -it aria2-pro /bin/sh
chown -R p3terx:p3terx /downloads
chmod 777 /downloads
```

- Install browser extension. We are going to use **Aria2 Integration Extension** by [zluo01](https://github.com/zluo01/aria2-extension)  
Firefox: [Aria2 Integration Extension for Firefox based browsers](https://addons.mozilla.org/en-US/firefox/addon/aria2-integration-extension/)  
Chrome: [Aria2 Integration Extension for Chromium based browsers](https://chromewebstore.google.com/detail/aria2-integration-extensi/chehmbmmchaagpilhabnocngnmjllgfi)  

- Open the config menu of the extension, Set the **Token** field with the **RPC_SECRET** we have provided in the container config. Which is `123456`.  
That's about it. The best download manager on linux is ready.





