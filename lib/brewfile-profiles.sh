#!/bin/zsh

# Brewfile Profile Management
# Handles package selection based on installation profile

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
            echo "Essential tools only (~15 packages)"
            echo "  • Git, GitHub CLI"
            echo "  • Shell tools (bash, starship)"
            echo "  • Node.js (fnm, pnpm)"
            echo "  • Utilities (jq, ripgrep, direnv)"
            ;;
        developer)
            echo "Development environment (~40-50 packages)"
            echo "  • Everything in Minimal"
            echo "  • Databases (PostgreSQL, Redis)"
            echo "  • Containers (OrbStack)"
            echo "  • Cloud tools (Vercel, AWS SAM, Pulumi)"
            echo "  • Essential VSCode extensions"
            ;;
        full)
            echo "Complete installation (~120 packages)"
            echo "  • Everything in Developer"
            echo "  • Multiple Python versions"
            echo "  • Additional cloud SDKs (gcloud, doctl)"
            echo "  • All VSCode extensions"
            echo "  • Media and utility tools"
            ;;
        *)
            echo "Unknown profile"
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
    echo "Available installation profiles:"
    echo ""
    echo "1. minimal   - $(count_packages_in_brewfile "$HOME/dotfiles/config/setup-profiles/minimal.brewfile") packages"
    get_profile_description "minimal" | sed 's/^/     /'
    echo ""
    echo "2. developer - $(count_packages_in_brewfile "$HOME/dotfiles/config/setup-profiles/developer.brewfile") packages"
    get_profile_description "developer" | sed 's/^/     /'
    echo ""
    echo "3. full      - $(count_packages_in_brewfile "$HOME/dotfiles/Brewfile") packages"
    get_profile_description "full" | sed 's/^/     /'
}
