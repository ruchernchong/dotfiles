#!/usr/bin/env bash

echo -e "Updating Aliases..."

rm -f ~/.aliases
ln -s ~/dotfiles/.aliases ~/.aliases
