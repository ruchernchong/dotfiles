#!/bin/zsh

echo -e "Updating Claude Code settings..."

mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.config/claude"

# Source backup utilities
source "$HOME/dotfiles/lib/backup.sh"

# Handle backup and skip logic for settings.json
if ! handle_file_with_backup_and_skip "$HOME/.claude/settings.json" "$HOME/dotfiles/config/.claude/settings.json"; then
    echo -e "  ⏭️  Skipping settings.json (file exists)"
    exit 0
fi

# Handle backup and skip logic for CLAUDE.md
if ! handle_file_with_backup_and_skip "$HOME/.claude/CLAUDE.md" "$HOME/dotfiles/config/.claude/CLAUDE.md"; then
    echo -e "  ⏭️  Skipping CLAUDE.md (file exists)"
    exit 0
fi

# Create symlinks
rm -f "$HOME/.claude/settings.json"
ln -s "$HOME/dotfiles/config/.claude/settings.json" "$HOME/.claude/settings.json"

rm -f "$HOME/.claude/CLAUDE.md"
ln -s "$HOME/dotfiles/config/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Handle backup and skip logic for ccusage.json
if ! handle_file_with_backup_and_skip "$HOME/.config/claude/ccusage.json" "$HOME/dotfiles/config/.config/claude/ccusage.json"; then
    echo -e "  ⏭️  Skipping ccusage.json (file exists)"
    exit 0
fi

# Create symlink for ccusage config
rm -f "$HOME/.config/claude/ccusage.json"
ln -s "$HOME/dotfiles/config/.config/claude/ccusage.json" "$HOME/.config/claude/ccusage.json"
