#!/bin/zsh

# Source state file if it exists
[[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

echo -e "Updating your Vim setup and configuration..."

# Backup if needed
if [[ "$BACKUP_EXISTING" == "true" ]] && [[ -n "$BACKUP_DIR" ]]; then
    source "$HOME/dotfiles/lib/backup.sh"
    backup_if_exists "$HOME/.vimrc" "$BACKUP_DIR"
fi

# Skip if user chose to skip existing files
if [[ -f "$HOME/.vimrc" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
    # Check if it's already correctly symlinked
    source "$HOME/dotfiles/lib/backup.sh"
    if ! is_correctly_symlinked "$HOME/.vimrc" "$HOME/dotfiles/config/.vimrc"; then
        echo -e "  ⏭️  Skipping (file exists)"
        exit 0
    fi
fi

# Create symlink
rm -f $HOME/.vimrc
ln -s $HOME/dotfiles/config/.vimrc $HOME/.vimrc
