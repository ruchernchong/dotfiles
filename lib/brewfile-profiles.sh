#!/bin/zsh

# Brewfile Profile Management
# Handles package selection based on installation profile

# Source colour definitions
SCRIPT_DIR="${0:a:h}"
if [[ -f "$SCRIPT_DIR/interactive.sh" ]]; then
    source "$SCRIPT_DIR/interactive.sh"
fi

# Applies the selected Brewfile profile
# Usage: brewfile_path=$(apply_brewfile_profile "developer")
# Returns: Path to the Brewfile to use with brew bundle
apply_brewfile_profile() {
    local profile="$1"
    local dotfiles_dir="$HOME/dotfiles"
    local source_file=""
    local temp_brewfile="/tmp/Brewfile.tmp"

    # Validate profile argument
    if [[ -z "$profile" ]]; then
        echo "Error: No profile specified" >&2
        return 1
    fi

    # Determine source Brewfile based on profile
    case "$profile" in
        minimal)
            source_file="$dotfiles_dir/config/setup-profiles/minimal.brewfile"
            ;;
        developer)
            source_file="$dotfiles_dir/config/setup-profiles/developer.brewfile"
            ;;
        full)
            # Use the main Brewfile for full installation
            source_file="$dotfiles_dir/Brewfile"
            ;;
        *)
            echo "Error: Invalid profile '$profile'. Valid options: minimal, developer, full" >&2
            return 1
            ;;
    esac

    # Check if source file exists
    if [[ ! -f "$source_file" ]]; then
        echo "Error: Profile file not found: $source_file" >&2
        return 1
    fi

    # Copy to temporary location
    if cp "$source_file" "$temp_brewfile"; then
        echo "$temp_brewfile"
        return 0
    else
        echo "Error: Failed to copy Brewfile profile" >&2
        return 1
    fi
}

# Gets a description of what's included in a profile
# Usage: get_profile_description "developer"
get_profile_description() {
    local profile="$1"

    case "$profile" in
        minimal)
            echo -e "${COLOUR_DIM}Essential tools only (~15 packages)${COLOUR_RESET}"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Git, GitHub CLI"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Shell tools (bash, starship)"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Node.js (fnm, pnpm)"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Utilities (jq, ripgrep, direnv)"
            ;;
        developer)
            echo -e "${COLOUR_DIM}Development environment (~40-50 packages)${COLOUR_RESET}"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Everything in Minimal"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Databases (PostgreSQL, Redis)"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Containers (OrbStack)"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Cloud tools (Vercel, AWS SAM, Pulumi)"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Essential VSCode extensions"
            ;;
        full)
            echo -e "${COLOUR_DIM}Complete installation (~120 packages)${COLOUR_RESET}"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Everything in Developer"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Multiple Python versions"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Additional cloud SDKs (gcloud, doctl)"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} All VSCode extensions"
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} Media and utility tools"
            ;;
        *)
            echo -e "${COLOUR_RED}Unknown profile${COLOUR_RESET}"
            ;;
    esac
}

# Counts packages in a Brewfile
# Usage: count=$(count_packages_in_brewfile "$brewfile_path")
count_packages_in_brewfile() {
    local brewfile="$1"

    if [[ ! -f "$brewfile" ]]; then
        echo "0"
        return 1
    fi

    # Count lines starting with 'brew ', 'cask ', or 'vscode '
    local count=$(grep -E "^(brew|cask|vscode) " "$brewfile" 2>/dev/null | wc -l | tr -d ' ')
    echo "$count"
}

# Lists all available profiles
# Usage: list_available_profiles
list_available_profiles() {
    echo -e "${COLOUR_CYAN}Available installation profiles:${COLOUR_RESET}"
    echo ""
    echo -e "${COLOUR_WHITE}1.${COLOUR_RESET} ${COLOUR_BOLD}minimal${COLOUR_RESET}   - ${COLOUR_DIM}$(count_packages_in_brewfile "$HOME/dotfiles/config/setup-profiles/minimal.brewfile") packages${COLOUR_RESET}"
    get_profile_description "minimal" | sed 's/^/     /'
    echo ""
    echo -e "${COLOUR_WHITE}2.${COLOUR_RESET} ${COLOUR_BOLD}developer${COLOUR_RESET} - ${COLOUR_DIM}$(count_packages_in_brewfile "$HOME/dotfiles/config/setup-profiles/developer.brewfile") packages${COLOUR_RESET}"
    get_profile_description "developer" | sed 's/^/     /'
    echo ""
    echo -e "${COLOUR_WHITE}3.${COLOUR_RESET} ${COLOUR_BOLD}full${COLOUR_RESET}      - ${COLOUR_DIM}$(count_packages_in_brewfile "$HOME/dotfiles/Brewfile") packages${COLOUR_RESET}"
    get_profile_description "full" | sed 's/^/     /'
}
