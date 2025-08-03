#!/bin/zsh

echo -e "Updating your Zsh setup and configuration..."

rm -f $HOME/.zshrc

ln -s $HOME/dotfiles/config/.zshrc $HOME/.zshrc
