#!/bin/bash
# =============================================================================
# Link fnm-managed Node to /usr/local/bin for Claude Desktop
# =============================================================================
# Run this script after changing Node versions with fnm
# Usage: link-node (via alias) or ./scripts/link-node.sh

set -e

FNM_NODE="$HOME/.local/share/fnm/aliases/default/bin/node"
TARGET="/usr/local/bin/node"

if [[ ! -f "$FNM_NODE" ]]; then
  echo "Error: fnm default node not found at $FNM_NODE"
  echo "Set a default node version with: fnm default <version>"
  exit 1
fi

# Check if symlink already exists and points to the correct location
if [[ -L "$TARGET" ]] && [[ "$(readlink "$TARGET")" == "$FNM_NODE" ]]; then
  echo "Symlink is up to date."
  echo "Node version: $($TARGET --version)"
  exit 0
fi

echo "Linking fnm node to $TARGET..."
sudo ln -sf "$FNM_NODE" "$TARGET"

echo "Done! Node version at $TARGET:"
$TARGET --version
