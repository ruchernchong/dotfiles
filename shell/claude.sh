#!/bin/zsh

# Source state file if it exists
[[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

echo -e "Updating Claude Code settings..."

mkdir -p $HOME/.claude

# Backup if needed
if [[ "$BACKUP_EXISTING" == "true" ]] && [[ -n "$BACKUP_DIR" ]]; then
    source "$HOME/dotfiles/lib/backup.sh"
    backup_if_exists "$HOME/.claude/settings.json" "$BACKUP_DIR"
    backup_if_exists "$HOME/.claude/CLAUDE.md" "$BACKUP_DIR"
fi

# Skip if user chose to skip existing files
if [[ -f "$HOME/.claude/settings.json" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
    # Check if it's already correctly symlinked
    source "$HOME/dotfiles/lib/backup.sh"
    if ! is_correctly_symlinked "$HOME/.claude/settings.json" "$HOME/dotfiles/config/.claude/settings.json"; then
        echo -e "  ⏭️  Skipping settings.json (file exists)"
        exit 0
    fi
fi

if [[ -f "$HOME/.claude/CLAUDE.md" ]] && [[ "$SKIP_EXISTING" == "true" ]]; then
    # Check if it's already correctly symlinked
    source "$HOME/dotfiles/lib/backup.sh"
    if ! is_correctly_symlinked "$HOME/.claude/CLAUDE.md" "$HOME/dotfiles/config/.claude/CLAUDE.md"; then
        echo -e "  ⏭️  Skipping CLAUDE.md (file exists)"
        exit 0
    fi
fi

# Create symlinks
rm -f $HOME/.claude/settings.json
ln -s $HOME/dotfiles/config/.claude/settings.json $HOME/.claude/settings.json

rm -f $HOME/.claude/CLAUDE.md
ln -s $HOME/dotfiles/config/.claude/CLAUDE.md $HOME/.claude/CLAUDE.md
