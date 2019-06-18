#!/bin/zsh

echo -e "Updating miscellaneous configuration files..."

rm -f ~/.hushlogin
ln -s ~/dotfiles/.hushlogin ~/.hushlogin

rm -f ~/.gitignore
ln -s ~/dotfiles/.gitignore ~/.gitignore
