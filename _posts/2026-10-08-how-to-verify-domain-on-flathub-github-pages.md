---
title: "How to Verify Your Custom Domain on Flathub (With GitHub Pages & Jekyll)"
description: "Publishing a Flatpak app to Flathub and need developer domain verification? Here is how to properly host .well-known/org.flathub.VerifiedApps.txt on GitHub Pages and Jekyll without getting silent 404 errors."
date: 2026-10-08 10:00:00 +0600
categories: [linux, flatpak]
tags: [flathub, flatpak, github pages, jekyll, domain verification, linux, ci/cd]
pin: false
math: false
mermaid: false
published: true
image:
  path: /assets/images/2026-10-08-how-to-verify-domain-on-flathub-github-pages/banner.webp
  lqip: data:image/webp;base64,UklGRnwAAABXRUJQVlA4IHAAAACwAwCdASoUAAsAP1WQvlWxqaajMAgCMCqJZgCsABwib2fu6dtkAAD+6O2Q6U+qMGPyiEdQB4Wg1QAVIVeeffzessU6snpwes40ahjeStjSVVvTpLRVXtlFius/Bo9YqdIf3jr6kokDDvLNvc4pLQAA
  alt: Developer laptop displaying code and domain configuration
---

When you submit an application to [Flathub](https://flathub.org) using a reverse-DNS application ID tied to your own domain (for example, `bd.com.zihad.BengalDownloadManager`), Flathub requires you to prove ownership of the domain before awarding you the coveted **Verified Developer** badge.

Flathub accomplishes this through an RFC 8615 well-known URI check:

> *"If you intend to verify this submission, please confirm by uploading an empty `org.flathub.VerifiedApps.txt` file to `https://<your-domain>/.well-known/org.flathub.VerifiedApps.txt`."*

If your site is hosted on **GitHub Pages using Jekyll** (especially with custom GitHub Actions deployment workflows), you will quickly realize that simply dropping the file into a `.well-known/` folder and pushing to Git **will almost always fail with a 404 Not Found error**.

Here is the exact step-by-step fix to get your Flathub verification file deployed and live on GitHub Pages.

---

## Why GitHub Pages and Jekyll Break `.well-known`

There are three distinct layers where `.well-known` files get silently dropped:

1. **Jekyll default exclusions:** Jekyll automatically ignores any directory or file starting with a dot (`.`), treating them as private configuration files rather than site assets.
2. **Git ignore defaults:** Most standard `.gitignore` templates include `.*` to ignore hidden system files, which prevents Git from tracking `.well-known` altogether.
3. **GitHub Actions Pages artifact filtering:** The official `actions/upload-pages-artifact` action has a default setting (`include-hidden-files: false`) that runs a `tar` command with `--exclude=.[^/]*`, stripping every dot-folder from the production build artifact right before deployment!

Let's fix all three.

---

## Step 1: Create the Empty Verification File

At the root of your GitHub Pages repository, create the `.well-known` directory and add the empty verification file:

```bash
mkdir -p .well-known
touch .well-known/org.flathub.VerifiedApps.txt
```

Verify that the file is 0 bytes:

```bash
ls -la .well-known/
# Should output:
# -rw-r--r-- 1 user user 0 Oct 11 16:00 org.flathub.VerifiedApps.txt
```

---

## Step 2: Whitelist `.well-known` in `.gitignore`

If your `.gitignore` contains `.*` to ignore hidden files, unignore `.well-known/`:

```gitignore
# Hidden files
.*
!.git*
!.well-known/
!.nojekyll
```

This ensures Git tracks the directory and its contents without requiring forced commits (`git add -f`).

---

## Step 3: Tell Jekyll to Include `.well-known`

Open your `_config.yml` file and locate (or create) the `include` block. Add `.well-known` to the list:

```yaml
include:
  - ads.txt
  - .well-known
```

This tells the Jekyll build engine to copy the `.well-known` directory into the final output destination (`_site/.well-known/`) rather than discarding it.

---

## Step 4: The Crucial Fix in GitHub Actions (`pages-deploy.yml`)

This is the step that trips up almost everyone using custom GitHub Pages deployment workflows.

If your repository uses a workflow like `.github/workflows/pages-deploy.yml`, you will have an upload step using `actions/upload-pages-artifact`. By default, this action **ignores hidden files and directories**, even if Jekyll correctly generated them in `_site`!

Open `.github/workflows/pages-deploy.yml` and add `include-hidden-files: true`:

```yaml
      - name: Upload site artifact
        uses: actions/upload-pages-artifact@v5
        with:
          path: "_site${{ steps.pages.outputs.base_path }}"
          include-hidden-files: true # <-- REQUIRED for .well-known
```

Without this flag, the action runs:

```bash
tar --exclude=.[^/]* ...
```

which wipes out `_site/.well-known` right before uploading your site to GitHub's CDN.

---

## Step 5: Commit, Push, and Verify

Commit all changes and push to your main branch:

```bash
git add .well-known/org.flathub.VerifiedApps.txt _config.yml .gitignore .github/workflows/pages-deploy.yml
git commit -m "ci: add flathub domain verification and include hidden files"
git push origin main
```

Wait for the GitHub Actions deployment workflow to finish, then test the live endpoint from your terminal using `curl`:

```bash
curl -ILs https://your-domain.com/.well-known/org.flathub.VerifiedApps.txt
```

You should receive an immediate **`HTTP/2 200`** response with `content-length: 0`:

```http
HTTP/2 200 
server: GitHub.com
content-type: text/plain; charset=utf-8
content-length: 0
```

Once you see `HTTP/2 200`, head back to your Flathub pull request or app submission page and re-run the verification check. The bot will detect the file and grant your app verified status!
