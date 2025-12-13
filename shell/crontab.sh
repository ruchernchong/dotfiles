#!/bin/zsh

# Source state file if it exists
[[ -f "$HOME/dotfiles/.setup-state" ]] && source "$HOME/dotfiles/.setup-state"

echo -e "Updating crontab configuration..."

# Check if user chose to skip crontab replacement
# Default to true (replace) if not explicitly set to false
if [[ "${REPLACE_CRONTAB:-true}" == "false" ]]; then
    echo -e "  ⏭️  Skipping crontab replacement (user choice)"
    exit 0
fi

# Backup existing crontab if it exists
if crontab -l > /dev/null 2>&1; then
    echo -e "  📋 Backing up existing crontab to $HOME/.crontab.backup"
    crontab -l > $HOME/.crontab.backup
else
    echo -e "  📋 No existing crontab found"
fi

# Apply the dotfiles crontab
echo -e "  ⚙️  Applying crontab from dotfiles"
crontab $HOME/dotfiles/config/crontab

echo -e "  ✅ Crontab updated successfully"
echo -e "  📝 Use 'crontab -l' to view current cron jobs"