#!/bin/zsh

echo -e "Updating Claude Code settings..."

mkdir -p $HOME/.claude
rm -f $HOME/.claude/settings.json
ln -s $HOME/dotfiles/config/.claude/settings.json $HOME/.claude/settings.json
