# ==========================================
# 1. History Configuration
# ==========================================
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

# ==========================================
# 2. RAM-Optimized Completion Setup
# ==========================================
# Define the dump file path in RAM (Falls back to /tmp)
local ZDUMP="${XDG_RUNTIME_DIR:-/tmp}/.zcompdump-$HOST-$ZSH_VERSION"

autoload -Uz compinit

# Check if the RAM-based cache exists and is fresh
if [[ -n "$ZDUMP"(#qN.m-1) ]]; then
  # Use -C (cache) and -u (ignore security checks for speed)
  compinit -C -d "$ZDUMP"
else
  # First time in this boot session: Generate the cache in RAM
  compinit -i -d "$ZDUMP"
  zcompile "$ZDUMP"
fi

zmodload zsh/complist

# Persistent completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# ==========================================
# 3. FZF Global Theme (Catppuccin Mocha)
# ==========================================
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--pointer='▌' --prompt='❯ ' --marker='✔ '"

# ==========================================
# 4. fzf-tab Core Behavior & Visuals
# ==========================================
# Hide default zsh menu so fzf-tab can capture it
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'

# Enable Tmux Popup and force the Catppuccin theme
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Add rounded border, custom pointer, and correct padding for borders
zstyle ':fzf-tab:*' fzf-flags --border=rounded --pointer='▌'
zstyle ':fzf-tab:*' fzf-pad 4

# Preview directory's content with eza/lsd/ls when completing cd
# Optimized: use (( $+commands[eza] )) for faster check
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'if (( $+commands[eza] )); then eza -1 --color=always $realpath; else ls -1 --color=always $realpath; fi'

# Switch group using `[` and `]`
zstyle ':fzf-tab:*' switch-group '[' ']'

# ==========================================
# 5. fzf-tab Command Previews
# ==========================================
# Environment variables
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

# Kill command (process preview)
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags --preview-window=down:3:wrap

# Systemctl (status preview)
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'systemctl status $word'

# Help / Man
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|)man:*' fzf-preview 'man $word'

# Git (show diff/log)
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta || git diff $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

# ==========================================
# 6. Formatting & Performance Optimization
# ==========================================
# Catppuccin Mocha colors for headers
zstyle ':completion:*:descriptions' format $'\e[01;35m[%d]\e[0m'
zstyle ':fzf-tab:*' group-colors \
    $'\e[31m' $'\e[32m' $'\e[33m' $'\e[34m' $'\e[35m' $'\e[36m'

# Use hashmap to speed up command lookup 
setopt HASH_CMDS
