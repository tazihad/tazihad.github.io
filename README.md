# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem] [![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

A minimal starter site using the [Chirpy Jekyll theme][chirpy]. This repository contains configuration, assets and notes to quickly start a blog or personal site with Chirpy.

---

## Table of contents

- [Overview](#overview)
- [Quick start](#quick-start)
- [Install dependencies](#install-dependencies)
- [Run locally](#run-locally)
- [Content & assets](#content--assets)
- [Favicon / icons](#favicon--icons)
- [CDN (jsDelivr)](#cdn-jsdelivr)
- [Editor notes (QOwnNotes)](#editor-notes-qownnotes)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Important resources](#important-resources)
- [License](#license)

---

## Overview

This repo demonstrates a simple site built on the [jekyll-theme-chirpy][chirpy] theme. Use it as a starting point for your own blog or documentation site. The theme provides responsive layouts, SEO optimizations and many configuration options — see the upstream theme documentation for details.

## Quick start

1. Clone this repository:
   ```bash
   git clone https://github.com/tazihad/tazihad.github.io.git
   cd tazihad.github.io
   ```
2. Install Ruby gems (see next section for platform-specific instructions).
3. Install dependencies and start a local server:
   ```bash
   bundle install
   bundle exec jekyll serve
   ```
4. Open http://127.0.0.1:4000 in your browser.

## Install dependencies

Ubuntu (example for 22.04):
```bash
sudo apt-get update
sudo apt-get install -y build-essential zlib1g-dev ruby-bundler ruby-full
```

Fedora:
```bash
sudo dnf install -y @development-tools
sudo dnf install -y gcc-c++ ruby ruby-devel rubygem-bundler
```

(Optional) Install Ruby gems to a user-local directory to avoid sudo:
```bash
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Then install project gems:
```bash
bundle install
```

## Run locally

Start the Jekyll dev server:
```bash
bundle exec jekyll serve
```
By default the server is available at http://127.0.0.1:4000. Use `--watch` to auto-regenerate on changes (this is on by default with `jekyll serve`).

## Content & assets

- Posts go in `_posts/` with standard Jekyll front matter.
- Site images and static assets are typically stored in `assets/images/` (or the path configured in `_config.yml`).
- Example post image usage:
  ```markdown
  ![Screenshot]({{ site.baseurl }}/assets/images/Screenshot_20230111_155335.png)
  ```
  For GitHub Pages or jsDelivr CDN, you may prefer:
  ```markdown
  ![Screenshot](https://cdn.jsdelivr.net/gh/tazihad/tazihad.github.io/assets/images/Screenshot_20230111_155335.png)
  ```

Notes:
- Use `{{ site.baseurl }}` and `{{ site.url }}` (Jekyll variables) in templates or markdown to build correct absolute/relative paths.
- If you used `{{ BASE_PATH }}` from other tooling, replace it with the appropriate Jekyll variable for consistency.

## Favicon / icons

Generate and add favicons using one of:
- [Favicon Generator](https://www.favicon-generator.org/)
- [Real Favicon Generator](https://realfavicongenerator.net/)
- [Iconifier](https://iconifier.net/)

Follow the generator instructions and include the generated HTML/snippet into your site's `_includes/head.html` or the appropriate layout partial.

## CDN (jsDelivr)

This site is available via jsDelivr:
- Landing page: [https://www.jsdelivr.com/package/gh/tazihad/tazihad.github.io](https://www.jsdelivr.com/package/gh/tazihad/tazihad.github.io)
- CDN root: [https://cdn.jsdelivr.net/gh/tazihad/tazihad.github.io/](https://cdn.jsdelivr.net/gh/tazihad/tazihad.github.io/)
- Purge CDN cache: [https://www.jsdelivr.com/tools/purge](https://www.jsdelivr.com/tools/purge)

If you update assets and need them refreshed, use the purge tool above or change filenames (cache-busting).

## Editor notes (QOwnNotes)

- I use [QOwnNotes](https://flathub.org/apps/details/org.qownnotes.QOwnNotes) for editing markdown.
- If you export or copy blocks from QOwnNotes, you may need to adjust indentation for fenced code blocks. In my setup I use 3 leading spaces for code-block indentation in specific exports — prefer fenced triple backticks (```) for reliable rendering across tools and Jekyll.

## Troubleshooting

- "Changes not showing" — ensure the dev server is running and you rebuilt the site (`bundle exec jekyll serve`); clear browser cache or CDN caches if using jsDelivr.
- Bundler errors — verify Ruby version and that gems installed without sudo if GEM_HOME was changed.
- Rendering differences — check whether you're using Kramdown or another Markdown engine in `_config.yml`.

## Contributing

Feel free to open issues or PRs with improvements, fixes, or documentation updates. Keep changes small and focused and provide a short description of what the change does and why.

## Important resources

- Theme documentation: [Chirpy theme docs](https://github.com/cotes2020/jekyll-theme-chirpy#documentation)
- Gem: [jekyll-theme-chirpy on RubyGems][gem]
- jsDelivr purge: [jsDelivr purge tool](https://www.jsdelivr.com/tools/purge)

## License

This work is published under the [MIT][mit] License.

---

References
- [gem]: https://rubygems.org/gems/jekyll-theme-chirpy
- [chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
- [mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE
