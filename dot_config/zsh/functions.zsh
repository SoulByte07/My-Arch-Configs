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
gac() {
  git add .
  git commit -m "$*"
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






