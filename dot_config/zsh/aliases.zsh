# Navigation & Editor
alias v='nvim'
alias fs='yazi'
alias ...='cd ../..'
alias ....='cd ../../..'

# Modern Replacements
alias ls='eza --color=always --long --git --icons=always --no-filesize --no-time --no-user --no-permissions'
alias ll='eza --color=always --long --git --icons=always'
alias la='eza --color=always --all --icons=always'
alias rm='rmtrash'

# DevOps & Tools
alias cz='chezmoi'
alias fk='fuck'
alias code='flatpak run com.vscodium.codium'

# Cloud/Mounts
alias mgd='systemctl --user start rclone-mount-googledrive && echo "✅ G-Drive Mounted"'
alias ugd='systemctl --user stop rclone-mount-googledrive && echo "🛑 G-Drive Unmounted"'
