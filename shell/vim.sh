#!/bin/zsh

echo -e "Updating your Vim setup and configuration..."

# Source backup utilities
source "$HOME/dotfiles/lib/backup.sh"

# Handle backup and skip logic
if ! handle_file_with_backup_and_skip "$HOME/.vimrc" "$HOME/dotfiles/config/.vimrc"; then
    exit 0
fi

# Create symlink
rm -f "$HOME/.vimrc"
ln -s "$HOME/dotfiles/config/.vimrc" "$HOME/.vimrc"
