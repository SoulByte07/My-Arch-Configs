# zsh-autocomplete (load FIRST - provides real-time suggestions as you type)
[[ -f /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Autosuggestions (Must be loaded before syntax highlighting)
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Autosuggestions Configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Use both history and completion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_USE_ASYNC=true                  # Enable async for better performance
ZSH_AUTOSUGGEST_COMPLETION_IGNORE=true          # Don't suggest completions for commands that don't exist
unset ZSH_AUTOSUGGEST_MANUAL_REBIND

# Enable autosuggestions widget (shows suggestions automatically as you type)
# Suggestions appear in gray text - press right arrow (→) or End to accept
# No tab key needed - it works in real-time as you type

# Syntax Highlighting (Must be loaded last)
# Arch path
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
