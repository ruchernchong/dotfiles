#!/bin/zsh

echo -e "Updating your Zsh setup and configuration..."

rm -f $HOME/.zshrc
rm -f $HOME/.p10k.zsh

ln -s $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -s $HOME/dotfiles/zsh/.p10k.zsh $HOME/.p10k.zsh
