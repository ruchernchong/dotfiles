#!/bin/zsh

echo -e "Updating miscellaneous configuration files..."

# Source backup utilities
source "$HOME/dotfiles/lib/backup.sh"

# Handle .hushlogin
if handle_file_with_backup_and_skip "$HOME/.hushlogin" "$HOME/dotfiles/.hushlogin"; then
    rm -f "$HOME/.hushlogin"
    ln -s "$HOME/dotfiles/.hushlogin" "$HOME/.hushlogin"
fi

# Handle .gitignore
if handle_file_with_backup_and_skip "$HOME/.gitignore" "$HOME/dotfiles/.gitignore"; then
    rm -f "$HOME/.gitignore"
    ln -s "$HOME/dotfiles/.gitignore" "$HOME/.gitignore"
fi
