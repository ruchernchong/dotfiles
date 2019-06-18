#!/bin/zsh

echo -e "Updating Aliases..."

rm -f ~/.aliases
ln -s ~/dotfiles/.aliases ~/.aliases

source ~/.aliases
