#!/bin/bash
# cache_bg.sh

WALL_DIR="$HOME/Pictures/wallpapers"
CACHE_FILE="$HOME/.cache/wallpaper_cache.txt"

# 1. Build the cache if missing or forced to update.
# Follows symlinks (-L) and includes common image formats (png, jpg, jpeg).
if [[ ! -f "$CACHE_FILE" ]] || [[ "$1" == "update" ]]; then
    find -L "$WALL_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) > "$CACHE_FILE"
fi

# 2. Pick a random image from the text file
RANDOM_IMG=$(shuf -n 1 "$CACHE_FILE")

# 3. Kill the old background process and set the new one quietly
pkill swaybg
swaybg -i "$RANDOM_IMG" -m fill &

# --- Sample Input / Output ---
# Sample Input: ./cache_bg.sh update
# Expected Output: (No terminal text output. The cache file updates and the wallpaper changes instantly.)
