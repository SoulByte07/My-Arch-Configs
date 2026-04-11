#!/bin/sh
# powermenu.sh
# Minimal power menu for dwl/Wayland using tofi.
# Usage: ./powermenu.sh

set -u

blurred_wallpaper="$HOME/Pictures/wallpapers/Github/1351260.png"
base_color='1e1e2e'

choice="$({
    printf '%s\n' '󰐥 Shutdown'
    printf '%s\n' '󰜉 Reboot'
    printf '%s\n' '󰗼 Exit'
    printf '%s\n' '󰤄 Suspend'
} | tofi \
    --prompt-text 'Power Menu: ' \
    --num-results 4 \
    --ascii-input=false \
    --font='FiraCode Nerd Font' \
    --fuzzy-match=false || true)"

case "$choice" in
    *Shutdown)
        exec systemctl poweroff
        ;;
    *Reboot)
        exec systemctl reboot
        ;;
    *Exit)
        exec killall dwl
        ;;
    *Suspend)
        if [ -f "$blurred_wallpaper" ]; then
            set -- --image "$blurred_wallpaper"
        else
            set -- --color "$base_color"
        fi

        swaylock \
          "$@" \
          --clock \
          --indicator \
          --indicator-radius 120 \
          --indicator-thickness 7 \
          --ring-color b4befe \
          --key-hl-color a6e3a1 \
          --bs-hl-color f38ba8 \
          --text-color cdd6f4 \
          --line-color 00000000 \
          --inside-color 1e1e2e88 \
          --separator-color 00000000 \
          --fade-in 0.2 &

        sleep 1
        exec systemctl suspend
        ;;
    *)
        exit 0
        ;;
esac
