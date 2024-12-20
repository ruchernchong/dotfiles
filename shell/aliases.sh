#!/bin/zsh

echo -e "Updating Aliases..."

rm -f $HOME/.aliases
ln -s $HOME/dotfiles/.aliases $HOME/.aliases

source $HOME/.aliases
