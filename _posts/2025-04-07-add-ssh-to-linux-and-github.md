---
title: Generate ssh key and connect linux to github
description: Connect linux console with github with ssh key.
date: 2025-04-07 16:33:00 +0600
categories: [linux]
tags: [linux, ssh, github]
pin: false # pin post
math: false # math latex syntax
mermaid: false # diagram & visualizations
---

Let's start. Make sure you are logged in to your github account in your browser.

1. Generate SSH key pair
```
ssh-keygen -t ed25519 -C "your_email@example.com"
```
Keep password empty so that don't have to use password each time use ssh.

2. Start the SSH agent: 
```
eval "$(ssh-agent -s)"
```

3. Add your SSH private key to the SSH agent: 
```
ssh-add ~/.ssh/id_ed25519
```

4. Show your SSH public key. And copy it.
```
cat ~/.ssh/id_ed25519.pub
```

5. Add Your SSH Public Key to Your [GitHub Account](https://github.com/settings/keys)  
`GitHub` → `Settings` → `SSH & GPG Keys` → `New SSH key` → `Paste Key` (Give title)


6. Test the SSH connection to Github 
```
ssh -T git@github.com
```

