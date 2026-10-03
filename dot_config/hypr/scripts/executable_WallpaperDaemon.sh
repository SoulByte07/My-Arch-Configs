#!/usr/bin/env bash
# Start the static swaybg wallpaper process.
set -u

SCRIPTSDIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts"
# shellcheck source=/dev/null
. "$SCRIPTSDIR/WallpaperCmd.sh"

if ! command -v swaybg >/dev/null 2>&1; then
  printf 'WallpaperDaemon: swaybg is not installed\n' >&2
  exit 1
fi

pictures_dir="$(xdg-user-dir PICTURES 2>/dev/null || true)"
[ -n "$pictures_dir" ] || pictures_dir="$HOME/Pictures"
wallpaper_dir="$pictures_dir/wallpapers"
wallpaper_path=""

if [ ! -d "$wallpaper_dir" ]; then
  printf 'WallpaperDaemon: wallpaper directory does not exist: %s\n' "$wallpaper_dir" >&2
  exit 1
fi

mapfile -d '' wallpaper_candidates < <(
  find -L "$wallpaper_dir" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.bmp" -o \
    -iname "*.gif" -o -iname "*.webp" -o -iname "*.tiff" \
  \) -print0 2>/dev/null
)

if [ "${#wallpaper_candidates[@]}" -eq 0 ]; then
  printf 'WallpaperDaemon: no supported images found in %s\n' "$wallpaper_dir" >&2
  exit 1
fi

wallpaper_index=$((RANDOM % ${#wallpaper_candidates[@]}))
wallpaper_path="${wallpaper_candidates[$wallpaper_index]}"

if ! wallpaper_set "$wallpaper_path" "$(wallpaper_resize_mode "$wallpaper_path")"; then
  printf 'WallpaperDaemon: failed to start swaybg for %s\n' "$wallpaper_path" >&2
  exit 1
fi

"$SCRIPTSDIR/RofiFocusedWallpaperLink.sh" >/dev/null 2>&1 || true
"$SCRIPTSDIR/WallustSwww.sh" "$wallpaper_path" >/dev/null 2>&1 || true
