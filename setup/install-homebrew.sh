#!/bin/zsh

# Source platform detection
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && cd .. && pwd)"
source "$SCRIPT_DIR/lib/platform.sh"

if ! type brew &> /dev/null; then
    echo "Installing Homebrew!"
    echo "Platform detected: $(get_os_name)"

    # Security note: This uses the official Homebrew installer from brew.sh
    # The script is fetched from GitHub's raw content delivery.
    # For additional verification, see: https://docs.brew.sh/Installation
    # You can also manually verify the script at:
    # https://github.com/Homebrew/install/blob/HEAD/install.sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # On Linux, add Homebrew to PATH for current session
    if is_linux; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed successfully"
else
    echo "Homebrew is already installed"
fi

