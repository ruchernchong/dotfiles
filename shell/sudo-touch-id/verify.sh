#!/bin/zsh

# Touch ID Sudo Configuration Verification

# Check sudo_local configuration
echo "Checking sudo_local configuration:"
cat /etc/pam.d/sudo_local

# Verify Touch ID support
echo -e "\nTouch ID Hardware:"
system_profiler SPHardwareDataType | grep "Touch ID"

# Test sudo authentication
echo -e "\nTesting sudo authentication (you may be prompted):"
sudo -v
