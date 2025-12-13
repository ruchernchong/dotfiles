#!/bin/zsh

# Platform Detection Library
# Provides utilities for detecting and handling platform-specific operations

# =============================================================================
# PLATFORM DETECTION
# =============================================================================

# Detect the current operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if running on macOS
is_macos() {
    [[ "$(detect_os)" == "macos" ]]
}

# Check if running on Linux
is_linux() {
    [[ "$(detect_os)" == "linux" ]]
}

# Get OS name for display
get_os_name() {
    local os=$(detect_os)
    case "$os" in
        macos)
            echo "macOS"
            ;;
        linux)
            if [[ -f /etc/os-release ]]; then
                source /etc/os-release
                echo "$NAME"
            else
                echo "Linux"
            fi
            ;;
        *)
            echo "Unknown OS"
            ;;
    esac
}

# Skip script if not on macOS with informative message
require_macos() {
    local script_name="${1:-this script}"

    if ! is_macos; then
        echo "  ⏭️  Skipping $script_name (macOS only, detected: $(get_os_name))"
        return 1
    fi
    return 0
}

# Skip script if not on Linux with informative message
require_linux() {
    local script_name="${1:-this script}"

    if ! is_linux; then
        echo "  ⏭️  Skipping $script_name (Linux only, detected: $(get_os_name))"
        return 1
    fi
    return 0
}

# Export OS variable for easy access
export DETECTED_OS=$(detect_os)
