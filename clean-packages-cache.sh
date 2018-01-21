#!/usr/bin/env bash

if [ "$(uname)" == "Darwin"] then
    brew cleanup
fi

if [ "$(npm -v)" != null ] then
    npm cache clean --force
elif [ "$(yarn -v)" != null ] then
    yarn cache clean
elif [ "$(composer --version)" != null ] then
    composer clear-cache
fi