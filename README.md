# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem]&nbsp;
[![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

## Usage

Please see the [theme's docs](https://github.com/cotes2020/jekyll-theme-chirpy#documentation).

## Extra
Editor [QOwnNotes](https://flathub.org/apps/details/org.qownnotes.QOwnNotes).  
Fix space indent for code blocks: 3.  
Run Server: `bundle exec jekyll serve`  
Post image example: `![qownnotes-media-KjSyau]({{ BASE_PATH }}/assets/images/Screenshot_20230111_155335.png)`  
Dependencies:  
```bash
sudo apt-get install ruby-full build-essential zlib1g-dev ruby-bundler # ubuntu 22-04
sudo dnf install -y ruby ruby-devel rubygem-bundler && sudo dnf groupinstall -y "Development Tools" # fedora

echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# gem install jekyll bundler
git clone https://github.com/tazihad/tazihad.github.io.git
cd tazihad.github.io
bundle install
bundle exec jekyll serve
```

Generate icons: 
1. [Favicon Generator](https://www.favicon-generator.org/)
2. [Real Favicon Generator](https://realfavicongenerator.net/)
3. [Iconifier](https://iconifier.net/)


### Important resources

cdn landing page: https://www.jsdelivr.com/package/gh/tazihad/tazihad.github.io  
cdn: https://cdn.jsdelivr.net/gh/tazihad/tazihad.github.io/  
cdn purge cache: https://www.jsdelivr.com/tools/purge



## License

This work is published under [MIT][mit] License.

[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[CD]: https://en.wikipedia.org/wiki/Continuous_deployment
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE
