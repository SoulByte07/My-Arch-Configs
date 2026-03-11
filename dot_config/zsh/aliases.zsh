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
alias mgd='systemctl --user start rclone-mount-gdrive && echo "✅ G-Drive Mounted"'
alias umgd='systemctl --user stop rclone-mount-gdrive && echo "🛑 G-Drive Unmounted"'
alias megd='systemctl --user start rclone-mount-encrypt-gdrive && echo "✅ G-Drive Mounted"'
alias umegd='systemctl --user stop rclone-mount-encrypt-gdrive && echo "🛑 G-Drive Unmounted"'



# pacman 
alias pss='pacman -Ss'
alias pqs='pacman -Qs'
alias psi='sudo pacman -S --needed'


# flatpak 
alias fks='flatpak search'
alias fki='flatpak install'

# Git Shortcuts
alias gs='git status'
alias gpl='git pull'
alias gf='git fetch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -15'
alias gla='git log --oneline --all --graph --decorate'
alias gb='git branch'
alias gco='git checkout'
alias gcl='git clone'
alias gst='git stash'
alias gstp='git stash pop'
alias grs='git restore'
alias grss='git restore --staged'



# PDF viewer Zathura
alias pdf='zathura'

# chmod 
alias cx='chmod +x'

# tmux
alias t='tmux'


# clear 
alias cl='clear'

# compile 
alias smci='sudo make clean install'

