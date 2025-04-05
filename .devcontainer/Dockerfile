# Use the official Ubuntu 20.04 as the base image
FROM mcr.microsoft.com/devcontainers/base:bookworm

# Install any additional dependencies here
RUN apt-get update && apt-get install -y \
    build-essential \
    ruby-full \
    ruby-bundler \
    zlib1g-dev


# Set environment variables for Ruby Gems (applies to all users/shells)
ENV GEM_HOME="/home/vscode/gems"
ENV PATH="$GEM_HOME/bin:$PATH"

# Ensure the GEM_HOME directory exists and owned by the right user
RUN mkdir -p /home/vscode/gems && chown -R vscode:vscode /home/vscode/gems


