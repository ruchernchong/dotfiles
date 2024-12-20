#!/bin/zsh

echo -e "\n🔐 Requesting Administrator's privileges"
sudo true

echo -e "🚀 Starting initial setup script\n"
timerStart=$(date +%s)

echo "------------------------------------------------"
echo -e $COL_YELLOW"Setting up your macOS/Linux development environment..."$COL_RESET
echo "------------------------------------------------"

echo -e "📂 Making all .sh scripts executable"
chmod a+x **/*.sh

echo -e "🐚 Processing setup scripts..."
SETUP_SCRIPTS=./setup
for file in "$SETUP_SCRIPTS"/*; do
    filename=$(basename "$file")
    echo $filename
    if [[ -x "$file" ]]; then
        echo -e "  ✅ Executing setup script: $filename"
        $file
    else
        echo "  ❌ Not executable: $filename"
    fi
done

###############################################################################
# Shell Scripts                                                               #
###############################################################################

# Execute the base scripts
echo -e "\n🐚 Processing shell scripts..."
SHELL_FILES=./shell
for file in "$SHELL_FILES"/*; do
    filename=$(basename "$file")
    if [[ -x "$file" ]]; then
        echo -e "  ✅ Executing shell script: $filename"
        $file
    else
        echo "  ❌ Not executable: $filename"
    fi
done

timerStop=$(date +%s)

duration=$(expr $timerStop - $timerStart)

echo -e "\n🔒 Removing script execute permissions"
chmod a-x **/*.sh

if [ $duration -lt 60 ]; then
    echo -e "⏱️ Time taken: $(($duration % 60)) seconds"
else
    echo -e "⏱️ Time taken: $(($duration / 60)) minutes and $(($duration % 60)) seconds"
fi

echo -e "\n✨ Setup complete! 🎉"

# Install Homebrew packages
echo "Installing Homebrew packages"
brew bundle install
