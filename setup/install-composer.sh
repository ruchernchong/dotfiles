#!/usr/bin/env bash

if [[ $(command -v composer) ]]; then
    echo -e "Composer is already installed. Skipping setup..."
else 
    echo -e "Installing Composer\n"

    if [[ $(uname) == "Darwin" ]]; then
        brew install composer
    else
        sudo apt install composer -y
    fi
fi
