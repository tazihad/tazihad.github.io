---
title: How to update Flatpak apps automatically
categories:
- linux
tags: [linux,flatpak]
---

`cron` is not available in Silverblue but systemd Timers can be used instead.  
Systemd configuration can be put into ~/.config/systemd/user but you have to create that folder if it does not exist.  

```bash
mkdir -p ~/.config/systemd/user 
```

First, let\'s create the timer in a file called `flatpak-update.timer`. Use `OnCalendar=hourly` or `OnCalendar=daily` as you prefer.  

```
[Unit]
Description=Update flatpaks

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

The timer will trigger a service that will actually run the command to update flatpaks. It is specified in another file that's named similarily (`flatpak-update.service`):  

```
[Unit]
Description=Update flatpaks

[Service]
ExecStart=flatpak update --noninteractive
```

After creating those files, the updated configuration becomes active by running the following command:  

```
systemctl daemon-reload --user
```

```
systemctl enable --user flatpak-update.timer
systemctl start --user flatpak-update.timer
```

The following command should list your new timer now:

```
systemctl list-timers --user
```

If you want to have a look at the output of the update, run:

```
journalctl --user -u flatpak-update
```

Warning:

Consider app size when enabling this. Huge apps could be an issue on bad wifi or metered connections. Maybe it also makes sense to disable this again before journeys with bad internet connections.  

```
systemctl stop --user flatpak-update.timer
systemctl disable --user flatpak-update.timer
```


[source](https://www.reddit.com/r/SteamDeck/comments/zis9sf/psa_automatically_update_installed_flatpaks/)
