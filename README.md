# dotfiles

This repository contains dotfiles and scripts that I use to customise my macOS/Linux development workflow. Feel free to use this as a reference for your own setup.

![Terminal](terminal.png)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
  - [One-line Installation](#one-line-installation)
  - [Manual Installation](#manual-installation)
- [System Requirements](#system-requirements)
- [Architecture](#architecture)
- [Key Components](#key-components)
- [Development Environment](#development-environment)
- [Common Commands](#common-commands)
- [Configurations](#configurations)
- [Feedback](#feedback)
- [Licence](#licence)

## Overview

This is a personal dotfiles repository for macOS/Linux development environment setup. The repository contains shell configurations, aliases, automated setup scripts, and Homebrew package management for a consistent development environment across machines.

## Features

- **Automated Setup**: Complete development environment setup with a single command
- **Shell Configuration**: Oh-My-Zsh with Starship prompt and syntax highlighting
- **Package Management**: Homebrew Brewfile for consistent package installation
- **Git Integration**: Comprehensive git aliases and configuration
- **Node.js Management**: `fnm` for Node.js version management
- **Development Tools**: VSCode, cloud tools, databases, and utilities
- **Cross-platform**: Support for macOS and Linux

## System Requirements

### Supported Platforms

- macOS (10.15+)
- Linux (Ubuntu 20.04+, Fedora 33+)

### Prerequisites

- Zsh
- Git
- curl

## Architecture

- **Shell Scripts** (`shell/`): Modular setup scripts for different components (aliases, zsh, vim)
- **Setup Scripts** (`setup/`): Core installation scripts (Homebrew)
- **Configuration Files**: Symlinked dotfiles (`.zshrc`, `.aliases`)
- **Brewfile**: Homebrew package manifest for consistent package installation across machines

## Key Components

### Automated Setup Process
The `setup.sh` script executes in this order:
1. Makes all `.sh` scripts executable
2. Runs scripts in `setup/` directory (Homebrew installation)
3. Runs scripts in `shell/` directory (dotfile symlinking)
4. Installs Homebrew packages via `brew bundle install`

### Shell Configuration System
- **Zsh**: Oh-My-Zsh with syntax highlighting plugin
- **Theme**: Starship prompt
- **Node**: Uses `fnm` for Node.js version management
- **Environment**: Configured for development with PostgreSQL, Python, Android SDK

## Development Environment

### Key Tools Included
- **Development**: git, gh, nvm, pnpm, yarn, bun
- **Cloud**: vercel-cli, aws-sam-cli, pulumi, doctl
- **Databases**: postgresql@17, redis
- **Utilities**: jq, ripgrep, httpie, direnv
- **VSCode**: With comprehensive extension set

### Environment Variables
- `NEXT_TELEMETRY_DISABLED=1`: Disables Next.js telemetry
- `PNPM_HOME`: pnpm global package directory
- PostgreSQL and Android SDK paths configured

## Common Commands

### Package Management
```bash
# Install all Homebrew packages
brew bundle install

# Update Brewfile
brew bundle dump --force
```

### Shell Configuration
```bash
# Reload zsh configuration
zshreload  # alias for 'source $HOME/.zshrc'

# Edit zsh configuration
zshconfig  # alias for 'vi $HOME/.zshrc'
```

## Configurations

### Zsh Customisations

- **Oh-My-Zsh**: Custom configuration with Starship theme
- **Key plugins**:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - git
  - docker

### Git Aliases (Extensive Collection)

- `g` → `git`
- `gs` → `git status`
- `gcm` → `git checkout main`
- `glog` → formatted git log with graph
- `gp` → `git pull`
- `gps` → `git push`
- Full list available in `.aliases` file

## Installation

**Warning:** Do not blindly use these settings as they may override or modify your existing configuration. It is highly recommended to clone/fork this repository to another folder. Use at your own risk!

### One-line Installation

```bash
curl -L https://raw.githubusercontent.com/ruchernchong/dotfiles/master/install.sh | bash
```

### Manual Installation

```bash
# Clone and setup
git clone https://github.com/ruchernchong/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
chmod a+x setup.sh
source setup.sh
```

## Feedback

I welcome any feedback or suggestions by creating an [issue](https://github.com/ruchernchong/dotfiles/issues) or a [pull request](https://github.com/ruchernchong/dotfiles/pulls).

## Licence

This code is available under the [MIT Licence](LICENSE)
