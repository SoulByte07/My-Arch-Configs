#!/usr/bin/env bash

# 1. Pick the app
app=$(tv cheat-sheet-apps)
[ -z "$app" ] && exit 0

# 2. Dynamically find the absolute path
sheet_path=$(find "$HOME/.config/cheat/cheatsheets" -name "$app" -type f | head -n 1)
[ -z "$sheet_path" ] && exit 0

# 3. Parse cleanly for Television UI (NO COLORS injected here)
selection=$(awk '/^#/{desc=$0; next} /^[[:space:]]*$/ {next} {if(desc!="") print desc "  »  " $0; desc=""}' "$sheet_path" | tv cheat-sheet-lines)

# Exit if you hit ESC in the second window
[ -z "$selection" ] && exit 0

# 4. Extract Description and Command separately
desc_text=$(echo "$selection" | awk -F '  »  ' '{print $1}')
command_text=$(echo "$selection" | awk -F '  »  ' '{print $2}')

# Copy pure command to Wayland clipboard
echo -n "$command_text" | wl-copy
notify-send "Cheat Sheet" "Copied: $command_text"

# 5. Display for reading (Colors applied HERE, safely)
clear
echo -e "\033[90m----------------------------------------------------------------------\033[0m"
# Description in Grey
echo -e "\033[1;33m$desc_text\033[0m"
# Command in Bright Green
echo -e "\033[1;32m$command_text\033[0m"
echo -e "\033[90m----------------------------------------------------------------------\033[0m"
echo ""
echo -e "\033[1;30mPress any key to close...\033[0m"

read -n 1 -s -r
