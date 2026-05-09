# --- 1. Core Plugins ---

# Load zsh-defer for async execution
source "$ZDOTDIR/plugins/zsh-defer/zsh-defer.plugin.zsh"

# --- 2. Plugin Loading ---

# fzf-tab (Arch-git, Arch-repo, Alpine, and Local Fallback)
# Note: Loaded immediately after compinit (in options.zsh) for stability
if [[ -f /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh ]]; then
  source /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.zsh
elif [[ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
elif [[ -f "$HOME/.cache/zsh/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$HOME/.cache/zsh/fzf-tab/fzf-tab.plugin.zsh"
fi

# Autosuggestions (Common paths)
zsh-defer -c '
  local paths=(
    "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  )
  for p in $paths; do
    if [[ -f "$p" ]]; then
      source "$p"
      
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
      break
    fi
  done
'

# Syntax Highlighting (Common paths)
# Note: Loaded synchronously here to ensure it hooks into ZLE correctly.
local hl_paths=(
  "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)
for p in $hl_paths; do
  if [[ -f "$p" ]]; then
    source "$p"
    break
  fi
done

# --- 3. Immediate Utilities ---

# Edit Command Buffer
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X' edit-command-line
