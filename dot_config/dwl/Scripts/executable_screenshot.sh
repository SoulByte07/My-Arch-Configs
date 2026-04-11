#!/bin/sh
# screenshot.sh
# Capture screenshots via grim/slurp and optionally edit with satty.
# Usage: ./screenshot.sh

set -u

save_dir="$HOME/Pictures/Screenshots"
mkdir -p "$save_dir"
filename="$save_dir/screenshot_$(date +%Y%m%d_%H%M%S).png"

menu_items() {
    printf '%s\n' 'Region (Direct)'
    printf '%s\n' 'Full (Direct)'
    printf '%s\n' 'Timer 5s (Direct)'
    printf '%s\n' 'Timer 10s (Direct)'
    printf '%s\n' 'Region (Edit)'
    printf '%s\n' 'Full (Edit)'
    printf '%s\n' 'Timer 5s (Edit)'
    printf '%s\n' 'Timer 10s (Edit)'
}

choice="$(menu_items | rofi -dmenu -i -p 'ScreenShot: ' \
    -theme "$HOME/.config/rofi/themes/KooL_Catppuccin_mocha.rasi" \
    -theme-str 'listview { columns: 2; lines: 4; }' || true)"

[ -n "$choice" ] || exit 0

capture_edit() {
    area="${1-}"

    if [ -n "$area" ]; then
        grim -g "$area" - | satty --filename - \
            --fullscreen \
            --output-filename "$filename" \
            --font-family 'FiraCode Nerd Font' \
            --initial-tool brush \
            --corner-roundness 12 \
            --no-window-decoration
    else
        grim - | satty --filename - \
            --fullscreen \
            --output-filename "$filename" \
            --font-family 'FiraCode Nerd Font' \
            --initial-tool brush \
            --corner-roundness 12 \
            --no-window-decoration
    fi

    [ "$?" -eq 0 ] && notify-send 'Screenshot' 'Editor closed.'
}

capture_direct() {
    area="${1-}"

    if [ -n "$area" ]; then
        grim -g "$area" "$filename"
    else
        grim "$filename"
    fi

    if [ "$?" -eq 0 ]; then
        wl-copy < "$filename"
        notify-send 'Screenshot' "Saved & Copied: ${filename##*/}"
    fi
}

case "$choice" in
    'Region (Edit)')
        area="$(slurp < /dev/null || true)"
        [ -n "$area" ] && capture_edit "$area"
        ;;
    'Full (Edit)')
        capture_edit
        ;;
    'Timer 5s (Edit)')
        sleep 5
        capture_edit
        ;;
    'Timer 10s (Edit)')
        sleep 10
        capture_edit
        ;;
    'Region (Direct)')
        area="$(slurp < /dev/null || true)"
        [ -n "$area" ] && capture_direct "$area"
        ;;
    'Full (Direct)')
        capture_direct
        ;;
    'Timer 5s (Direct)')
        sleep 5
        capture_direct
        ;;
    'Timer 10s (Direct)')
        sleep 10
        capture_direct
        ;;
esac
