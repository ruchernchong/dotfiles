# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language and Style Guidelines

- **Language**: Use English (UK) spelling and conventions throughout this entire project
- **Documentation**: All comments, documentation, and text should follow British English standards

## Repository Overview

This is a personal dotfiles repository for macOS/Linux development environment setup. The repository contains shell configurations, aliases, automated setup scripts, and Homebrew package management.

## Architecture

- **Shell Scripts** (`shell/`): Modular setup scripts for different components (aliases, zsh, vim, powerlevel10k)
- **Setup Scripts** (`setup/`): Core installation scripts (Homebrew)
- **Configuration Files**: Symlinked dotfiles (`.zshrc`, `.aliases`, `.p10k.zsh`)
- **Brewfile**: Homebrew package manifest for consistent package installation across machines

## Common Commands

### Initial Setup
```bash
# Clone and setup (manual)
git clone https://github.com/ruchernchong/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles
chmod a+x setup.sh
source setup.sh

# One-line installation
curl -L https://raw.githubusercontent.com/ruchernchong/dotfiles/master/install.sh | bash
```

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

## Key Components

### Automated Setup Process
The `setup.sh` script executes in this order:
1. Makes all `.sh` scripts executable
2. Runs scripts in `setup/` directory (Homebrew installation)
3. Runs scripts in `shell/` directory (dotfile symlinking)
4. Installs Homebrew packages via `brew bundle install`

### Shell Configuration System
- **Zsh**: Oh-My-Zsh with syntax highlighting plugin
- **Theme**: Starship prompt with Powerlevel10k fallback
- **Node**: Uses `fnm` for Node.js version management
- **Environment**: Configured for development with PostgreSQL, Python, Android SDK

### Git Aliases
Extensive git aliases defined in `.aliases`:
- `g` → `git`
- `gs` → `git status`
- `gcm` → `git checkout main`
- `glog` → formatted git log with graph
- Full list available in `.aliases` file

## Development Environment

### Supported Platforms
- macOS (10.15+)
- Linux (Ubuntu 20.04+, Fedora 33+)

### Key Tools Included
- Development: git, gh, nvm, pnpm, yarn, bun
- Cloud: vercel-cli, aws-sam-cli, pulumi, doctl
- Databases: postgresql@17, redis
- Utilities: jq, ripgrep, httpie, direnv
- VSCode with comprehensive extension set

### Environment Variables
- `HOMEBREW_NO_AUTO_UPDATE=1`: Prevents automatic Homebrew updates
- `NEXT_TELEMETRY_DISABLED=1`: Disables Next.js telemetry
- `PNPM_HOME`: pnpm global package directory
- PostgreSQL and Android SDK paths configured