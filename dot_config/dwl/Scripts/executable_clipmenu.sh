#!/bin/sh
# clipmenu.sh
# Show clipboard history in tofi and copy selected entry.
# Usage: ./clipmenu.sh

set -u

selection="$(cliphist list | tofi \
  --prompt-text '󰨸 Clipboard: ' \
  --width 60% \
  --height 45% \
  --num-results 10 \
  --ascii-input=false \
  --font='FiraCode Nerd Font' \
  --font-size=15 \
  --fuzzy-match=true || true)"

[ -n "$selection" ] || exit 0

printf '%s' "$selection" | cliphist decode | wl-copy
