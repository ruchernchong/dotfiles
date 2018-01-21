#!/usr/bin/env bash

echo "Starting script\n"
timerStart=$(date +%s)

echo "------------------------------------------------"
echo -e $COL_YELLOW"Setting up your macOS/Linux development environment..."$COL_RESET
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

timerStop=$(date +%s)

duration=$(expr $timerStop - $timerStart)

if [ $duration -lt 60 ]; then
    echo "Time taken: $(($duration % 60)) seconds\n"
else
    echo "Time taken: $(($duration / 60)) minutes and $(($duration % 60)) seconds\n"
fi 