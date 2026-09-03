#!/bin/sh
# dwl-random-wall.sh
# Build wallpaper cache and launch a random background image using wbg.

set -u

wall_dir="$HOME/Pictures/wallpapers"
cache_file="$HOME/.cache/wallpaper_cache.txt"

# 1. Update cache if missing or requested
if [ ! -f "$cache_file" ] || [ "${1-}" = 'update' ]; then
    find -L "$wall_dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) > "$cache_file"
fi

# 2. Pick a random image
random_img="$(shuf -n 1 "$cache_file" 2>/dev/null || true)"
[ -n "$random_img" ] || exit 1

# 3. Kill previous instance of wbg
pkill -x wbg >/dev/null 2>&1 || true

# 4. Final process replacement: wbg takes the path directly as an argument
# Sample Input: ./dwl-random-wall.sh
# Expected Output: Background changes; script process is replaced by wbg.
# exec wbg -s "$random_img"
exec swaybg -i "$random_img" -m fill
