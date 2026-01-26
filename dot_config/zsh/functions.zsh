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
