#!/bin/zsh

# Parse command-line arguments
INTERACTIVE_MODE=true
INSTALL_PROFILE="full"

for arg in "$@"; do
  case $arg in
    --no-interactive)
      INTERACTIVE_MODE=false
      shift
      ;;
    --profile=*)
      INSTALL_PROFILE="${arg#*=}"
      shift
      ;;
  esac
done

export INTERACTIVE_MODE
export INSTALL_PROFILE

# Cleanup state file on exit
cleanup_state() {
    [[ -f "$HOME/dotfiles/.setup-state" ]] && rm -f "$HOME/dotfiles/.setup-state"
}
trap cleanup_state EXIT INT TERM

echo -e "\n🔐 Requesting Administrator's privileges"
sudo true

# Run interactive setup if enabled
if [[ "$INTERACTIVE_MODE" == "true" ]]; then
    source ./setup-interactive.sh
fi

# Source state file if it exists
[[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

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

if [[ -n "$INSTALL_PROFILE" ]] && [[ "$INSTALL_PROFILE" != "full" ]]; then
    # Use profile-specific Brewfile
    source "$HOME/dotfiles/lib/brewfile-profiles.sh"
    BREWFILE_PATH=$(apply_brewfile_profile "$INSTALL_PROFILE")
    if [[ -n "$BREWFILE_PATH" ]] && [[ -f "$BREWFILE_PATH" ]]; then
        echo "Using $INSTALL_PROFILE profile"
        brew bundle install --file="$BREWFILE_PATH"
        rm -f "$BREWFILE_PATH"
    else
        echo "Warning: Could not find profile Brewfile, using default"
        brew bundle install
    fi
else
    # Use default Brewfile (full installation)
    brew bundle install
fi
