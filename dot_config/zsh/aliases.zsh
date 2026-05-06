
alias v='nvim'
alias f='yazi'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Modern Replacements
alias l='eza --color=always --long --git --icons=always --no-filesize --no-time --no-user --no-permissions'
alias ll='eza --color=always --long --git --icons=always'
alias la='eza --color=always --all --icons=always'
alias rm='rmtrash'

# DevOps & Tools
alias cz='chezmoi'
alias fk='fuck'
alias tf='terraform'

# Maintenance
alias zsh-update-cache='rm -rf "$HOME/.cache/zsh/tools" && exec zsh'

# pacman 
alias pss='pacman -Ss'
alias pqs='pacman -Qs'
alias psi='sudo pacman -S --needed'
alias psyu='sudo pacman -Syu'
alias prns='sudo pacman -Rns'

# paru 
alias yss='paru -Ss'
alias ysi='paru -S'
alias yrns='paru -Rns'

# Git Shortcuts
alias gpl='git pull'
alias gph='git push'

# PDF viewer Zathura
alias pdf='zathura'

# chmod 
alias cx='chmod +x'

# clear 
alias c='clear'

# compile 
alias smci='sudo make clean install'

# Alias to copy file content to clipboard using wl-copy
alias cf='wl-copy <'

# lazygit 
alias lg='lazygit'

# Nvim pager
alias nv='nvim - -c "nnoremap q :q!<CR>"'

# suffix aliases for opening files in $EDITOR
alias -s go='$EDITOR'
alias -s py='$EDITOR'
alias -s md='$EDITOR'
alias -s conf='$EDITOR'
alias -s yaml='$EDITOR'
alias -s yml='$EDITOR'
alias -s json='$EDITOR'
alias -s xml='$EDITOR'
alias -s toml='$EDITOR'
alias -s ini='$EDITOR'

#  open text files with bat
alias -s txt=bat
alias -s log=bat

# Podman
alias pd='podman'
alias docker='podman'
alias pdc='podman-compose'

# Tmux 
alias t='$HOME/.config/tmux/scripts/start-tmux-home.sh'
