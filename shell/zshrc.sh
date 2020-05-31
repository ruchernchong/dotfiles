#!/bin/zsh

echo -e "Updating your Zsh setup and configuration..."

rm -f ~/.zshrc
rm -f ~/.p10k.zsh

ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh
