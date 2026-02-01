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
alias megd='systemctl --user start rclone-mount-encrypt-gdrive && echo "✅ G-Drive Mounted"'
alias uegd='systemctl --user stop rclone-mount-encrypt-gdrive && echo "🛑 G-Drive Unmounted"'




# DNS
# Disable NextDNS and restart resolver (for VPN use)
alias dns-off='sudo mv /etc/systemd/resolved.conf.d/nextdns.conf /etc/systemd/resolved.conf.d/nextdns.conf.bak && sudo systemctl restart systemd-resolved && echo "NextDNS Disabled"'

# Re-enable NextDNS
alias dns-on='sudo mv /etc/systemd/resolved.conf.d/nextdns.conf.bak /etc/systemd/resolved.conf.d/nextdns.conf && sudo systemctl restart systemd-resolved && echo "NextDNS Enabled"'


# pacman 
alias pss='pacman -Ss'
alias pqs='pacman -Qs'
alias psi='sudo pacman -S --needed'


# open code
alias op='opencode'





