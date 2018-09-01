#!/usr/bin/env bash

echo -e "Starting script\n"
timerStart=$(date +%s)

echo "------------------------------------------------"
echo -e $COL_YELLOW"Setting up your macOS/Linux development environment..."$COL_RESET
echo "------------------------------------------------"

chmod a+x setup/*.sh

SETUP_SCRIPTS=./setup/*
for file in $SETUP_SCRIPTS; do
    filename=$(basename "$file")
    ./$file
done

###############################################################################
# Shell Scripts                                                               #
###############################################################################

chmod a+x shell/*.sh

# Execute the base scripts
SHELL_FILES=./shell/*
for file in $SHELL_FILES; do
    filename=$(basename "$file")
    ./$file
done

timerStop=$(date +%s)

duration=$(expr $timerStop - $timerStart)

if [ $duration -lt 60 ]; then
    echo -e "Time taken: $(($duration % 60)) seconds"
else
    echo -e "Time taken: $(($duration / 60)) minutes and $(($duration % 60)) seconds"
fi 
