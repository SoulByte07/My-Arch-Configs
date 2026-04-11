# zsh-autocomplete (load FIRST - provides real-time suggestions as you type)
[[ -f /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Autosuggestions (Must be loaded before syntax highlighting)
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi


# # 1. Load zsh-defer (Ensure you have cloned this to your home dir)
# # git clone https://github.com/romkatv/zsh-defer.git ~/.config/zsh/plugins/zsh-defer
# source ~/.config/zsh/plugins/zsh-defer/zsh-defer.plugin.zsh

# # 2. Autosuggestions (Load immediately, but run ASYNC)
# # This provides the 'ghost text' without blocking the shell
# if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
#   source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# fi

# # 3. Autocomplete (DEFER - This is the 70ms+ culprit)
# # We defer this so the prompt appears before the menu logic starts
# if [[ -f /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]]; then
#   zsh-defer source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# fi

# # 4. Syntax Highlighting (Load LAST and Defer)
# if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
#   zsh-defer source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# fi




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
