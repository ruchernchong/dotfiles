#!/usr/bin/env bash

echo -e "Updating miscellaneous configuration files..."

rm -f ~/.hushlogin
ln -s ~/dotfiles/.hushlogin ~/.hushlogin
