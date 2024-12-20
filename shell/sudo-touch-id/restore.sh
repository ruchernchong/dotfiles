#!/bin/zsh

# Touch ID Sudo Configuration Restore Script

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

restore_touch_id() {
    local sudo_local="/etc/pam.d/sudo_local"
    local sudo_local_template="/etc/pam.d/sudo_local.template"

    # Check if sudo_local exists
    if [ ! -f "$sudo_local" ]; then
        echo -e "${YELLOW}No sudo_local file found. Nothing to restore. 🤷‍♀️${NC}"
        return 0
    fi

    # Re-comment Touch ID line
    sudo sed -i '' 's/^auth       sufficient     pam_tid.so/#auth       sufficient     pam_tid.so/' "$sudo_local"

    # Verify restoration
    if grep -q "^#auth       sufficient     pam_tid.so" "$sudo_local"; then
        echo -e "${GREEN}Touch ID sudo configuration restored successfully! 👍${NC}"
        echo -e "${YELLOW}Showing updated sudo_local:${NC}"
        cat "$sudo_local"
    else
        echo -e "${RED}Failed to restore Touch ID configuration 😱${NC}"
        return 1
    fi
}

# Main execution function
main() {
    # Ensure script is run with sudo
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}This script must be run with sudo 🔑${NC}"
        exit 1
    fi

    # Run restore
    if restore_touch_id; then
        echo -e "\n${YELLOW}Next steps: 📋${NC}"
        echo "1. Restart Terminal 🔄"
        echo "2. Touch ID sudo access should now be disabled 👆"
        exit 0
    else
        echo -e "${RED}Touch ID sudo configuration restore failed 😞${NC}"
        exit 1
    fi
}

# Execute main function
main "$@"
