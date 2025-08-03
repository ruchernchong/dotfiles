#!/bin/zsh

echo -e "Updating Aliases..."

rm -f $HOME/.aliases
ln -s $HOME/dotfiles/config/.aliases $HOME/.aliases

source $HOME/.aliases
