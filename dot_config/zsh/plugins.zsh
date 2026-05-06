# --- 1. Core Plugins ---

# Load zsh-defer for async execution
source "$ZDOTDIR/plugins/zsh-defer/zsh-defer.plugin.zsh"

# --- 2. Plugin Loading ---

# fzf-tab (Depends on compinit, best loaded early but can be deferred)
zsh-defer source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh

# Autosuggestions (Deferred)
zsh-defer -c '
  if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    
    # Configuration
    ZSH_AUTOSUGGEST_STRATEGY=(history) 
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
    ZSH_AUTOSUGGEST_USE_ASYNC=true
    ZSH_AUTOSUGGEST_COMPLETION_IGNORE=true

    # Prevent Tab from accepting suggestions
    ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(expand-or-complete complete-word)
    ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#(expand-or-complete|complete-word)}")
    ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(expand-or-complete complete-word)

    bindkey "^E" autosuggest-accept
  fi
'

# Syntax Highlighting
# Note: Loaded synchronously here to ensure it hooks into ZLE correctly.
# If you still want to defer it, wrap it in zsh-defer.
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- 3. Immediate Utilities ---

# Edit Command Buffer
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X' edit-command-line
