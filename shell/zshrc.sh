#!/bin/zsh

# Source state file if it exists
[[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

echo -e "Updating your Zsh setup and configuration..."

# Backup if needed
if [[ "$BACKUP_EXISTING" == "true" ]] && [[ -n "$BACKUP_DIR" ]]; then
    source "$HOME/dotfiles/lib/backup.sh"
    backup_if_exists "$HOME/.zshrc" "$BACKUP_DIR"
fi

# Skip if user chose to skip existing files
if [[ -f "$HOME/.zshrc" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
    # Check if it's already correctly symlinked
    source "$HOME/dotfiles/lib/backup.sh"
    if ! is_correctly_symlinked "$HOME/.zshrc" "$HOME/dotfiles/config/.zshrc"; then
        echo -e "  ⏭️  Skipping (file exists)"
        exit 0
    fi
fi

# Create symlink
rm -f $HOME/.zshrc
ln -s $HOME/dotfiles/config/.zshrc $HOME/.zshrc
