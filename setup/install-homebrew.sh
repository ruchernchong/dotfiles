#!/usr/bin/env bash

if ! type "$brew" > /dev/null; then
    echo -e "Installing Homebrew!\n"

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

