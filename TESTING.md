# Testing the Dotfiles Setup

This directory contains Docker-based testing tools for validating the dotfiles setup process in an isolated environment.

## Quick Start

```bash
# Run dry-run test (safe, no changes)
./test-setup.sh

# Test minimal profile installation
./test-setup.sh minimal

# Test all scenarios
./test-setup.sh all

# Open interactive shell for debugging
./test-setup.sh shell
```

## Available Tests

| Command | Description |
|---------|-------------|
| `dry-run` | Preview setup without making changes (default) |
| `minimal` | Test minimal profile installation |
| `developer` | Test developer profile installation |
| `full` | Test full profile installation |
| `shell` | Open interactive bash shell in container |
| `all` | Run all test scenarios sequentially |
| `clean` | Remove all test containers and images |

## Manual Docker Commands

If you prefer using Docker directly:

```bash
# Build the image
docker compose build

# Run dry-run test
docker compose run --rm dry-run

# Run specific profile test
docker compose run --rm minimal
docker compose run --rm developer
docker compose run --rm full

# Interactive debugging
docker compose run --rm shell

# Clean up
docker compose down --rmi all --volumes
```

## What Gets Tested

The Docker environment tests:
- ✓ Shell script syntax and execution
- ✓ File symlinking logic
- ✓ Profile selection (minimal/developer/full)
- ✓ Non-interactive setup flow
- ✓ Error handling

## Known Limitations

**Alpine Linux vs macOS:**
- Homebrew installation will fail (Homebrew has limited Alpine support)
- macOS-specific tools and configurations won't work
- Some shell configurations may differ from zsh on macOS

**Purpose:**
This testing setup validates the **setup script logic** and **error handling**, not the full macOS Homebrew experience. For complete macOS testing, use:
- Local testing with `./setup.sh --dry-run`
- GitHub Actions with macOS runners
- macOS VMs (Tart, UTM, VirtualBox)

## Troubleshooting

### Permission Denied
```bash
chmod +x test-setup.sh
./test-setup.sh
```

### Docker Not Running
```bash
# Start Docker Desktop or Docker daemon first
docker ps
```

### Clean Start
```bash
./test-setup.sh clean
./test-setup.sh
```

## Environment Details

- **Base Image**: Alpine Linux (~5 MB)
- **Test User**: `testuser` (non-root)
- **Working Directory**: `/home/testuser/dotfiles`
- **Installed Packages**: bash, curl, git, sudo
