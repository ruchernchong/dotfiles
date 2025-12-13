#!/usr/bin/env zsh

# Terminal theme setup script
# Automatically installs terminal themes from the terminal/ directory

set -e

# Source platform detection
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && cd .. && pwd)"
source "$SCRIPT_DIR/lib/platform.sh"

# Only run on macOS
if ! is_macos; then
    echo "⏭️  Skipping terminal theme setup (macOS Terminal.app only)"
    exit 0
fi

DOTFILES_DIR="$HOME/dotfiles"
TERMINAL_DIR="$DOTFILES_DIR/terminal"

echo "🖥️  Setting up terminal themes..."

# Check if Terminal themes directory exists
if [[ ! -d "$TERMINAL_DIR" ]]; then
    echo "❌ Terminal themes directory not found at $TERMINAL_DIR"
    exit 1
fi

# Install all .terminal files
for theme_file in "$TERMINAL_DIR"/*.terminal; do
    if [[ -f "$theme_file" ]]; then
        echo "📦 Installing terminal theme: $(basename "$theme_file")"
        open "$theme_file"
        sleep 1  # Brief pause to allow Terminal.app to process
    fi
done

echo "✅ Terminal theme setup complete!"
echo "💡 You can now select your preferred theme in Terminal > Preferences > Profiles"