#!/usr/bin/env bash

# Start the timer
timerStart=$(date +%s)

echo "------------------------------------------------"
echo -e $COL_YELLOW"Setting up your macOS development environment..."$COL_RESET
echo "------------------------------------------------"

###############################################################################
# Shell Scripts                                                               #
###############################################################################

# Execute the base scripts
SHELL_FILES=./shell/*
for file in $SHELL_FILES; do
    filename=$(basename "$file")
    ./$file
done

# Stop the timer
timerStop=$(date +%s)
