---
layout: post
title: "Sync Google Drive in linux using podman and rclone"
date: 2024-08-24 09:00 +0600
description: "Updated guide to sync google drive in linux system with utilising podman container and rclone."
categories:
- linux
tags:
- sync
- docker
- podman
- rclone
- google-drive
---

> 2024 Guide for syncing Google Drive in linux
{: .prompt-tip }

This guide is valid for all the service that rclone supports. But we are going to focus specially on Google Drive.

**Prerequisite**: `podman`.  
Install `podman` from your distribution.

1. Pull the container image for `rclone`.
    ```bash
podman pull docker.io/rclone/rclone:latest
    ```

2. Let's sync our Google Drive in `~/sync/gdrive` folder. And we are going to put all of our rclone config in `~/sync/rclone-config` & cache in `~/sync/rclone-cache`.
    ```bash
mkdir -p ~/sync/gdrive
mkdir -p ~/sync/rclone-config
mkdir -p ~/sync/rclone-cache
    ```

3. Now let's setup up rclone. Connect rclone with Google Drive and fill our rclone-config.
```bash
podman run --rm --interactive --net=host \
  --name rclone-bisync \
  -v ~/sync/rclone-config:/config/rclone:Z \
  -v ~/sync/rclone-cache:/root/.cache/rclone:Z \
  -v ~/sync/gdrive/:/data/gdrive:Z \
  rclone/rclone:latest config
```
> **Note:** We used :Z at the end because of SELINUX. If you face error in debian, ubuntu or Arch based installation try removing `:Z`.

    Above command should open rclone setup panel. Now go ahead connect with Google Drive. We are going to use **my-gdrive-remote** as remote name for our google drive.
> **Note:** Browser won't open directly to login Google Drive. You may have to open the link http:// 127.0.0.1:.....  manually in the browser that was shown in terminal of rclone setup.

4. This is an important step. We must put an empty file (RCLONE_TEST) in both **google drive** and in our **sync folder**. This is a test file. It works with `--check access` to ensure access to remote drive. And we must keep it always in our online drive and in sync folder. Put this file in Google Drive root folder using a browser. Or sync will fail.
    ```bash
touch ~/sync/gdrive/RCLONE_TEST
    ```

5. Now we are going to **dry-run** our google drive sync. It is just a test to find out if everything is working.  
```bash
podman run --rm --name rclone-bisync \
  -v ~/sync/rclone-config:/config/rclone:Z \
  -v ~/sync/rclone-cache:/root/.cache/rclone:Z \
  -v ~/sync/gdrive:/data/gdrive:Z \
  rclone/rclone:latest bisync "my-gdrive-remote:/" "/data/gdrive" \
  --create-empty-src-dirs \
  --compare size,modtime,checksum \
  --fix-case \
  --check-access \
  --drive-acknowledge-abuse \
  --progress \
  --metadata \
  --resilient \
  --resync \
  --dry-run \
  --verbose
```
You shoulde see **INFO  : Bisync successful**.

6. Now we are going to sync our Google Drive for the **first time**. This will bring all drive files in our sync folder. 
```bash
podman run --rm --name rclone-bisync \
  -v ~/sync/rclone-config:/config/rclone:Z \
  -v ~/sync/rclone-cache:/root/.cache/rclone:Z \
  -v ~/sync/gdrive:/data/gdrive:Z \
  rclone/rclone:latest bisync "my-gdrive-remote:/" "/data/gdrive" \
  --create-empty-src-dirs \
  --compare size,modtime,checksum \
  --fix-case \
  --check-access \
  --drive-acknowledge-abuse \
  --progress \
  --metadata \
  --resilient \
  --resync \
  --verbose
```
> **Note:** It has `--resync`. We must use it once for the first time.

7. Finally we will sync again to **test** if everything is working correctly. You can put a file in local drive and see if it sync to google drive and vice-versa.
```bash
podman run --rm --name rclone-bisync \
  -v ~/sync/rclone-config:/config/rclone:Z \
  -v ~/sync/rclone-cache:/root/.cache/rclone:Z \
  -v ~/sync/gdrive:/data/gdrive:Z \
  rclone/rclone:latest bisync "my-gdrive-remote:/" "/data/gdrive" \
  --create-empty-src-dirs \
  --compare size,modtime,checksum \
  --fix-case \
  --check-access \
  --drive-acknowledge-abuse \
  --progress \
  --metadata \
  --resilient \
  --max-lock 2m \
  --recover \
  --verbose
```

8. If everrything is working correctly. We will set rclone to auto start and sync with systemd. Now we are going to use **Podman Quadlet** feature so that our container will work with systemd.

    ```bash
mkdir -p ~/.config/containers/systemd
nano ~/.config/containers/systemd/rclone-bisync.container
    ```
put the following in file. Use your favourite text editor.
    ```
   [Unit]
   Description=rclone bisync container

   [Container]
   Image=docker.io/rclone/rclone:latest
   ContainerName=rclone-bisync
   AutoUpdate=registry
   Volume=%h/sync/rclone-config:/config/rclone:Z
   Volume=%h/sync/rclone-cache:/root/.cache/rclone:Z
   Volume=%h/sync/gdrive/:/data/gdrive:Z
   Exec=bisync "my-gdrive-remote:/" "/data/gdrive" \
   --log-level ERROR \
   --log-file /root/.cache/rclone/rclone.log \
   --create-empty-src-dirs \
   --compare size,modtime,checksum \
   --fix-case \
   --check-access \
   --drive-acknowledge-abuse \
   --progress \
   --metadata \
   --resilient \
   --max-lock 2m \
   --recover

   [Install]
   WantedBy=default.target
    ```
> **Note:** You can find the ERROR log in `~/sync/rclone-cache/`

9. Let's setup a timer that will trigger this systemd service.
    ```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/rclone-bisync.timer
    ```
put this in the timer config.
    ```
   [Unit]
   Description=Run rclone bisync every 30 minutes

   [Timer]
   OnCalendar=*:0/30
   Persistent=true

   [Install]
   WantedBy=timers.target
    ```
> **Note:** You can use `OnCalendar=hourly` for sync every 1 hour. Or `OnCalendar=*:0/1` for every 1 minute.

    Start the service for timer.
    ```bash
   systemctl --user daemon-reload
   systemctl --user enable --now rclone-bisync.timer
    ```
    check time and quadlet service
    ```bash
   systemctl --user status rclone-bisync.timer
   systemctl --user status rclone-bisync.service
    ```

That's it. Now Google Drive is in sync with our Local Folder. You can do the same for One Drive or other cloud service that is supported by rclone. Modify the commands accordingly.
You can check what all the flags do at [rclone bisync](https://rclone.org/bisync/).