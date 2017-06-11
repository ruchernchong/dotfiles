#!/usr/bin/env bash

echo -e "Updating miscellaneous configuration files..."


if [[ "$OSTYPE" != 'linux-gnu' ]]; then
rm -f ~/.hushlogin
ln -s ~/dotfiles/.hushlogin ~/.hushlogin
fi
