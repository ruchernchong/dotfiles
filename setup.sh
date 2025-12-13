#!/bin/zsh

# Dotfiles Setup Script
# Configures macOS/Linux development environment with optional interactive mode

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source required libraries
source "$SCRIPT_DIR/lib/interactive.sh"
source "$SCRIPT_DIR/lib/backup.sh"
source "$SCRIPT_DIR/lib/brewfile-profiles.sh"

# =============================================================================
# ARGUMENT PARSING
# =============================================================================

INTERACTIVE_MODE=true
DRY_RUN=false
INSTALL_PROFILE="full"

for arg in "$@"; do
    case $arg in
        --no-interactive)
            INTERACTIVE_MODE=false
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --profile=*)
            INSTALL_PROFILE="${arg#*=}"
            shift
            ;;
    esac
done

export INTERACTIVE_MODE
export INSTALL_PROFILE

# =============================================================================
# INTERACTIVE SETUP
# =============================================================================

if [[ "$INTERACTIVE_MODE" == "true" ]]; then
    # Welcome message
    echo ""
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${COLOUR_BRIGHT_YELLOW}${COLOUR_BOLD}🔍 DRY RUN MODE - No changes will be made${COLOUR_RESET}"
        echo ""
    fi
    echo -e "${COLOUR_BRIGHT_CYAN}${COLOUR_BOLD}🚀 Starting interactive dotfiles setup${COLOUR_RESET}"
    echo ""
    echo -e "${COLOUR_WHITE}Welcome! This will configure your development environment.${COLOUR_RESET}"
    echo -e "${COLOUR_WHITE}You'll be asked a few questions to customise the installation.${COLOUR_RESET}"
    if [[ "$DRY_RUN" == "true" ]]; then
        echo ""
        echo -e "${COLOUR_DIM}Running in dry-run mode - your selections will be shown but not applied.${COLOUR_RESET}"
    fi
    echo ""

    # -------------------------------------------------------------------------
    # EXISTING CONFIGURATION
    # -------------------------------------------------------------------------

    print_section "EXISTING CONFIGURATION"

    conflicts=$(list_conflicts)

    if [[ -n "$conflicts" ]]; then
        echo -e "${COLOUR_YELLOW}Found existing dotfiles:${COLOUR_RESET}"
        echo "$conflicts" | while read -r file; do
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} $(basename "$file")"
        done
        echo ""

        if prompt_yes_no "Backup existing files?" "Y"; then
            BACKUP_EXISTING=true
            BACKUP_DIR=$(create_backup_dir)
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Backups will be saved to: ${COLOUR_CYAN}$BACKUP_DIR${COLOUR_RESET}"
            SKIP_EXISTING=false
        else
            echo ""
            if prompt_yes_no "Skip existing files (keep current configurations)?" "N"; then
                BACKUP_EXISTING=false
                BACKUP_DIR=""
                SKIP_EXISTING=true
                echo -e "${COLOUR_BRIGHT_GREEN}✓ Existing files will be kept${COLOUR_RESET}"
            else
                BACKUP_EXISTING=false
                BACKUP_DIR=""
                SKIP_EXISTING=false
                echo -e "${COLOUR_BRIGHT_GREEN}✓ Existing files will be overwritten${COLOUR_RESET}"
            fi
        fi
    else
        # Check if dotfiles are already configured vs fresh installation
        already_configured=false
        if [[ -L "$HOME/.zshrc" ]] && [[ "$(readlink "$HOME/.zshrc")" == "$HOME/dotfiles/"* ]]; then
            already_configured=true
        fi

        if [[ "$already_configured" == "true" ]]; then
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Your dotfiles are already set up correctly!${COLOUR_RESET}"
            echo ""

            if ! prompt_yes_no "Continue with setup anyway?" "N"; then
                echo ""
                echo -e "${COLOUR_BRIGHT_CYAN}Setup cancelled - your dotfiles are already configured.${COLOUR_RESET}"
                exit 0
            fi
        else
            echo -e "${COLOUR_GREEN}No existing dotfiles found - fresh installation${COLOUR_RESET}"
        fi

        BACKUP_EXISTING=false
        BACKUP_DIR=""
        SKIP_EXISTING=false
    fi

    # -------------------------------------------------------------------------
    # INSTALLATION SCOPE
    # -------------------------------------------------------------------------

    print_section "INSTALLATION SCOPE"

    list_available_profiles
    echo ""

    echo -e "${COLOUR_CYAN}Choose installation profile:${COLOUR_RESET}"
    profile_choice=$(prompt_number "Selection" 2 3)

    case "$profile_choice" in
        1) INSTALL_PROFILE="minimal" ;;
        2) INSTALL_PROFILE="developer" ;;
        3) INSTALL_PROFILE="full" ;;
    esac

    echo ""
    echo -e "${COLOUR_BRIGHT_GREEN}✓ Selected profile: ${COLOUR_BOLD}$INSTALL_PROFILE${COLOUR_RESET}"

    # -------------------------------------------------------------------------
    # CRONTAB CONFIGURATION
    # -------------------------------------------------------------------------

    print_section "CRONTAB"

    if crontab -l > /dev/null 2>&1; then
        job_count=$(crontab -l 2>/dev/null | grep -v "^#" | grep -v "^$" | wc -l | tr -d ' ')
        echo -e "${COLOUR_YELLOW}Found existing crontab with ${COLOUR_BOLD}$job_count${COLOUR_RESET}${COLOUR_YELLOW} job(s).${COLOUR_RESET}"
        echo ""
        echo -e "${COLOUR_CYAN}This will add:${COLOUR_RESET}"
        print_list \
            "Weekly Homebrew updates (Sunday 2 AM)" \
            "Monthly Homebrew cleanup (1st of month, 3:30 AM)" \
            "Quarterly Homebrew health checks" \
            "Weekly pnpm store pruning (Monday 3 AM)"
        echo ""
        echo -e "${COLOUR_DIM}Your existing jobs will be backed up to ~/.crontab.backup${COLOUR_RESET}"
        echo ""

        if prompt_yes_no "Replace crontab?" "Y"; then
            REPLACE_CRONTAB=true
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Crontab will be replaced${COLOUR_RESET}"
        else
            REPLACE_CRONTAB=false
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Crontab will be kept as-is${COLOUR_RESET}"
        fi
    else
        echo -e "${COLOUR_GREEN}No existing crontab found.${COLOUR_RESET}"
        echo ""
        echo -e "${COLOUR_CYAN}The following scheduled tasks will be added:${COLOUR_RESET}"
        print_list \
            "Weekly Homebrew updates (Sunday 2 AM)" \
            "Monthly Homebrew cleanup (1st of month, 3:30 AM)" \
            "Quarterly Homebrew health checks" \
            "Weekly pnpm store pruning (Monday 3 AM)"
        echo ""

        if prompt_yes_no "Install crontab?" "Y"; then
            REPLACE_CRONTAB=true
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Crontab will be installed${COLOUR_RESET}"
        else
            REPLACE_CRONTAB=false
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Skipping crontab installation${COLOUR_RESET}"
        fi
    fi

    # -------------------------------------------------------------------------
    # DEVELOPMENT TOOLS
    # -------------------------------------------------------------------------

    print_section "DEVELOPMENT TOOLS"

    # Node.js version manager
    echo -e "${COLOUR_CYAN}Node.js version manager:${COLOUR_RESET}"
    echo -e "  ${COLOUR_WHITE}1)${COLOUR_RESET} fnm (Fast Node Manager - ${COLOUR_GREEN}recommended${COLOUR_RESET}, lighter)"
    echo -e "  ${COLOUR_WHITE}2)${COLOUR_RESET} nvm (Node Version Manager - traditional)"
    echo -e "  ${COLOUR_WHITE}3)${COLOUR_RESET} Both"
    echo ""
    node_choice=$(prompt_number "Selection" 1 3)

    case "$node_choice" in
        1) SELECTED_NODE_MANAGER="fnm" ;;
        2) SELECTED_NODE_MANAGER="nvm" ;;
        3) SELECTED_NODE_MANAGER="both" ;;
    esac

    echo -e "${COLOUR_BRIGHT_GREEN}✓ Selected: ${COLOUR_BOLD}$SELECTED_NODE_MANAGER${COLOUR_RESET}"
    echo ""

    # Python version (only for full profile)
    if [[ "$INSTALL_PROFILE" == "full" ]]; then
        echo -e "${COLOUR_CYAN}Primary Python version:${COLOUR_RESET}"
        echo -e "  ${COLOUR_WHITE}1)${COLOUR_RESET} Python 3.13 ${COLOUR_DIM}(latest)${COLOUR_RESET}"
        echo -e "  ${COLOUR_WHITE}2)${COLOUR_RESET} Python 3.12"
        echo -e "  ${COLOUR_WHITE}3)${COLOUR_RESET} Python 3.11"
        echo -e "  ${COLOUR_WHITE}4)${COLOUR_RESET} All versions"
        echo ""
        python_choice=$(prompt_number "Selection" 1 4)

        case "$python_choice" in
            1) SELECTED_PYTHON_VERSION="3.13" ;;
            2) SELECTED_PYTHON_VERSION="3.12" ;;
            3) SELECTED_PYTHON_VERSION="3.11" ;;
            4) SELECTED_PYTHON_VERSION="all" ;;
        esac

        echo -e "${COLOUR_BRIGHT_GREEN}✓ Selected: ${COLOUR_BOLD}Python $SELECTED_PYTHON_VERSION${COLOUR_RESET}"
        echo ""
    else
        SELECTED_PYTHON_VERSION="3.13"
    fi

    # Databases (for developer and full profiles)
    if [[ "$INSTALL_PROFILE" != "minimal" ]]; then
        echo -e "${COLOUR_CYAN}Database tools:${COLOUR_RESET}"
        print_list "PostgreSQL 17" "Redis"
        echo ""

        if prompt_yes_no "Install database tools?" "Y"; then
            INSTALL_DATABASES=true
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Databases will be installed${COLOUR_RESET}"
        else
            INSTALL_DATABASES=false
            echo -e "${COLOUR_BRIGHT_GREEN}✓ Skipping databases${COLOUR_RESET}"
        fi
    else
        INSTALL_DATABASES=false
    fi

    # -------------------------------------------------------------------------
    # CONFIRMATION
    # -------------------------------------------------------------------------

    print_section "CONFIRMATION"

    echo -e "${COLOUR_WHITE}Ready to proceed with the following:${COLOUR_RESET}"
    echo ""
    echo -e "  ${COLOUR_CYAN}Installation profile:${COLOUR_RESET} ${COLOUR_BOLD}$INSTALL_PROFILE${COLOUR_RESET}"

    if [[ "$BACKUP_EXISTING" == "true" ]]; then
        echo -e "  ${COLOUR_CYAN}Existing files:${COLOUR_RESET} Backup to ${COLOUR_DIM}$BACKUP_DIR${COLOUR_RESET}"
    elif [[ "$SKIP_EXISTING" == "true" ]]; then
        echo -e "  ${COLOUR_CYAN}Existing files:${COLOUR_RESET} Keep existing (skip)"
    else
        echo -e "  ${COLOUR_CYAN}Existing files:${COLOUR_RESET} Overwrite"
    fi

    if [[ "$REPLACE_CRONTAB" == "true" ]]; then
        echo -e "  ${COLOUR_CYAN}Crontab:${COLOUR_RESET} Replace (backup existing)"
    else
        echo -e "  ${COLOUR_CYAN}Crontab:${COLOUR_RESET} Keep existing"
    fi

    echo -e "  ${COLOUR_CYAN}Node manager:${COLOUR_RESET} $SELECTED_NODE_MANAGER"
    echo -e "  ${COLOUR_CYAN}Python:${COLOUR_RESET} $SELECTED_PYTHON_VERSION"

    if [[ "$INSTALL_DATABASES" == "true" ]]; then
        echo -e "  ${COLOUR_CYAN}Databases:${COLOUR_RESET} PostgreSQL 17, Redis"
    else
        echo -e "  ${COLOUR_CYAN}Databases:${COLOUR_RESET} Skip"
    fi

    echo ""

    if ! prompt_yes_no "Proceed?" "Y"; then
        echo ""
        echo -e "${COLOUR_BRIGHT_RED}❌ Setup cancelled by user${COLOUR_RESET}"
        exit 1
    fi

    # -------------------------------------------------------------------------
    # DRY RUN OUTPUT
    # -------------------------------------------------------------------------

    if [[ "$DRY_RUN" == "true" ]]; then
        echo ""
        echo -e "${COLOUR_BRIGHT_YELLOW}${COLOUR_BOLD}DRY RUN - Configuration preview:${COLOUR_RESET}"
        echo ""
        echo -e "${COLOUR_DIM}The following configuration would be applied:${COLOUR_RESET}"
        echo ""
        echo -e "${COLOUR_WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOUR_RESET}"
        echo "INSTALL_PROFILE=\"$INSTALL_PROFILE\""
        echo "BACKUP_EXISTING=$BACKUP_EXISTING"
        echo "BACKUP_DIR=\"$BACKUP_DIR\""
        echo "SKIP_EXISTING=$SKIP_EXISTING"
        echo "REPLACE_CRONTAB=$REPLACE_CRONTAB"
        echo "SELECTED_NODE_MANAGER=\"$SELECTED_NODE_MANAGER\""
        echo "SELECTED_PYTHON_VERSION=\"$SELECTED_PYTHON_VERSION\""
        echo "INSTALL_DATABASES=$INSTALL_DATABASES"
        echo -e "${COLOUR_WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOUR_RESET}"
        echo ""
        echo -e "${COLOUR_BRIGHT_YELLOW}ℹ️  No changes were made (dry-run mode)${COLOUR_RESET}"
        echo -e "${COLOUR_DIM}To perform the actual setup, run without --dry-run flag:${COLOUR_RESET}"
        echo -e "  ${COLOUR_CYAN}./setup.sh${COLOUR_RESET}"
        exit 0
    fi

    # Export variables for shell scripts
    export BACKUP_EXISTING
    export BACKUP_DIR
    export SKIP_EXISTING
    export REPLACE_CRONTAB
    export SELECTED_NODE_MANAGER
    export SELECTED_PYTHON_VERSION
    export INSTALL_DATABASES
