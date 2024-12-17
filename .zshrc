# Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh Configuration
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=yellow"

# Commented-out Oh My Zsh Options
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"

# Plugins
plugins=(
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Path Configurations
export PATH="$(brew --prefix)/opt/postgresql@17/bin:$PATH"
export PATH="$(brew --prefix)/opt/python@3.12/libexec/bin:$PATH"

# Environment Variables
export HOMEBREW_NO_AUTO_UPDATE=1
export NEXT_TELEMETRY_DISABLED=1
export PATH="$PNPM_HOME:$PATH"
export PNPM_HOME="$HOME/Library/pnpm"

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Shell Integrations and Completions
source $HOME/.aliases
source $HOME/.p10k.zsh
source $HOME/.config/op/plugins.sh
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# Bash Completion
if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

autoload -U +X bashcompinit && bashcompinit

# Direnv
eval "$(direnv hook zsh)"

# Custom Aliases
alias zshconfig="vi $HOME/.zshrc"
alias zshreload="source $HOME/.zshrc"
alias venv="source venv/bin/activate"

# Custom Functions
function gi() { 
  curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;
}

function fixUniversalClipboard() {
	defaults delete $HOME/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled
	defaults write $HOME/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled 1
}
