#!/bin/zsh

echo -e "Updating your Zsh setup and configuration..."

# Source backup utilities
source "$HOME/dotfiles/lib/backup.sh"

# Handle backup and skip logic
if ! handle_file_with_backup_and_skip "$HOME/.zshrc" "$HOME/dotfiles/config/.zshrc"; then
    exit 0
fi

# Create symlink
rm -f "$HOME/.zshrc"
ln -s "$HOME/dotfiles/config/.zshrc" "$HOME/.zshrc"
