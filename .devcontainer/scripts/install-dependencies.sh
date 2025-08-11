#!/bin/sh

echo "Installing dependencies..."
echo "Installing gems only for user account to avoid permission issues."

bundle config set --local path 'vendor/bundle'
bundle install

echo "Dependencies installed."