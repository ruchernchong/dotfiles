#!/bin/zsh

# Backup Utilities for Dotfiles Setup
# Provides safe backup operations for existing configuration files

# Source colour definitions
SCRIPT_DIR="${0:a:h}"
if [[ -f "$SCRIPT_DIR/interactive.sh" ]]; then
    source "$SCRIPT_DIR/interactive.sh"
fi

# Creates a timestamped backup directory
# Usage: backup_dir=$(create_backup_dir)
# Returns: Path to the created backup directory
create_backup_dir() {
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

    if mkdir -p "$backup_dir"; then
        echo "$backup_dir"
        return 0
    else
        echo "Error: Failed to create backup directory: $backup_dir" >&2
        return 1
    fi
}

# Backs up a file if it exists (handles both regular files and symlinks)
# Usage: backup_if_exists "$HOME/.zshrc" "$BACKUP_DIR"
# Returns: 0 if backup was made or file doesn't exist, 1 on error
backup_if_exists() {
    local file="$1"
    local backup_dir="$2"

    if [[ -z "$backup_dir" ]]; then
        echo "Error: Backup directory not specified" >&2
        return 1
    fi

    if [[ ! -d "$backup_dir" ]]; then
        echo "Error: Backup directory does not exist: $backup_dir" >&2
        return 1
    fi

    # Check if file or symlink exists
    if [[ -f "$file" ]] || [[ -L "$file" ]]; then
        local filename=$(basename "$file")
        echo -e "  ${COLOUR_CYAN}📦 Backing up ${COLOUR_BOLD}$filename${COLOUR_RESET}"

        # Use cp -P to preserve symlinks
        if cp -P "$file" "$backup_dir/$filename" 2>/dev/null; then
            return 0
        else
            echo -e "  ${COLOUR_YELLOW}⚠️  Warning: Failed to backup $filename${COLOUR_RESET}" >&2
            return 1
        fi
    fi

    # File doesn't exist, nothing to backup
    return 0
}

# Lists all dotfiles that will conflict with setup
# Usage: conflicts=$(list_conflicts)
# Returns: Array of files that exist and would be overwritten
list_conflicts() {
    local dotfiles=(
        "$HOME/.zshrc"
        "$HOME/.aliases"
        "$HOME/.vimrc"
        "$HOME/.hushlogin"
        "$HOME/.gitignore"
        "$HOME/.claude/settings.json"
    )

    local conflicts=()

    for file in "${dotfiles[@]}"; do
        if [[ -f "$file" ]] || [[ -L "$file" ]]; then
            # Check if it's already correctly symlinked to dotfiles repo
            if [[ -L "$file" ]]; then
                local link_target=$(readlink "$file")
                # If it points to our dotfiles repo, skip it
                if [[ "$link_target" == "$HOME/dotfiles/"* ]]; then
                    continue
                fi
            fi
            conflicts+=("$file")
        fi
    done

    # Return conflicts as newline-separated list
    printf '%s\n' "${conflicts[@]}"
}

# Checks if a file is already correctly symlinked to dotfiles
# Usage: if is_correctly_symlinked "$HOME/.zshrc" "$HOME/dotfiles/config/.zshrc"; then
# Returns: 0 if already correctly linked, 1 otherwise
is_correctly_symlinked() {
    local target="$1"
    local source="$2"

    if [[ -L "$target" ]]; then
        local link_target=$(readlink "$target")
        if [[ "$link_target" == "$source" ]]; then
            return 0
        fi
    fi

    return 1
}

# Restores backed up dotfiles (for rollback scenarios)
# Usage: restore_backup "$BACKUP_DIR"
# Returns: 0 on success, 1 on error
restore_backup() {
    local backup_dir="$1"

    if [[ -z "$backup_dir" ]] || [[ ! -d "$backup_dir" ]]; then
        echo "Error: Invalid backup directory: $backup_dir" >&2
        return 1
    fi

    echo -e "${COLOUR_CYAN}Restoring dotfiles from: ${COLOUR_DIM}$backup_dir${COLOUR_RESET}"

    # Restore each file from backup
    for backup_file in "$backup_dir"/*; do
        if [[ -f "$backup_file" ]] || [[ -L "$backup_file" ]]; then
            local filename=$(basename "$backup_file")
            local target="$HOME/$filename"

            echo -e "  ${COLOUR_GREEN}♻️  Restoring ${COLOUR_BOLD}$filename${COLOUR_RESET}"

            # Remove current file/symlink
            rm -f "$target"

            # Restore from backup (preserve symlinks)
            cp -P "$backup_file" "$target"
        fi
    done

    echo -e "${COLOUR_BRIGHT_GREEN}✓ Restore complete${COLOUR_RESET}"
    return 0
}

# Displays backup information
# Usage: show_backup_info "$BACKUP_DIR"
show_backup_info() {
    local backup_dir="$1"

    if [[ ! -d "$backup_dir" ]]; then
        echo -e "${COLOUR_YELLOW}No backup directory found${COLOUR_RESET}"
        return 1
    fi

    echo -e "${COLOUR_CYAN}Backup location:${COLOUR_RESET} ${COLOUR_DIM}$backup_dir${COLOUR_RESET}"
    echo -e "${COLOUR_CYAN}Backed up files:${COLOUR_RESET}"

    for file in "$backup_dir"/*; do
        if [[ -f "$file" ]] || [[ -L "$file" ]]; then
            local filename=$(basename "$file")
            local size=$(du -h "$file" | cut -f1)
            echo -e "  ${COLOUR_BLUE}•${COLOUR_RESET} $filename ${COLOUR_DIM}($size)${COLOUR_RESET}"
        fi
    done
}

# Handles file backup and skip logic for dotfile setup scripts
# Usage: handle_file_with_backup_and_skip "$HOME/.aliases" "$HOME/dotfiles/config/.aliases"
# Returns: 0 if file is ready to be symlinked, 1 if should skip
handle_file_with_backup_and_skip() {
    local target="$1"
    local source="$2"

    # Source state file if it exists
    [[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

    # Backup if needed
    if [[ "$BACKUP_EXISTING" == "true" ]] && [[ -n "$BACKUP_DIR" ]]; then
        backup_if_exists "$target" "$BACKUP_DIR"
    fi

    # Skip if user chose to skip existing files
    if [[ -f "$target" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
        # Check if it's already correctly symlinked
        if ! is_correctly_symlinked "$target" "$source"; then
            echo -e "  ⏭️  Skipping (file exists)"
            return 1
        fi
    fi

    return 0
}
