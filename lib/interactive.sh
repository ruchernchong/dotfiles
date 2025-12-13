#!/bin/zsh

# Interactive Prompt Utilities for Dotfiles Setup
# Provides reusable functions for user interaction

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
        read -r "response?$question $prompt: "
        response=${response:-$default}

        case "$response" in
            [Yy]* ) return 0 ;;
            [Nn]* ) return 1 ;;
            * ) echo "Please answer yes or no." ;;
        esac
    done
}

# Displays a menu selection using built-in select
# Usage: result=$(prompt_menu "Question?" "option1" "option2" "option3")
prompt_menu() {
    local question="$1"
    shift
    local options=("$@")

    echo "$question"
    select opt in "${options[@]}"; do
        if [[ -n "$opt" ]]; then
            echo "$opt"
            return 0
        else
            echo "Invalid selection. Please try again." >&2
        fi
    done
}

# Shows a diff preview of file changes (if diff is available)
# Usage: show_diff "/path/to/existing" "/path/to/new"
show_diff() {
    local existing="$1"
    local new="$2"

    if [[ ! -f "$existing" ]]; then
        echo "  ℹ️  No existing file - will create new"
        return 0
    fi

    # Check if diff command is available
    if command -v diff &> /dev/null; then
        echo "  📋 Preview of changes:"
        diff -u "$existing" "$new" 2>/dev/null | head -n 50 || true
    else
        # Fallback to basic file info
        echo "  Current file: $(wc -l < "$existing" 2>/dev/null || echo '0') lines"
        echo "  New file: $(wc -l < "$new" 2>/dev/null || echo '0') lines"
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
        read -r "response?$question $prompt: "
        response=${response:-$default}

        # Validate it's a number in range
        if [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 1 ]] && [[ "$response" -le "$max" ]]; then
            echo "$response"
            return 0
        else
            echo "Please enter a number between 1 and $max." >&2
        fi
    done
}

# Displays a section header for better UI organization
# Usage: print_section "INSTALLATION SCOPE"
print_section() {
    local title="$1"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " $title"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Displays a simple list with bullet points
# Usage: print_list "item1" "item2" "item3"
print_list() {
    for item in "$@"; do
        echo "  • $item"
    done
}
