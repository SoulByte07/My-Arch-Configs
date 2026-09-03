alias v='nvim'
alias f='yazi'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# eza
alias l='eza --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'

# Long format aliases
alias ll='eza -lh --icons --git --group-directories-first'
alias lla='eza -lah --icons --git --group-directories-first'

# --tree: Visualizes directory hierarchy
alias lt='eza --tree --level=2 --icons'

# ld: Folder-only navigation
alias ld='eza -D --icons'


alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ping='ping -c 5'

# OS-Aware Trash (rmtrash on Arch, trash-put on Alpine)
# if (( $+commands[rmtrash] )); then
#     alias rm='rmtrash'
# elif (( $+commands[trash-put] )); then
#     alias rm='trash-put'
# fi

# DevOps & Tools
alias cz='chezmoi'
# alias fk='fuck'

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
alias pdc='podman-compose'

# Tmux 
alias t='/home/soul/.config/tmux/scripts/init'

# Distro box
alias db='distrobox'
alias dbp='distrobox enter AlpineBox'
alias dba='distrobox enter ArchBox'
alias ex='exit'

# Marp
alias marp-server='CHROME_PATH=/usr/bin/brave-origin-beta CHROME_ARGUMENTS="--headless=old --no-sandbox" marp --server --config-file ~/.config/marp/marp.config.js'

# Game Mode 
alias game='/home/soul/.config/hypr/scripts/GameMode.sh'
alias gamemini='/home/soul/.config/hypr/scripts/GameMode-Mini.sh'

# Cloud
# alias podsock='systemctl --user start podman.socket'
# alias docker='podman'
alias tf='tflocal'
alias aws='awslocal'

# AI Tools 
alias gm='agy'
alias op='opencode'
alias ops='podman run --rm -it --user root -v "$PWD:/workspace:z" -v "$HOME/.config/opencode:/root/.config/opencode:ro,z" -w /workspace ghcr.io/anomalyco/opencode:latest'

# Fastfetch
alias ff='fastfetch'










