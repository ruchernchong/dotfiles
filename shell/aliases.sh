#!/bin/zsh

# Source state file if it exists
[[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

echo -e "Updating Aliases..."

# Backup if needed
if [[ "$BACKUP_EXISTING" == "true" ]] && [[ -n "$BACKUP_DIR" ]]; then
    source "$HOME/dotfiles/lib/backup.sh"
    backup_if_exists "$HOME/.aliases" "$BACKUP_DIR"
fi

# Skip if user chose to skip existing files
if [[ -f "$HOME/.aliases" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
    # Check if it's already correctly symlinked
    source "$HOME/dotfiles/lib/backup.sh"
    if ! is_correctly_symlinked "$HOME/.aliases" "$HOME/dotfiles/config/.aliases"; then
        echo -e "  ⏭️  Skipping (file exists)"
        exit 0
    fi
fi

# Create symlink
rm -f $HOME/.aliases
ln -s $HOME/dotfiles/config/.aliases $HOME/.aliases

source $HOME/.aliases
