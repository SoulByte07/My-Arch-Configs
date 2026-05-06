# --- 1. Lazy-Loaded Functions ---
# Add our custom functions directory to fpath
fpath=($ZDOTDIR/functions $fpath)

# Autoload all functions in that directory
# -U: suppress alias expansion
# -z: use zsh (not ksh) style
autoload -Uz fkill gc op lfcd vm th pfi yfi ffi s

# --- 2. ZLE Widgets (Synchronous) ---
# These must be loaded immediately to handle terminal interactions

# Cursor shape switching based on mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q' # Block cursor for command mode
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q' # Beam cursor for insert mode
  fi
}
zle -N zle-keymap-select

# Force insert mode on Enter
zle-line-init() {
    zle -K viins
    echo -ne '\e[6 q'
}
zle -N zle-line-init
