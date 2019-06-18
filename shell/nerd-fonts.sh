#!/bin/zsh

pwd=$(pwd)

echo -e "Installing Nerd Fonts"

brew tap caskroom/fonts
brew cask install font-hack-nerd-font
