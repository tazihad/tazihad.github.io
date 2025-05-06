---
title: How to install Homebrew (Brew / LinuxBrew) in Fedora Silverblue & Kinoite
description: Learn how to install Homebrew (LinuxBrew) on Fedora Silverblue & Kinoite using a container-friendly approach.
date: 2023-01-07 6:33:00 +0600
categories: [linux, silverblue]
tags: [linux, silverblue, kinoite, linuxbrew]
---

If you're using Fedora Silverblue, first of all – respect! Not everyone dares to try this fancy immutable system. But yeah, once you start using it, you’ll realize some things are not as straightforward. Like installing small CLI tools — you don’t want to layer RPMs every time, right?

That’s where Homebrew comes in. Yes, the same Homebrew that Mac people always flex about. Good news is, it works on Linux too! And even on Silverblue, it works totally fine — without touching your base system.

In this blog, I’ll show you how to set up Homebrew on Fedora Silverblue step-by-step. I’m using it myself, and it’s a lifesaver for installing tools like htop, bat, ripgrep, and more. Let’s dive in!

> Note that on linux it's called `linuxbrew`!
{: .prompt-tip }

## Installation

1. Install homebrew from host.
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
This script will:
- Download Homebrew
- Install it under /home/linuxbrew/.linuxbrew/
- Set up permissions
> You need sudo here since it installs in your `/home/linuxbrew`. Just hit enter and give sudo access.   
   
2. After installation, you need to tell your shell where to find brew. Otherwise, you'll get "command not found".  
Just add the following snippet to your `~/.bashrc`, `~/.zshrc`, or whatever shell config you use:
```sh
if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
```
Then, apply the changes:
```sh
source ~/.bashrc   # or source ~/.zshrc
```
Now you can use the `brew` command from any terminal session.
    
3. Try Installing a Package
Let’s make sure it’s working properly by installing a test package.  
Run:
```sh
brew install hello
```
This will install the classic GNU Hello program (it literally just prints "Hello, world!").  
Once installed, try running it:
```sh
hello
```
If you see the output, congrats — Homebrew is up and running! 🎉

## 🩺 Bonus Tip: Run brew doctor to Check for Issues
After setting up Homebrew, it’s a good idea to run:
```sh
brew doctor
```
This command is like a health check for your Homebrew setup. It’ll scan your system and let you know if something isn’t quite right — like missing dependencies, incorrect permissions, or path issues.

If everything’s fine, you’ll see:
```
Your system is ready to brew.
```

On fresh Fedora Atomic I get
```sh
❯ brew doctor
Please note that these warnings are just used to help the Homebrew maintainers
with debugging if you file an issue. If everything you use Homebrew for is
working fine: please don't worry or file an issue; just ignore this. Thanks!

Warning: No developer tools installed.
Install Clang or run `brew install gcc`.
```

So, we can fix it by installing `gcc`
```sh
brew install gcc
```
or we can install LLVM suite
```sh
brew install llvm
```
This will install the whole LLVM suite, including clang, clang++, lld, gcc and other related tools.

After installation, the tools will be located inside:
```sh
/home/linuxbrew/.linuxbrew/opt/llvm/bin/
```
   
## Uninstalling Homebrew (if needed)
If you ever want to remove Homebrew completely from your system, follow these two simple steps:
**1. Remove the Homebrew directory:**
```sh
sudo rm -rf /home/linuxbrew
```
**2. Remove the PATH export from your shell config:**  
Edit your ~/.bashrc or ~/.zshrc and delete the lines you added earlier. Then reload the shell:
```sh
source ~/.bashrc   # or source ~/.zshrc
```
That’s it — clean and simple!