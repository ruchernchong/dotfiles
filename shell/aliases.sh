#!/bin/zsh

echo -e "Updating Aliases..."

# Source backup utilities
source "$HOME/dotfiles/lib/backup.sh"

# Handle backup and skip logic
if ! handle_file_with_backup_and_skip "$HOME/.aliases" "$HOME/dotfiles/config/.aliases"; then
    exit 0
fi

# Create symlink
rm -f "$HOME/.aliases"
ln -s "$HOME/dotfiles/config/.aliases" "$HOME/.aliases"

source "$HOME/.aliases"
