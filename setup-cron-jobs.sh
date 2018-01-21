#!/usr/bin/env bash

echo "Installing cron jobs\n"
timerStart=$(date +%s)

echo "NPM cache will not be cleaned as recommended by the NPM team.\n"

if [ "$(uname)" == "Darwin" ]; then
    echo "Adding cron job to clean Homebrew cache\n"
    (crontab -l 2>/dev/null; echo "0 12 * * 1 brew cleanup") | crontab -
else
    echo "Homebrew not found. Skip adding cron job for Homebrew...\n"
fi

if [ "$(yarn -v)" != null ]; then
    echo "Adding cron job to clean Yarn cache\n"
    (crontab -l 2>/dev/null; echo "0 12 * * 1 yarn cache clean") | crontab -
else
    echo "Yarn is not found. Skip adding cron job for Yarn...\n"
fi

if [ "$(composer --version)" != null ]; then
    echo "Adding cron job to clean Composer cache\n"
    (crontab -l 2>/dev/null; echo "0 12 * * 1 composer clear-cache") | crontab -
else
    echo "Composer is not found. Skip adding cron job for Composer...\n"
fi

timerStop=$(date +%s)
echo "Cron job(s) have been installed.\n"

duration=$(expr $timerStop - $timerStart)

if [ $duration -lt 60 ]; then
    echo "Time taken: $(($duration % 60)) seconds\n"
else
    echo "Time taken: $(($duration / 60)) minutes and $(($duration % 60)) seconds\n"
fi 

echo "Cron job(s) will be ran weekly at 12mn on Mondays."