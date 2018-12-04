#! /usr/bin/env bash

pwd=$(pwd)

echo -e "Installing Nerd Fonts"

brew tap caskroom/fonts
brew cask install font-hack-nerd-font

cd /tmp
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
cd $pwd
