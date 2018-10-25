#! /usr/local/env bash

pwd=$(pwd)

echo -e "Installing Powerline Fonts"

cd /tmp
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
cd $pwd
