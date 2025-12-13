#!/bin/zsh

# Source platform detection
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && cd .. && pwd)"
source "$SCRIPT_DIR/lib/platform.sh"

if ! type brew &> /dev/null; then
    echo "Installing Homebrew!"
    echo "Platform detected: $(get_os_name)"

    # Use official Homebrew installer (works on macOS and Linux)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # On Linux, add Homebrew to PATH for current session
    if is_linux; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    echo "✅ Homebrew installed successfully"
else
    echo "Homebrew is already installed"
fi

