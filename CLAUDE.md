# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language and Style Guidelines

- **Language**: Use English (UK) spelling and conventions throughout this entire project
- **Documentation**: All comments, documentation, and text should follow British English standards

## Repository Overview

This is a personal dotfiles repository for macOS/Linux development environment setup. The repository contains shell configurations, aliases, automated setup scripts, and Homebrew package management.

## Architecture

- **Library Functions** (`lib/`): Shared utility libraries
  - `platform.sh`: Platform detection (macOS/Linux) and OS-specific logic
  - `interactive.sh`: Interactive prompts, colours, and formatting utilities
  - `backup.sh`: File backup and symlink management
  - `brewfile-profiles.sh`: Installation profile management for minimal/developer/full setups
- **Shell Scripts** (`shell/`): Modular setup scripts for different components
  - `aliases.sh`: Symlinks shell aliases configuration
  - `zshrc.sh`: Symlinks Zsh configuration
  - `vim.sh`: Symlinks Vim configuration
  - `claude.sh`: Symlinks Claude Code settings and global CLAUDE.md
  - `crontab.sh`: Configures scheduled maintenance tasks
  - `terminal.sh`: macOS Terminal.app configuration (macOS only)
  - `misc.sh`: Additional miscellaneous configurations
  - `sudo-touch-id/`: Touch ID for sudo authentication (macOS only)
    - `setup.sh`: Configures Touch ID authentication for sudo commands
    - `verify.sh`: Verifies Touch ID configuration
    - `restore.sh`: Restores original PAM configuration
- **Setup Scripts** (`setup/`): Core installation scripts
  - `install-homebrew.sh`: Homebrew installation for macOS/Linux
- **Configuration Files** (`config/`): Symlinked dotfiles and settings
  - `.zshrc`, `.aliases`, `.vimrc`: Shell and editor configurations
  - `crontab`: Scheduled maintenance job definitions
  - `.claude/settings.json`: Claude Code user settings
  - `.claude/CLAUDE.md`: Global Claude Code instructions
  - `setup-profiles/`: Installation profile Brewfiles (minimal.brewfile, developer.brewfile)
- **Scripts** (`scripts/`): Utility scripts
  - `link-node.sh`: Node.js symlink management
- **Testing** (`test-setup.sh`, `docker-compose.yml`, `Dockerfile`, `TESTING.md`): Docker-based testing infrastructure for validating setup scripts
- **Brewfile**: Homebrew package manifest for consistent package installation across machines (full installation)

## Common Commands

### Initial Setup

```bash
# Clone and setup (interactive - recommended)
git clone https://github.com/ruchernchong/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles

# Preview installation (dry-run mode)
./setup.sh --dry-run   # or -n

# Run interactive setup
./setup.sh

# Skip interactive prompts (uses defaults)
./setup.sh --no-interactive

# Use specific profile without prompts
./setup.sh --no-interactive --profile=minimal

# OR: One-line installation
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

### Touch ID for Sudo (macOS only)

```bash
# Setup Touch ID for sudo commands
sudo zsh shell/sudo-touch-id/setup.sh

# Verify Touch ID configuration
zsh shell/sudo-touch-id/verify.sh

# Restore original PAM configuration
sudo zsh shell/sudo-touch-id/restore.sh
```

## Key Components

### Setup Process

The `setup.sh` script provides both interactive and automated setup:

**Interactive mode** (default):
- **Dry-run mode**: Use `--dry-run` or `-n` flag to preview configuration without making changes
- **Profile selection**: Choose between minimal, developer, or full installation
  - **minimal**: Essential tools only (~15 packages) - Git, GitHub CLI, shell tools, Node.js (fnm, pnpm), utilities
  - **developer**: Development environment (~40-50 packages) - Everything in minimal + databases, containers, cloud tools, essential VSCode extensions
  - **full**: Complete installation (~120 packages) - Everything in developer + multiple Python versions, additional cloud SDKs, all VSCode extensions, media tools
- **Backup handling**: Options to backup, skip, or overwrite existing dotfiles
- **Crontab management**: Configure scheduled maintenance tasks
- **Tool selection**: Choose Node.js version manager (fnm/nvm/both)
- **Python version**: Select primary Python version (3.13/3.12/3.11/all) - only for full profile
- **Database options**: Select whether to install PostgreSQL and Redis - only for developer and full profiles

**Non-interactive mode** (`--no-interactive`):
- Uses default settings (full profile)
- Can specify profile via `--profile=minimal|developer|full`

**Installation sequence**:
1. Collects user preferences (interactive mode only)
2. Makes all `.sh` scripts executable
3. Runs scripts in `setup/` directory (Homebrew installation)
4. Runs scripts in `shell/` directory (dotfile symlinking, crontab configuration)
5. Installs Homebrew packages via `brew bundle install`

### Shell Configuration System

- **Zsh**: Oh-My-Zsh with syntax highlighting plugin
- **Theme**: Starship prompt
- **Node**: Uses `fnm` for Node.js version management
- **Environment**: Configured for development with PostgreSQL, Python, Android SDK

### Claude Code Settings

User-level Claude Code settings and global instructions are backed up and version-controlled:

- **Settings Location**: `config/.claude/settings.json` → symlinked to `~/.claude/settings.json`
- **Global Instructions**: `config/.claude/CLAUDE.md` → symlinked to `~/.claude/CLAUDE.md`
- **Setup**: Automatically configured via `shell/claude.sh` during `setup.sh` execution
- **Manual restore**: Run `source $HOME/dotfiles/shell/claude.sh` to restore the symlinks

### Git Aliases

Extensive git aliases defined in `.aliases`:

- `g` → `git`
- `gs` → `git status`
- `gcm` → `git checkout main`
- `glog` → formatted git log with graph
- Full list available in `.aliases` file

### Scheduled Maintenance

Automated maintenance tasks via crontab:

- **Weekly**:
  - Homebrew update check (Sundays 2 AM)
  - pnpm store pruning (Mondays 3 AM)
- **Monthly**: Homebrew cleanup (1st of month, 3:30 AM)
- **Quarterly**: Homebrew health diagnostics (Jan/Apr/Jul/Oct, 4 AM)
- **Logs**: All maintenance logged to `/tmp/` for review

### Touch ID for Sudo (macOS only)

Enable Touch ID authentication for sudo commands:

- **Setup**: Modifies PAM configuration to enable Touch ID
- **Security**: Uses `/etc/pam.d/sudo_local` (survives macOS updates)
- **Requirements**: macOS 10.15 (Catalina) or later
- **Verification**: Includes verify script to test configuration
- **Restore**: Can restore original configuration if needed

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

- `NEXT_TELEMETRY_DISABLED=1`: Disables Next.js telemetry
- `PNPM_HOME`: pnpm global package directory
- PostgreSQL and Android SDK paths configured
