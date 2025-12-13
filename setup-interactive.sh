#!/bin/zsh

# Interactive Setup Orchestrator
# Collects user preferences and generates .setup-state file

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/interactive.sh"
source "$SCRIPT_DIR/lib/backup.sh"
source "$SCRIPT_DIR/lib/brewfile-profiles.sh"

# Initialize state file path
STATE_FILE="$HOME/dotfiles/.setup-state"

# Welcome message
echo ""
echo "🚀 Starting interactive dotfiles setup"
echo ""
echo "Welcome! This will configure your development environment."
echo "You'll be asked a few questions to customise the installation."
echo ""

# =============================================================================
# INSTALLATION SCOPE
# =============================================================================

print_section "INSTALLATION SCOPE"

list_available_profiles
echo ""

# Prompt for profile selection
echo "Choose installation profile:"
profile_choice=$(prompt_number "Selection" 2 3)

case "$profile_choice" in
    1) INSTALL_PROFILE="minimal" ;;
    2) INSTALL_PROFILE="developer" ;;
    3) INSTALL_PROFILE="full" ;;
esac

echo ""
echo "✓ Selected profile: $INSTALL_PROFILE"

# =============================================================================
# EXISTING CONFIGURATION
# =============================================================================

print_section "EXISTING CONFIGURATION"

# Check for existing dotfiles
conflicts=$(list_conflicts)

if [[ -n "$conflicts" ]]; then
    echo "Found existing dotfiles:"
    echo "$conflicts" | while read -r file; do
        echo "  • $(basename "$file")"
    done
    echo ""

    # Ask about backup
    if prompt_yes_no "Backup existing files?" "Y"; then
        BACKUP_EXISTING=true
        BACKUP_DIR=$(create_backup_dir)
        echo "✓ Backups will be saved to: $BACKUP_DIR"
        SKIP_EXISTING=false
    else
        # Ask if they want to skip or overwrite
        echo ""
        if prompt_yes_no "Skip existing files (keep current configurations)?" "N"; then
            BACKUP_EXISTING=false
            BACKUP_DIR=""
            SKIP_EXISTING=true
            echo "✓ Existing files will be kept"
        else
            BACKUP_EXISTING=false
            BACKUP_DIR=""
            SKIP_EXISTING=false
            echo "✓ Existing files will be overwritten"
        fi
    fi
else
    echo "No existing dotfiles found - fresh installation"
    BACKUP_EXISTING=false
    BACKUP_DIR=""
    SKIP_EXISTING=false
fi

# =============================================================================
# CRONTAB CONFIGURATION
# =============================================================================

print_section "CRONTAB"

# Check if crontab exists
if crontab -l > /dev/null 2>&1; then
    job_count=$(crontab -l 2>/dev/null | grep -v "^#" | grep -v "^$" | wc -l | tr -d ' ')
    echo "Found existing crontab with $job_count job(s)."
    echo ""
    echo "This will add:"
    print_list \
        "Weekly Homebrew updates (Sunday 2 AM)" \
        "Monthly Homebrew cleanup (1st of month, 3:30 AM)" \
        "Quarterly Homebrew health checks" \
        "Weekly pnpm store pruning (Monday 3 AM)"
    echo ""
    echo "Your existing jobs will be backed up to ~/.crontab.backup"
    echo ""

    if prompt_yes_no "Replace crontab?" "Y"; then
        REPLACE_CRONTAB=true
        echo "✓ Crontab will be replaced"
    else
        REPLACE_CRONTAB=false
        echo "✓ Crontab will be kept as-is"
    fi
else
    echo "No existing crontab found."
    echo ""
    echo "The following scheduled tasks will be added:"
    print_list \
        "Weekly Homebrew updates (Sunday 2 AM)" \
        "Monthly Homebrew cleanup (1st of month, 3:30 AM)" \
        "Quarterly Homebrew health checks" \
        "Weekly pnpm store pruning (Monday 3 AM)"
    echo ""

    if prompt_yes_no "Install crontab?" "Y"; then
        REPLACE_CRONTAB=true
        echo "✓ Crontab will be installed"
    else
        REPLACE_CRONTAB=false
        echo "✓ Skipping crontab installation"
    fi
fi

