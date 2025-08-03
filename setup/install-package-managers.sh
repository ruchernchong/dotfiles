#!/bin/bash

# Package Manager Installation Script
# Interactive checkbox selection for Node.js package managers

set -e

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Colour

# Function to print coloured output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Package manager options
declare -a PACKAGES=("npm" "yarn" "pnpm" "bun")
declare -a DESCRIPTIONS=(
    "Node Package Manager (comes with Node.js)"
    "Fast, reliable, and secure dependency management"
    "Fast, disk space efficient package manager"
    "Incredibly fast JavaScript runtime and package manager"
)
declare -a SELECTED=(false false false false)
CURRENT_SELECTION=0

# Function to clear screen and show cursor at top
clear_screen() {
    clear
    tput cup 0 0
}

# Function to hide cursor
hide_cursor() {
    tput civis
}

# Function to show cursor
show_cursor() {
    tput cnorm
}

# Function to draw the checkbox menu
draw_menu() {
    clear_screen
    
    echo -e "${CYAN}=========================================================="
    echo -e "       Node.js Package Manager Installation"
    echo -e "==========================================================${NC}"
    echo ""
    echo "Use ↑/↓ to navigate, SPACE to select/deselect, ENTER to install"
    echo ""
    
    for i in "${!PACKAGES[@]}"; do
        local prefix=""
        local suffix=""
        
        # Highlight current selection
        if [[ $i -eq $CURRENT_SELECTION ]]; then
            prefix="${YELLOW}> "
            suffix="${NC}"
        else
            prefix="  "
        fi
        
        # Show checkbox state
        local checkbox=""
        if [[ "${SELECTED[$i]}" == "true" ]]; then
            checkbox="${GREEN}[✓]${NC}"
        else
            checkbox="[ ]"
        fi
        
        echo -e "${prefix}${checkbox} ${PACKAGES[$i]} - ${DESCRIPTIONS[$i]}${suffix}"
    done
    
    echo ""
    echo -e "${BLUE}Selected packages:${NC}"
    local selected_count=0
    for i in "${!PACKAGES[@]}"; do
        if [[ "${SELECTED[$i]}" == "true" ]]; then
            echo "  • ${PACKAGES[$i]}"
            ((selected_count++))
        fi
    done
    
    if [[ $selected_count -eq 0 ]]; then
        echo "  (none selected)"
    fi
    
    echo ""
    echo "Press 'q' to quit without installing"
}

