# --- 1. History Configuration ---
# Remove non-existent directories from fpath to speed up compinit
fpath=($^fpath(N-/))
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
# autoload -Uz compinit && compinit -i
# zmodload zsh/complist


# autoload -Uz compinit
#
# # Check if the cache file is older than 24 hours (.m-1)
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.m-1) ]]; then
#   # -C skips the security check for maximum speed (uses cache)
#   compinit -C -d "$ZDOTDIR/.zcompdump"
# else
#   # Regenerate cache (runs once a day)
#   compinit -i -d "$ZDOTDIR/.zcompdump"
# fi
#
# zmodload zsh/complist



# --- RAM-Optimized Completion Initialization ---

# 1. Define the dump file path in RAM
# Falls back to /tmp if XDG_RUNTIME_DIR isn't set
local ZDUMP="${XDG_RUNTIME_DIR:-/tmp}/.zcompdump-$HOST-$ZSH_VERSION"

# 2. Advanced compinit logic
autoload -Uz compinit

# Check if the RAM-based cache exists and is fresh
if [[ -n "$ZDUMP"(#qN.m-1) ]]; then
  # Use -C (cache) and -u (ignore security checks for speed)
  compinit -C -d "$ZDUMP"
else
  # First time in this boot session: Generate the cache in RAM
  compinit -i -d "$ZDUMP"
  # Byte-compile the RAM file for even faster internal parsing
  zcompile "$ZDUMP"
fi

# 3. Load complist
zmodload zsh/complist







# --- 3. Completion Behavior & Visuals ---
# Note: zsh-autocomplete handles most completion behavior automatically
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive 
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'   # Use LS_COLORS 

# Delay the autocomplete popup slightly (prevents it from firing on every single tap)
zstyle ':autocomplete:*' delay 0.3  # seconds

# Only show the menu when you actually want it
zstyle ':autocomplete:*' min-input 2

# Disable 'list-choices' for every keystroke to save CPU cycles
zstyle ':completion:*' menu select


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

# Edit Command Buffer
# Open the current command in your $EDITOR (e.g., neovim)
# Press Ctrl+X followed by Ctrl+E to trigger
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X' edit-command-line


# # use hashmap to speed up command lookup
# setopt HASH_CMDS
# # Don't check the path every time - use the hash table
# unsetopt REHASH
