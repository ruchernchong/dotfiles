#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
    brew install yarn
    yarn global set prefix '/usr/local'
    export PATH="$PATH:`yarn global bin`"
else
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo -e "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt remove cmdtest && sudo apt update && sudo apt install yarn
fi