#!/bin/sh

# This script is used to run the Jekyll server in a development container.
bundle exec jekyll serve --host 0.0.0.0 --drafts --unpublished --future --livereload --incremental