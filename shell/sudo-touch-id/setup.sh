#!/bin/zsh

# Touch ID Sudo Configuration Script

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Warning function
display_warning() {
    clear
    echo -e "${RED}==============================================================="
    echo -e "                   ⚠️  IMPORTANT WARNING ⚠️"
    echo -e "===============================================================${NC}"
    echo -e "${YELLOW}"
    echo "🔐 This script will modify system PAM configuration for Touch ID sudo access."
    echo ""
    echo "POTENTIAL RISKS: 🚨"
    echo "- Incorrect configuration may impact sudo authentication"
    echo "- Could potentially create security vulnerabilities"
    echo "- Requires administrative permissions"
    echo ""
    echo -e "${RED}USE AT YOUR OWN RISK 💀${NC}"
    echo -e "${YELLOW}"

    # Prompt for confirmation
    while true; do
        printf "Do you want to proceed? [Y/N]: "
        read response

        case "$response" in
        [Yy] | [Yy][Ee][Ss])
            echo -e "${GREEN}Proceeding with configuration... 🚀${NC}"
            return 0
            ;;
        [Nn] | [Nn][Oo])
            echo -e "${RED}Operation cancelled. Exiting... 👋${NC}"
            exit 1
            ;;
        *)
            echo "Please answer Yes (Y/y) or No (N/n). ❓"
            ;;
        esac
    done
}

setup_touch_id() {
    local sudo_local_template="/etc/pam.d/sudo_local.template"
    local sudo_local="/etc/pam.d/sudo_local"

    # Check if template file exists
    if [ ! -f "$sudo_local_template" ]; then
        echo -e "${RED}Error: sudo_local.template not found 🕵️‍♀️${NC}"
        return 1
    fi

    # Copy template to sudo_local if it doesn't exist
    if [ ! -f "$sudo_local" ]; then
        echo -e "${YELLOW}Creating sudo_local from template... 📝${NC}"
        sudo cp "$sudo_local_template" "$sudo_local"
    fi

    # Uncomment Touch ID line
    sudo sed -i '' 's/^#\(auth       sufficient     pam_tid.so\)/\1/' "$sudo_local"
    # Verify configuration
    if grep -q "auth       sufficient     pam_tid.so" "$sudo_local"; then
        echo -e "${GREEN}Touch ID sudo configuration successful! 👍${NC}"
        echo -e "${YELLOW}Showing updated sudo_local:${NC}"
        cat "$sudo_local"
    else
        echo -e "${RED}Failed to configure Touch ID 😱${NC}"
        return 1
    fi
}

# Main execution function
main() {
    # Display warning and get user confirmation
    display_warning

    # Ensure script is run with sudo
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}This script must be run with sudo 🔑${NC}"
        exit 1
    fi

    # Check macOS version (Catalina or later)
    local os_version=$(sw_vers -productVersion)
    if [[ "$(echo "$os_version" | cut -d. -f1-2)" < "10.15" ]]; then
        echo -e "${RED}Unsupported macOS version. Requires 10.15+ (Catalina or later) 🚫${NC}"
        exit 1
    fi

    # Run setup
    if setup_touch_id; then
        echo -e "\n${YELLOW}Next steps: 📋${NC}"
        echo "1. Restart Terminal 🔄"
        echo "2. Verify Touch ID works with sudo commands 👆"
        exit 0
    else
        echo -e "${RED}Touch ID sudo configuration failed 😞${NC}"
        exit 1
    fi
}

# Execute main function
main "$@"
