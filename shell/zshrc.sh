#!/bin/zsh

echo -e "Updating your Zsh setup and configuration..."

cp ~/dotfiles/zsh/themes/clean-custom.zsh-theme ~/.oh-my-zsh/themes/clean-custom.zsh-theme

rm -f ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
