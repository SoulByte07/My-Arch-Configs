#!/bin/sh
# tools-manager.sh
# Launch executable helper scripts from a rofi menu.
# Usage: ./tools-manager.sh

set -u

script_dir="$HOME/.local/bin/Tools"
theme_path="$HOME/.config/rofi/themes/KooL_Catppuccin_mocha.rasi"

[ -d "$script_dir" ] || exit 1

script_list="$(find "$script_dir" -maxdepth 2 -type f -executable -printf '%P\n')"
[ -n "$script_list" ] || exit 0

chosen="$(printf '%s\n' "$script_list" | rofi -dmenu -i -p ' Run Tool: ' -theme "$theme_path" || true)"
[ -n "$chosen" ] || exit 0

"$script_dir/$chosen" &