# Function to handle key input
handle_input() {
    local key
    
    while true; do
        draw_menu
        
        # Read a single character
        read -rsn1 key
        
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 key
                case "$key" in
                    '[A')  # Up arrow
                        ((CURRENT_SELECTION--))
                        if [[ $CURRENT_SELECTION -lt 0 ]]; then
                            CURRENT_SELECTION=$((${#PACKAGES[@]} - 1))
                        fi
                        ;;
                    '[B')  # Down arrow
                        ((CURRENT_SELECTION++))
                        if [[ $CURRENT_SELECTION -ge ${#PACKAGES[@]} ]]; then
                            CURRENT_SELECTION=0
                        fi
                        ;;
                esac
                ;;
            ' '|$'\x20')  # Spacebar (handle both space and hex 20)
                if [[ "${SELECTED[$CURRENT_SELECTION]}" == "true" ]]; then
                    SELECTED[$CURRENT_SELECTION]=false
                else
                    SELECTED[$CURRENT_SELECTION]=true
                fi
                ;;
            $'\n'|$'\r')  # Enter
                break
                ;;
            'q'|'Q')  # Quit
                show_cursor
                print_info "Exiting without installing anything."
                exit 0
                ;;
        esac
    done
}

# Installation functions
install_npm() {
    if command_exists node && command_exists npm; then
        print_success "npm is already installed ($(npm --version))"
        return 0
    fi
    
    print_info "Installing Node.js (which includes npm)..."
    
    if command_exists fnm; then
        print_info "Using fnm to install Node.js..."
        fnm install --lts
        fnm use lts-latest
        fnm default lts-latest
    elif command_exists brew; then
        brew install node
    else
        print_error "Neither fnm nor Homebrew is available. Please install one of them first."
        return 1
    fi
    
    print_success "npm installed successfully ($(npm --version))"
}

install_yarn() {
    if command_exists yarn; then
        print_success "yarn is already installed ($(yarn --version))"
        return 0
    fi
    
    print_info "Installing yarn..."
    
    if command_exists brew; then
        brew install yarn
    elif command_exists npm; then
        npm install -g yarn
    else
        print_error "Neither Homebrew nor npm is available. Cannot install yarn."
        return 1
    fi
    
    print_success "yarn installed successfully ($(yarn --version))"
}

install_pnpm() {
    if command_exists pnpm; then
        print_success "pnpm is already installed ($(pnpm --version))"
        return 0
    fi
    
    print_info "Installing pnpm..."
    
    if command_exists brew; then
        brew install pnpm
    elif command_exists npm; then
        npm install -g pnpm
    else
        print_error "Neither Homebrew nor npm is available. Cannot install pnpm."
        return 1
    fi
    
    print_success "pnpm installed successfully ($(pnpm --version))"
}

install_bun() {
    if command_exists bun; then
        print_success "bun is already installed ($(bun --version))"
        return 0
    fi
    
    print_info "Installing bun..."
    
    if command_exists brew; then
        brew tap oven-sh/bun
        brew install oven-sh/bun/bun
    else
        curl -fsSL https://bun.sh/install | bash
        export PATH="$HOME/.bun/bin:$PATH"
    fi
    
    print_success "bun installed successfully ($(bun --version))"
}

# Function to install selected packages
install_selected_packages() {
    local selected_packages=()
    
    for i in "${!PACKAGES[@]}"; do
        if [[ "${SELECTED[$i]}" == "true" ]]; then
            selected_packages+=("${PACKAGES[$i]}")
        fi
    done
    
    if [[ ${#selected_packages[@]} -eq 0 ]]; then
        print_warning "No packages selected for installation."
        return 0
    fi
    
    echo ""
    print_info "Installing selected packages: ${selected_packages[*]}"
    echo ""
    
    for package in "${selected_packages[@]}"; do
        case "$package" in
            "npm")
                install_npm
                ;;
            "yarn")
                install_yarn
                ;;
            "pnpm")
                install_pnpm
                ;;
            "bun")
                install_bun
                ;;
        esac
    done
}

# Main function
main() {
    # Check if we're on macOS or Linux
    if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_warning "This script is designed for macOS and Linux systems."
    fi
    
    # Handle non-interactive mode (command line arguments)
    if [[ $# -gt 0 ]]; then
        for arg in "$@"; do
            case "$arg" in
                "npm"|"1")
                    SELECTED[0]=true
                    ;;
                "yarn"|"2")
                    SELECTED[1]=true
                    ;;
                "pnpm"|"3")
                    SELECTED[2]=true
                    ;;
                "bun"|"4")
                    SELECTED[3]=true
                    ;;
                *)
                    print_error "Unknown package: $arg"
                    exit 1
                    ;;
            esac
        done
        
        install_selected_packages
        return 0
    fi
    
    # Interactive mode
    hide_cursor
    
    # Trap to ensure cursor is restored on exit
    trap 'show_cursor; exit 0' EXIT INT TERM
    
    handle_input
    
    show_cursor
    
    install_selected_packages
    
    echo ""
    print_success "Package manager installation completed!"
    
    # Show installed versions
    echo ""
    echo "Installed package managers:"
    for pm in npm yarn pnpm bun; do
        if command_exists "$pm"; then
            echo "  $pm: $($pm --version)"
        fi
    done
}

# Run the main function with all arguments
main "$@"