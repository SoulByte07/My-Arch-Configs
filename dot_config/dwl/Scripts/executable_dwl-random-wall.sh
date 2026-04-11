#!/bin/sh
# dwl-random-wall.sh
# Build wallpaper cache and launch a random background image.
# Usage: ./dwl-random-wall.sh [update]

set -u

wall_dir="$HOME/Pictures/wallpapers"
cache_file="$HOME/.cache/wallpaper_cache.txt"

if [ ! -f "$cache_file" ] || [ "${1-}" = 'update' ]; then
    find -L "$wall_dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) > "$cache_file"
fi

random_img="$(shuf -n 1 "$cache_file" 2>/dev/null || true)"
[ -n "$random_img" ] || exit 1

pkill -x swaybg >/dev/null 2>&1 || true

# Final process replacement: no shell process left behind.
exec swaybg -i "$random_img" -m fill
