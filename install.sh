#!/bin/zsh

if ! [ -x "$(command -v git)" ]; then
  echo "Git is not installed. Exiting..."
  exit 1
fi

git clone https://github.com/ruchernchong/dotfiles $HOME/dotfiles
cd $HOME/dotfiles
chmod a+x setup.sh
source setup.sh

echo "Installation has completed."
