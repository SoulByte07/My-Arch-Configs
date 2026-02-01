# --- 1. History Configuration ---
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.cache/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"

setopt SHARE_HISTORY             # Share history across terminals 
setopt HIST_IGNORE_ALL_DUPS      # Clean up duplicates 
setopt HIST_IGNORE_SPACE         # Don't log commands starting with space 
setopt HIST_REDUCE_BLANKS        # Clean up whitespace 
setopt INC_APPEND_HISTORY        # Save immediately 

# --- 2. Completion System Setup ---
# Initialize completion system 
autoload -Uz compinit && compinit -i
zmodload zsh/complist

# --- 3. Completion Behavior & Visuals ---
# Note: zsh-autocomplete handles most completion behavior automatically
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive 
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'   # Use LS_COLORS 

# --- 5. Keybindings ---
# Vi-style navigation inside the menu 
bindkey -M menuselect 'h' vi-backward-char 
bindkey -M menuselect 'j' vi-down-line-or-history 
bindkey -M menuselect 'k' vi-up-line-or-history 
bindkey -M menuselect 'l' vi-forward-char 


# Menu controls 
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab 
bindkey -M menuselect '^M' accept-mode               # Enter to select 
bindkey -M menuselect '^I' menu-complete             # Tab

# Autosuggestion accept (Ctrl+E)
bindkey '^E' autosuggest-accept
