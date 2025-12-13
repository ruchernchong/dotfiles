# dotfiles

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![Platform: macOS | Linux](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg?style=for-the-badge)](https://github.com/ruchernchong/dotfiles)
[![Shell: Zsh](https://img.shields.io/badge/Shell-Zsh-89E051.svg?style=for-the-badge)](https://www.zsh.org/)
[![Homebrew](https://img.shields.io/badge/Homebrew-2.0+-orange.svg?style=for-the-badge)](https://brew.sh/)
[![Docker](https://img.shields.io/badge/Docker-Testing-2496ED.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

</div>

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
- **Interactive Installation**: Customisable setup with profile selection and dry-run mode
- **Shell Configuration**: Oh-My-Zsh with Starship prompt and syntax highlighting
- **Package Management**: Homebrew Brewfile for consistent package installation with profile support (minimal/developer/full)
- **Git Integration**: Comprehensive git aliases and configuration
- **Node.js Management**: `fnm` for Node.js version management
- **Development Tools**: VSCode, cloud tools, databases, and utilities
- **Touch ID for Sudo**: Enable Touch ID authentication for sudo commands (macOS only)
- **Scheduled Maintenance**: Automated Homebrew and pnpm maintenance via crontab
- **Docker Testing**: Test setup scripts in isolated environment
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

- **Library Functions** (`lib/`): Shared utility libraries for platform detection, interactive prompts, backup management, and profile selection
- **Shell Scripts** (`shell/`): Modular setup scripts for different components (aliases, zsh, vim, Claude Code, crontab, Touch ID for sudo)
- **Setup Scripts** (`setup/`): Core installation scripts (Homebrew installation)
- **Configuration Files** (`config/`): Symlinked dotfiles (`.zshrc`, `.aliases`, `.vimrc`) and settings (`.claude/settings.json`, `crontab`)
- **Scripts** (`scripts/`): Utility scripts (Node.js symlink management)
- **Testing**: Docker-based testing infrastructure (`test-setup.sh`, `docker-compose.yml`, `Dockerfile`, `TESTING.md`)
- **Brewfile**: Homebrew package manifest with profile support (minimal, developer, full)

## Key Components

### Automated Setup Process
The `setup.sh` script provides both interactive and automated setup:

**Interactive mode** (default):
- Dry-run mode with `--dry-run` flag to preview changes
- Profile selection: minimal (~15 packages), developer (~40-50 packages), or full (~120 packages)
- Backup handling for existing dotfiles
- Crontab configuration for scheduled maintenance
- Node.js version manager selection (fnm/nvm/both)
- Python version selection (full profile only)
- Database installation options (developer/full profiles)

**Non-interactive mode** (`--no-interactive`):
- Uses default settings (full profile)
- Specify profile via `--profile=minimal|developer|full`

**Installation sequence**:
1. Collects user preferences (interactive mode only)
2. Makes all `.sh` scripts executable
3. Runs scripts in `setup/` directory (Homebrew installation)
4. Runs scripts in `shell/` directory (dotfile symlinking, crontab configuration)
5. Installs Homebrew packages via `brew bundle install` (using selected profile)

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

### Scheduled Tasks (Crontab)
```bash
# View current cron jobs
crontab -l

# Apply dotfiles crontab configuration
crontab $HOME/dotfiles/config/crontab

# View maintenance logs
tail -f /tmp/brew-weekly.log     # Weekly Homebrew updates (Sunday 2 AM)
tail -f /tmp/brew-cleanup.log    # Monthly cleanup (1st of month, 3:30 AM)
tail -f /tmp/brew-health.log     # Quarterly health checks (Jan/Apr/Jul/Oct, 4 AM)
tail -f /tmp/pnpm-cleanup.log    # Weekly pnpm store pruning (Monday 3 AM)
```

### Testing
```bash
# Test setup script with Docker (dry-run mode)
./test-setup.sh

# Test specific profile
./test-setup.sh minimal
./test-setup.sh developer
./test-setup.sh full

# Test all scenarios
./test-setup.sh all

# Interactive debugging
./test-setup.sh shell

# Clean up test containers
./test-setup.sh clean
```

For more details, see [TESTING.md](TESTING.md)

### Touch ID for Sudo (macOS only)
```bash
# Setup Touch ID for sudo commands
sudo zsh shell/sudo-touch-id/setup.sh

# Verify Touch ID configuration
zsh shell/sudo-touch-id/verify.sh

# Restore original PAM configuration
sudo zsh shell/sudo-touch-id/restore.sh
```

## Configurations

### Zsh Customisations

- **Oh-My-Zsh**: Custom configuration with Starship theme
- **Key plugins**:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - git
  - docker

### Claude Code Settings

User-level Claude Code settings are backed up and version-controlled:

- **Location**: `config/.claude/settings.json`
- **Symlinked to**: `~/.claude/settings.json`
- **Setup**: Automatically configured during `setup.sh` execution
- **Manual restore**: Run `source $HOME/dotfiles/shell/claude.sh` to restore the symlink

### Touch ID for Sudo (macOS only)

Enable Touch ID authentication for sudo commands:

- **Setup**: Modifies PAM configuration to enable Touch ID
- **Security**: Uses `/etc/pam.d/sudo_local` (survives macOS updates)
- **Requirements**: macOS 10.15 (Catalina) or later
- **Features**:
  - Interactive warning before making system changes
  - Verification script to test configuration
  - Restore script to revert to original configuration
  - Version checks to ensure compatibility

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

### Interactive Installation (Recommended)

The interactive setup guides you through customising your installation:

```bash
# Clone the repository
git clone https://github.com/ruchernchong/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles

# Preview what would be installed (dry-run mode)
./setup.sh --dry-run

# Run the interactive setup
./setup.sh
```

The interactive setup allows you to:
- Choose installation profile (minimal/developer/full)
  - **minimal**: Essential tools only (~15 packages)
  - **developer**: Development environment (~40-50 packages)
  - **full**: Complete installation (~120 packages)
- Select Node.js version manager (fnm/nvm/both)
- Choose Python version (3.13/3.12/3.11/all) - full profile only
- Configure backup options for existing files
- Customise database installations (PostgreSQL, Redis) - developer/full profiles
- Configure scheduled maintenance tasks (crontab)
- Preview changes before applying

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