fi

# =============================================================================
# INSTALLATION
# =============================================================================

echo -e "\n🔐 Requesting Administrator's privileges"
sudo true

echo -e "🚀 Starting installation\n"
timerStart=$(date +%s)

echo "------------------------------------------------"
echo -e "${COLOUR_YELLOW}Setting up your macOS/Linux development environment...${COLOUR_RESET}"
echo "------------------------------------------------"

echo -e "📂 Making all .sh scripts executable"
chmod a+x "$SCRIPT_DIR"/**/*.sh

echo -e "🐚 Processing setup scripts..."
SETUP_SCRIPTS="$SCRIPT_DIR/setup"
for file in "$SETUP_SCRIPTS"/*; do
    filename=$(basename "$file")
    if [[ -x "$file" ]]; then
        echo -e "  ✅ Executing setup script: $filename"
        "$file"
    else
        echo "  ❌ Not executable: $filename"
    fi
done

# =============================================================================
# SHELL SCRIPTS
# =============================================================================

echo -e "\n🐚 Processing shell scripts..."
SHELL_FILES="$SCRIPT_DIR/shell"
for file in "$SHELL_FILES"/*; do
    filename=$(basename "$file")
    if [[ -x "$file" ]]; then
        echo -e "  ✅ Executing shell script: $filename"
        "$file"
    else
        echo "  ❌ Not executable: $filename"
    fi
done

timerStop=$(date +%s)
duration=$((timerStop - timerStart))

echo -e "\n🔒 Removing script execute permissions"
chmod a-x "$SCRIPT_DIR"/**/*.sh

if [ $duration -lt 60 ]; then
    echo -e "⏱️ Time taken: $((duration % 60)) seconds"
else
    echo -e "⏱️ Time taken: $((duration / 60)) minutes and $((duration % 60)) seconds"
fi

# =============================================================================
# HOMEBREW PACKAGES
# =============================================================================

echo -e "\n📦 Installing Homebrew packages"

if [[ -n "$INSTALL_PROFILE" ]] && [[ "$INSTALL_PROFILE" != "full" ]]; then
    # Use profile-specific Brewfile
    BREWFILE_PATH=$(apply_brewfile_profile "$INSTALL_PROFILE")
    if [[ -n "$BREWFILE_PATH" ]] && [[ -f "$BREWFILE_PATH" ]]; then
        echo "Using $INSTALL_PROFILE profile"
        brew bundle install --file="$BREWFILE_PATH"
        rm -f "$BREWFILE_PATH"
    else
        echo "Warning: Could not find profile Brewfile, using default"
        brew bundle install
    fi
else
    # Use default Brewfile (full installation)
    brew bundle install
fi

echo -e "\n✨ Setup complete! 🎉"
