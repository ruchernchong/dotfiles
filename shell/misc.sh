#!/bin/zsh

echo -e "Updating miscellaneous configuration files..."

rm -f $HOME/.hushlogin
ln -s $HOME/dotfiles/.hushlogin $HOME/.hushlogin

rm -f $HOME/.gitignore
ln -s $HOME/dotfiles/.gitignore $HOME/.gitignore
