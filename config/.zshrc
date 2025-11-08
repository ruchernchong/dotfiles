# =============================================================================
# ZSH CONFIGURATION
# =============================================================================

# -----------------------------------------------------------------------------
# Performance Profiling
# -----------------------------------------------------------------------------
zmodload zsh/zprof

# -----------------------------------------------------------------------------
# Environment Variables
# -----------------------------------------------------------------------------
export NEXT_TELEMETRY_DISABLED=1
export EDITOR=vi
export PNPM_HOME="$HOME/Library/pnpm"
export ENABLE_BACKGROUND_TASKS=1
export FORCE_AUTO_BACKGROUND_TASKS=1

# -----------------------------------------------------------------------------
# PATH Configuration
# -----------------------------------------------------------------------------
export PATH="$(brew --prefix)/opt/postgresql@18/bin:$PATH"
export PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# External Tool Initialization
# -----------------------------------------------------------------------------
# Direnv
if (( ${+commands[direnv]} )); then
  emulate zsh -c "$(direnv export zsh)"
  emulate zsh -c "$(direnv hook zsh)"
fi

# fnm (Fast Node Manager)
eval "$(fnm env --use-on-cd --shell zsh)"

# Starship prompt
eval "$(starship init zsh)"

# -----------------------------------------------------------------------------
# Oh My Zsh Configuration
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow"

plugins=(
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------------------------------
# Shell Integrations and Completions
# -----------------------------------------------------------------------------
source $HOME/.aliases
source $HOME/.config/op/plugins.sh
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
source $HOME/.turso/env

# -----------------------------------------------------------------------------
# Custom Aliases
# -----------------------------------------------------------------------------
alias zshconfig="vi $HOME/.zshrc"
alias zshreload="source $HOME/.zshrc"
alias venv="source .venv/bin/activate"

# -----------------------------------------------------------------------------
# Custom Functions
# -----------------------------------------------------------------------------
function gi() {
  curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@
}

function fixUniversalClipboard() {
  defaults delete $HOME/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled
  defaults write $HOME/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled 1
}
