# Interactive Kill
fkill() {
  local pid=$(ps aux | fzf | awk '{print $2}')
  [[ -n "$pid" ]] && kill -9 "$pid"
}

# Git Checkout Branch
# gcb() {
#   local branch=$(git branch -a | fzf --preview 'git log -1 --oneline {}')
#   [[ -n "$branch" ]] && git checkout "${branch#remotes/origin/}"
# }

# Fast Git Commit
gc() {
  git add .
  git commit -m "$*"
}

# Push with auto upstream setup
# gpush() {
#   local branch=$(git rev-parse --abbrev-ref HEAD)
#   git push -u origin "$branch"
# }

# Create and switch to new branch
# gnew() {
#   [[ -z "$1" ]] && { echo "Usage: gnew <branch-name>"; return 1; }
#   git checkout -b "$1"
# }

# Undo last commit (keep changes staged)
# gundo() {
#   git reset --soft HEAD~1
#   echo "Last commit undone. Changes are staged."
# }

# Amend last commit with staged changes
# gamend() {
#   git commit --amend --no-edit
# }

# Interactive clean untracked files
# gclean() {
#   git clean -i -d
# }

# Create GitHub PR (requires gh CLI)
# gpr() {
#   gh pr create --fill "$@"
# }

# Sync current branch with main/master
# gsync() {
#   local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
#   [[ -z "$main_branch" ]] && main_branch="main"
#   git fetch origin "$main_branch" && git rebase "origin/$main_branch"
# }


# OpenCode sandboxing using bubblewrap
op() {
    local binary="/usr/sbin/opencode"
    local config_dir="$HOME/.config/opencode" 

    if [[ ! -x "$binary" ]]; then
        echo "❌ Error: opencode not found."
        return 1
    fi

    echo "🛡️  Sandboxing opencode (Mapping config and current dir)..."

    bwrap \
        --ro-bind /usr /usr \
        --ro-bind-try /lib /lib \
        --ro-bind-try /lib64 /lib64 \
        --ro-bind /etc/ld.so.cache /etc/ld.so.cache \
        --bind . /cwd \
        --tmpfs /tmp \
        --proc /proc \
        --dev /dev \
        --chdir /cwd \
        --unshare-all \
        --clearenv \
        --setenv PATH "/usr/bin:/usr/sbin" \
        --setenv HOME "/cwd" \
        --bind-try "$config_dir" "/cwd/.config/opencode" \
        --die-with-parent \
        "$binary" "$@"
}



# Function to run lf and change to the last visited directory on exit
lfcd() {
    # Create a temporary file to store the final directory path
    tmp="$(mktemp)"
    
    # Run lf, instructing it to write the last directory to our temp file
    lf -last-dir-path="$tmp" "$@"
    
    # Check if the temporary file was successfully created
    if [ -f "$tmp" ]; then
        # Read the directory path
        dir="$(cat "$tmp")"
        # Clean up the temporary file immediately
        rm -f "$tmp"
        
        # If it's a valid directory and different from our current one, jump to it
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}





# 3. Tell Zsh to switch cursor shapes based on the current mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q' # Send signal for thick block
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q' # Send signal for thin bar
  fi
}
zle -N zle-keymap-select

# 4. Force the terminal to start in insert mode with a thin bar every time you press Enter
zle-line-init() {
    zle -K viins
    echo -ne '\e[6 q'
}
zle -N zle-line-init


# television cheat sheet function
# tv-cheat() {
#     # 1. Pick the app (e.g., docker, tar, git)
#     local app
#     app=$(command tv cheat-apps)
#     
#     # Exit if you hit ESC
#     [ -z "$app" ] && return
#
#     local sheet_path="$HOME/.config/cheat/cheatsheets/community/$app"
#
#     # 2. The "Glue" Logic:
#     # It converts 2 lines into 1: "# Description  »  command --flags"
#     command awk '
#         /^#/ {desc=$0; next} 
#         /^[[:space:]]*$/ {next} 
#         {if(desc!="") print desc "  »  " $0; desc=""}
#     ' "$sheet_path" | command tv cheat-lines
# }

# VM manager
vm() {
    echo "Starting KVM/QEMU services..."
    sudo systemctl start libvirtd
    sudo virsh net-start default
    virt-manager
    
    # Optional: Cleanup after closing virt-manager
    echo "Virt-manager closed. Shutting down services?"
    read -p "(y/n): " choice
    if [ "$choice" = "y" ]; then
        sudo virsh net-destroy default
        sudo systemctl stop libvirtd
        echo "Environment cleaned."
    fi
}
