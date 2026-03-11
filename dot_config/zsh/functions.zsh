# Interactive Kill
fkill() {
  local pid=$(ps aux | fzf | awk '{print $2}')
  [[ -n "$pid" ]] && kill -9 "$pid"
}

# Git Checkout Branch
gcb() {
  local branch=$(git branch -a | fzf --preview 'git log -1 --oneline {}')
  [[ -n "$branch" ]] && git checkout "${branch#remotes/origin/}"
}

# Fast Git Commit
gc() {
  git add .
  git commit -m "$*"
}

# Push with auto upstream setup
gpush() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  git push -u origin "$branch"
}

# Create and switch to new branch
gnew() {
  [[ -z "$1" ]] && { echo "Usage: gnew <branch-name>"; return 1; }
  git checkout -b "$1"
}

# Undo last commit (keep changes staged)
gundo() {
  git reset --soft HEAD~1
  echo "Last commit undone. Changes are staged."
}

# Amend last commit with staged changes
gamend() {
  git commit --amend --no-edit
}

# Interactive clean untracked files
gclean() {
  git clean -i -d
}

# Create GitHub PR (requires gh CLI)
gpr() {
  gh pr create --fill "$@"
}

# Sync current branch with main/master
gsync() {
  local main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  [[ -z "$main_branch" ]] && main_branch="main"
  git fetch origin "$main_branch" && git rebase "origin/$main_branch"
}


# OpenCode sandboxing using bubblewrap
opsafe() {
    local binary="/usr/sbin/opencode"
    local config_dir="$HOME/.config/opencode" # Update this path if different

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

# opencode in tmp folder
op() {
  cd /home/soul/2_Resources/7_AI Chats/opencode 
  opencode
}




# DNS Functions

# Function to disable NextDNS
# Using the 'function' keyword prevents Zsh alias expansion errors
function dns-off {
    sudo mv /etc/systemd/resolved.conf.d/nextdns.conf /etc/systemd/resolved.conf.d/nextdns.conf.bak
    sudo systemctl restart systemd-resolved
    echo "NextDNS Disabled"
}

# Function to enable NextDNS
function dns-on {
    sudo mv /etc/systemd/resolved.conf.d/nextdns.conf.bak /etc/systemd/resolved.conf.d/nextdns.conf
    sudo systemctl restart systemd-resolved
    echo "NextDNS Enabled"
}


# Function to run lf and change to the last visited directory on exit
lfcd () {
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
