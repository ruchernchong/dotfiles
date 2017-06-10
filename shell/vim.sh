#!/usr/bin/env bash

echo -e "Updating your Vim setup and configuration..."

#rm -rf ~/.vim
rm -f ~/.vimrc
#ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc
