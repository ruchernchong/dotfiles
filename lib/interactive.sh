#!/bin/zsh

# Interactive Prompt Utilities for Dotfiles Setup
# Provides reusable functions for user interaction

# Colour definitions using ANSI escape codes
readonly COLOUR_RESET='\033[0m'
readonly COLOUR_BOLD='\033[1m'
readonly COLOUR_DIM='\033[2m'

# Foreground colours
readonly COLOUR_RED='\033[0;31m'
readonly COLOUR_GREEN='\033[0;32m'
readonly COLOUR_YELLOW='\033[0;33m'
readonly COLOUR_BLUE='\033[0;34m'
readonly COLOUR_MAGENTA='\033[0;35m'
readonly COLOUR_CYAN='\033[0;36m'
readonly COLOUR_WHITE='\033[0;37m'

# Bright/Bold colours
readonly COLOUR_BRIGHT_RED='\033[1;31m'
readonly COLOUR_BRIGHT_GREEN='\033[1;32m'
readonly COLOUR_BRIGHT_YELLOW='\033[1;33m'
readonly COLOUR_BRIGHT_BLUE='\033[1;34m'
readonly COLOUR_BRIGHT_MAGENTA='\033[1;35m'
readonly COLOUR_BRIGHT_CYAN='\033[1;36m'
readonly COLOUR_BRIGHT_WHITE='\033[1;37m'

# Displays a yes/no prompt with default value
# Usage: prompt_yes_no "Question?" "Y" (returns 0 for yes, 1 for no)
prompt_yes_no() {
    local question="$1"
    local default="${2:-Y}"
    local prompt

    if [[ "$default" =~ ^[Yy]$ ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi

    while true; do
        echo -ne "${COLOUR_YELLOW}$question $prompt: ${COLOUR_RESET}"
        read -r response
        response=${response:-$default}

        case "$response" in
            [Yy]* ) return 0 ;;
            [Nn]* ) return 1 ;;
            * ) echo -e "${COLOUR_RED}Please answer yes or no.${COLOUR_RESET}" ;;
        esac
    done
}

# Displays a menu selection using built-in select
# Usage: result=$(prompt_menu "Question?" "option1" "option2" "option3")
prompt_menu() {
    local question="$1"
    shift
    local options=("$@")

    echo -e "${COLOUR_CYAN}$question${COLOUR_RESET}"
    select opt in "${options[@]}"; do
        if [[ -n "$opt" ]]; then
            echo "$opt"
            return 0
        else
            echo -e "${COLOUR_RED}Invalid selection. Please try again.${COLOUR_RESET}" >&2
        fi
    done
}

# Shows a diff preview of file changes (if diff is available)
# Usage: show_diff "/path/to/existing" "/path/to/new"
show_diff() {
    local existing="$1"
    local new="$2"

    if [[ ! -f "$existing" ]]; then
        echo -e "  ${COLOUR_BLUE}ℹ️  No existing file - will create new${COLOUR_RESET}"
        return 0
    fi

    # Check if diff command is available
    if command -v diff &> /dev/null; then
        echo -e "  ${COLOUR_CYAN}📋 Preview of changes:${COLOUR_RESET}"
        diff -u "$existing" "$new" 2>/dev/null | head -n 50 || true
    else
        # Fallback to basic file info
        echo -e "  ${COLOUR_DIM}Current file: $(wc -l < "$existing" 2>/dev/null || echo '0') lines${COLOUR_RESET}"
        echo -e "  ${COLOUR_DIM}New file: $(wc -l < "$new" 2>/dev/null || echo '0') lines${COLOUR_RESET}"
    fi
}

# Confirms an action with optional preview
# Usage: confirm_with_preview "Replace .zshrc?" "/path/to/existing" "/path/to/new"
# Returns 0 if confirmed, 1 if declined
confirm_with_preview() {
    local question="$1"
    local existing="$2"
    local new="$3"
    local show_preview=false

    # Ask if user wants to see preview first
    if [[ -f "$existing" ]] && [[ -f "$new" ]]; then
        if prompt_yes_no "Preview changes first?" "N"; then
            show_diff "$existing" "$new"
        fi
    fi

    # Confirm the action
    prompt_yes_no "$question" "Y"
}

# Displays a numbered prompt that returns the selected number
# Usage: selection=$(prompt_number "Choose:" "Default option" 3)
prompt_number() {
    local question="$1"
    local default="$2"
    local max="${3:-99}"
    local prompt="[${default}]"

    while true; do
        echo -ne "${COLOUR_YELLOW}$question $prompt: ${COLOUR_RESET}"
        read -r response
        response=${response:-$default}

        # Validate it's a number in range
        if [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 1 ]] && [[ "$response" -le "$max" ]]; then
            echo "$response"
            return 0
        else
            echo -e "${COLOUR_RED}Please enter a number between 1 and $max.${COLOUR_RESET}" >&2
        fi
    done
}

# Displays a section header for better UI organization
# Usage: print_section "INSTALLATION SCOPE"
print_section() {
    local title="$1"
    echo ""
    echo -e "${COLOUR_BRIGHT_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOUR_RESET}"
    echo -e "${COLOUR_BRIGHT_CYAN}${COLOUR_BOLD} $title${COLOUR_RESET}"
    echo -e "${COLOUR_BRIGHT_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${COLOUR_RESET}"
    echo ""
}

# Displays a simple list with bullet points
# Usage: print_list "item1" "item2" "item3"
print_list() {
    for item in "$@"; do
        echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} $item"
    done
}
