#!/bin/zsh

echo -e "Updating your Vim setup and configuration..."

rm -f $HOME/.vimrc
ln -s $HOME/dotfiles/config/.vimrc $HOME/.vimrc
