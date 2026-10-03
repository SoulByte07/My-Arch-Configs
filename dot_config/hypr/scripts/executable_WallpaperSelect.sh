#!/usr/bin/env bash
set -u
# ==================================================
#  KoolDots (2026)
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# This script for selecting wallpapers (SUPER W)

# Wallpaper path
PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || true)"
[ -n "$PICTURES_DIR" ] || PICTURES_DIR="$HOME/Pictures"
wallDIR="$PICTURES_DIR/wallpapers"
SCRIPTSDIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts"
# shellcheck source=/dev/null
. "$SCRIPTSDIR/WallpaperCmd.sh"
wallpaper_current="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/wallpaper_effects/.wallpaper_current"
wallpaper_link="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/rofi/.current_wallpaper"
wallpaper_base="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/wallpaper_effects/.wallpaper_base"

# Check if package bc exists
if ! command -v bc &>/dev/null; then
  notify-send "Wallpaper selector" "bc is required for the Rofi preview size"
  exit 1
fi

# Variables
rofi_theme="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/rofi/config-wallpaper.rasi"
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

# Ensure focused_monitor is detected
if [[ -z "$focused_monitor" ]]; then
  notify-send "Wallpaper selector" "Could not detect focused monitor"
  exit 1
fi

# Monitor details
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')

icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
rofi_override="element-icon{size:${adjusted_icon_size}%;}"

# Retrieve image wallpapers
mapfile -d '' PICS < <(find -L "${wallDIR}" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o \
  -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" \) -print0)

if [[ "${#PICS[@]}" -eq 0 ]]; then
  notify-send "Wallpaper selector" "No supported images found in $wallDIR"
  exit 1
fi

RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="$(basename "$RANDOM_PIC")"

CURRENT_MON_PIC_PATH=""
if [[ -L "$wallpaper_link" ]]; then
  CURRENT_MON_PIC_PATH="$(readlink -f "$wallpaper_link" 2>/dev/null || true)"
fi
if [[ -z "$CURRENT_MON_PIC_PATH" || ! -f "$CURRENT_MON_PIC_PATH" ]] && [[ -f "$wallpaper_current" ]]; then
  CURRENT_MON_PIC_PATH="$wallpaper_current"
fi
if [[ ! -f "$CURRENT_MON_PIC_PATH" ]]; then
  CURRENT_MON_PIC_PATH=""
fi
CURRENT_MON_PIC_NAME=""
if [[ -n "$CURRENT_MON_PIC_PATH" ]]; then
  CURRENT_MON_PIC_NAME=$(basename "$CURRENT_MON_PIC_PATH")
fi

# Rofi command
rofi_command="rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override"

# Sorting Wallpapers
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))

  printf "%s\x00icon\x1f%s\n" "Random: $RANDOM_PIC_NAME" "$RANDOM_PIC"
  if [[ -n "$CURRENT_MON_PIC_PATH" && -f "$CURRENT_MON_PIC_PATH" ]]; then
    printf "%s\x00icon\x1f%s\n" "Current: $CURRENT_MON_PIC_NAME" "$CURRENT_MON_PIC_PATH"
  fi

  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    if [[ "$pic_name" =~ \.gif$ ]]; then
      cache_gif_image="$HOME/.cache/gif_preview/${pic_name}.png"
      if [[ ! -f "$cache_gif_image" ]]; then
        mkdir -p "$HOME/.cache/gif_preview"
        magick "${pic_path}[0]" -resize 1920x1080 "$cache_gif_image"
      fi
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$cache_gif_image"
    else
      printf "%s\x00icon\x1f%s\n" "$pic_name" "$pic_path"
    fi
  done
}

# Apply image wallpaper to all monitors
apply_image_wallpaper() {
  local image_path="$1"
  if [[ -z "$image_path" || ! -f "$image_path" ]]; then
    echo "Invalid image path: $image_path" >&2
    return 1
  fi

  if ! wallpaper_set "$image_path" "$(wallpaper_resize_mode "$image_path")"; then
    notify-send "Wallpaper selector" "Failed to apply $(basename "$image_path")"
    return 1
  fi

  # Persist the selected wallpaper for startup and other wallpaper tools.
  mkdir -p "$(dirname "$wallpaper_current")" "$(dirname "$wallpaper_link")"
  ln -sf "$image_path" "$wallpaper_link"
  cp -f "$image_path" "$wallpaper_current"
  cp -f "$image_path" "$wallpaper_base" || true

  # Run additional scripts (pass the image path to avoid cache race conditions)
  if ! "$SCRIPTSDIR/WallustSwww.sh" "$image_path"; then
    notify-send "Wallpaper selector" "Wallust failed; wallpaper theme not refreshed"
    return 1
  fi
  sleep 0.5
  "$SCRIPTSDIR/Refresh.sh"
  sleep 0.3

}

# Main function
main() {
  "${XDG_CONFIG_HOME:-$HOME/.config}/hypr/scripts/RofiFocusedWallpaperLink.sh" >/dev/null 2>&1 || true
  choice=$(menu | $rofi_command)
  choice=$(echo "$choice" | xargs)
  RANDOM_PIC_NAME=$(echo "$RANDOM_PIC_NAME" | xargs)
  raw_choice="$choice"
  choice="${choice#Random: }"
  choice="${choice#Current: }"

  if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

  # Resolve selection directly when using Random/Current entries
  if [[ "$raw_choice" == Random:\ * ]]; then
    selected_file="$RANDOM_PIC"
  elif [[ "$raw_choice" == Current:\ * && -n "$CURRENT_MON_PIC_PATH" && -f "$CURRENT_MON_PIC_PATH" ]]; then
    selected_file="$CURRENT_MON_PIC_PATH"
  elif [[ -f "$choice" ]]; then
    selected_file="$choice"
  else
    # Handle random selection by name when needed
    if [[ "$choice" == "$RANDOM_PIC_NAME" ]]; then
      choice=$(basename "$RANDOM_PIC")
    fi
    choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')

    # Search for the selected file in the wallpapers directory, including subdirectories
    selected_file=$(find "$wallDIR" -iname "$choice_basename.*" -print -quit)
  fi

  if [[ -z "$selected_file" ]]; then
    echo "File not found. Selected choice: $choice"
    exit 1
  fi

  apply_image_wallpaper "$selected_file"
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
fi

main
