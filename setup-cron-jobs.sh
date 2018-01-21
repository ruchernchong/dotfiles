#!/usr/bin/env bash

echo -e "Installing cron jobs\n"
timerStart=$(date +%s)

echo -e "NPM cache will not be cleaned as recommended by the NPM team.\n"

if [ "$(uname)" == "Darwin" ]; then
    echo -e "Adding cron job to clean Homebrew cache\n"
    (crontab -l 2>/dev/null; echo "0 12 * * 1 brew cleanup") | crontab -
else
    echo -e "Homebrew not found. Skip adding cron job for Homebrew...\n"
fi

if [ "$(yarn -v)" != null ]; then
    echo -e "Adding cron job to clean Yarn cache\n"
    (crontab -l 2>/dev/null; echo "0 12 * * 1 yarn cache clean") | crontab -
else
    echo -e "Yarn is not found. Skip adding cron job for Yarn...\n"
fi

if [ "$(composer --version)" != null ]; then
    echo -e "Adding cron job to clean Composer cache\n"
    (crontab -l 2>/dev/null; echo "0 12 * * 1 composer clear-cache") | crontab -
else
    echo -e "Composer is not found. Skip adding cron job for Composer...\n"
fi

timerStop=$(date +%s)
echo -e "Cron job(s) have been installed.\n"

duration=$(expr $timerStop - $timerStart)

if [ $duration -lt 60 ]; then
    echo -e "Time taken: $(($duration % 60)) seconds\n"
else
    echo -e "Time taken: $(($duration / 60)) minutes and $(($duration % 60)) seconds\n"
fi 

echo -e "Cron job(s) will be ran weekly at 12mn on Mondays."