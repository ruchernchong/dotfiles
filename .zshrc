# Load Zprof for performance profiling
zmodload zsh/zprof

# Direnv configuration
if (( ${+commands[direnv]} )); then
  emulate zsh -c "$(direnv export zsh)"
  emulate zsh -c "$(direnv hook zsh)"
fi

# Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow"

# Plugins
plugins=(
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# Path Configurations
export PATH="$(brew --prefix)/opt/postgresql@17/bin:$PATH"
export PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"

# Environment Variables
export HOMEBREW_NO_AUTO_UPDATE=1
export NEXT_TELEMETRY_DISABLED=1
export EDITOR=vi
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Shell Integrations and Completions
source $HOME/.aliases
source $HOME/.p10k.zsh
source $HOME/.config/op/plugins.sh
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# NVM (Node Version Manager) configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Custom Aliases
alias zshconfig="vi $HOME/.zshrc"
alias zshreload="source $HOME/.zshrc"
alias venv="source .venv/bin/activate"

# Custom Functions
function gi() { 
  curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ 
}

function fixUniversalClipboard() {
  defaults delete $HOME/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled
  defaults write $HOME/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled 1
}
