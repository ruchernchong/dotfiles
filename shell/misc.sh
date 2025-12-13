#!/bin/zsh

# Source state file if it exists
[[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

echo -e "Updating miscellaneous configuration files..."

# Backup if needed
if [[ "$BACKUP_EXISTING" == "true" ]] && [[ -n "$BACKUP_DIR" ]]; then
    source "$HOME/dotfiles/lib/backup.sh"
    backup_if_exists "$HOME/.hushlogin" "$BACKUP_DIR"
    backup_if_exists "$HOME/.gitignore" "$BACKUP_DIR"
fi

# Handle .hushlogin
if [[ -f "$HOME/.hushlogin" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
    source "$HOME/dotfiles/lib/backup.sh"
    if ! is_correctly_symlinked "$HOME/.hushlogin" "$HOME/dotfiles/.hushlogin"; then
        echo -e "  ⏭️  Skipping .hushlogin (file exists)"
    else
        rm -f $HOME/.hushlogin
        ln -s $HOME/dotfiles/.hushlogin $HOME/.hushlogin
    fi
else
    rm -f $HOME/.hushlogin
    ln -s $HOME/dotfiles/.hushlogin $HOME/.hushlogin
fi

# Handle .gitignore
if [[ -f "$HOME/.gitignore" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
    source "$HOME/dotfiles/lib/backup.sh"
    if ! is_correctly_symlinked "$HOME/.gitignore" "$HOME/dotfiles/.gitignore"; then
        echo -e "  ⏭️  Skipping .gitignore (file exists)"
    else
        rm -f $HOME/.gitignore
        ln -s $HOME/dotfiles/.gitignore $HOME/.gitignore
    fi
else
    rm -f $HOME/.gitignore
    ln -s $HOME/dotfiles/.gitignore $HOME/.gitignore
fi