# =============================================================================
# DEVELOPMENT TOOLS
# =============================================================================

print_section "DEVELOPMENT TOOLS"

# Node.js version manager
echo "Node.js version manager:"
echo "  1) fnm (Fast Node Manager - recommended, lighter)"
echo "  2) nvm (Node Version Manager - traditional)"
echo "  3) Both"
echo ""
node_choice=$(prompt_number "Selection" 1 3)

case "$node_choice" in
    1) SELECTED_NODE_MANAGER="fnm" ;;
    2) SELECTED_NODE_MANAGER="nvm" ;;
    3) SELECTED_NODE_MANAGER="both" ;;
esac

echo "✓ Selected: $SELECTED_NODE_MANAGER"
echo ""

# Python version (only for full profile)
if [[ "$INSTALL_PROFILE" == "full" ]]; then
    echo "Primary Python version:"
    echo "  1) Python 3.13 (latest)"
    echo "  2) Python 3.12"
    echo "  3) Python 3.11"
    echo "  4) All versions"
    echo ""
    python_choice=$(prompt_number "Selection" 1 4)

    case "$python_choice" in
        1) SELECTED_PYTHON_VERSION="3.13" ;;
        2) SELECTED_PYTHON_VERSION="3.12" ;;
        3) SELECTED_PYTHON_VERSION="3.11" ;;
        4) SELECTED_PYTHON_VERSION="all" ;;
    esac

    echo "✓ Selected: Python $SELECTED_PYTHON_VERSION"
    echo ""
else
    # For minimal and developer profiles, default to 3.13
    SELECTED_PYTHON_VERSION="3.13"
fi

# Databases (for developer and full profiles)
if [[ "$INSTALL_PROFILE" != "minimal" ]]; then
    echo "Database tools:"
    print_list "PostgreSQL 17" "Redis"
    echo ""

    if prompt_yes_no "Install database tools?" "Y"; then
        INSTALL_DATABASES=true
        echo "✓ Databases will be installed"
    else
        INSTALL_DATABASES=false
        echo "✓ Skipping databases"
    fi
else
    INSTALL_DATABASES=false
fi

# =============================================================================
# CONFIRMATION
# =============================================================================

print_section "CONFIRMATION"

echo "Ready to proceed with the following:"
echo ""
echo "  Installation profile: $INSTALL_PROFILE"

if [[ "$BACKUP_EXISTING" == "true" ]]; then
    echo "  Existing files: Backup to $BACKUP_DIR"
elif [[ "$SKIP_EXISTING" == "true" ]]; then
    echo "  Existing files: Keep existing (skip)"
else
    echo "  Existing files: Overwrite"
fi

if [[ "$REPLACE_CRONTAB" == "true" ]]; then
    echo "  Crontab: Replace (backup existing)"
else
    echo "  Crontab: Keep existing"
fi

echo "  Node manager: $SELECTED_NODE_MANAGER"
echo "  Python: $SELECTED_PYTHON_VERSION"

if [[ "$INSTALL_DATABASES" == "true" ]]; then
    echo "  Databases: PostgreSQL 17, Redis"
else
    echo "  Databases: Skip"
fi

echo ""

if ! prompt_yes_no "Proceed?" "Y"; then
    echo ""
    echo "❌ Setup cancelled by user"
    exit 1
fi

# =============================================================================
# GENERATE STATE FILE
# =============================================================================

echo ""
echo "Generating setup state..."

cat > "$STATE_FILE" << EOF
# Dotfiles Setup State
# Generated: $(date)
# This file is automatically deleted after setup completes

# Installation
INSTALL_PROFILE="$INSTALL_PROFILE"

# Backup
BACKUP_EXISTING=$BACKUP_EXISTING
BACKUP_DIR="$BACKUP_DIR"
SKIP_EXISTING=$SKIP_EXISTING

# Crontab
REPLACE_CRONTAB=$REPLACE_CRONTAB

# Development tools
SELECTED_NODE_MANAGER="$SELECTED_NODE_MANAGER"
SELECTED_PYTHON_VERSION="$SELECTED_PYTHON_VERSION"
INSTALL_DATABASES=$INSTALL_DATABASES
EOF

echo "✓ Configuration saved"
echo ""
