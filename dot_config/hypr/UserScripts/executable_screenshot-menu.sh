#!/bin/bash

# ==========================================
# Sample Input: User triggers script, selects "Region (Edit)" in Rofi.
# Expected Output: Slurp activates, user draws a box, Grim captures it, Satty opens the image for editing. Logs saved to /tmp/screenshot_debug.log.
# ==========================================

# Setup directories
save_dir="$HOME/Pictures/Screenshots"
mkdir -p "$save_dir"
filename="$save_dir/screenshot_$(date +%Y%m%d_%H%M%S).png"
log_file="/tmp/screenshot_debug.log"

# Clear old log and start fresh
echo "--- Screenshot Triggered: $(date) ---" > "$log_file"

# Menu options
options="Region (Direct)\nFull (Direct)\nTimer 5s (Direct)\nTimer 10s (Direct)\nRegion (Edit)\nFull (Edit)\nTimer 5s (Edit)\nTimer 10s (Edit)"

# Trigger Rofi and log any errors
choice=$(echo -e "$options" | rofi -dmenu -i -p "ScreenShot: " \
    -theme ~/.config/rofi/themes/KooL_Catppuccin_mocha.rasi \
    -theme-str 'listview { columns: 2; lines: 4; }' 2>> "$log_file")

echo "User selected: '$choice'" >> "$log_file"

# Function: Capture with Satty Editor
capture_edit() {
    local area=$1
    
    # Kept only valid functional flags for Satty CLI
    local satty_flags=(
#        "--fullscreen"
        "--output-filename" "$filename"
    )

    if [ -n "$area" ]; then
        grim -g "$area" - | satty --filename - "${satty_flags[@]}" 2>> "$log_file"
    else
        grim - | satty --filename - "${satty_flags[@]}" 2>> "$log_file"
    fi
    
    [ $? -eq 0 ] && notify-send "Screenshot" "Editor closed."
}

# Function: Capture Direct (Save & Copy)
capture_direct() {
    local area=$1
    if [ -n "$area" ]; then
        grim -g "$area" "$filename" 2>> "$log_file"
    else
        grim "$filename" 2>> "$log_file"
    fi
    
    if [ $? -eq 0 ]; then
        wl-copy < "$filename"
        notify-send "Screenshot" "Saved & Copied: $(basename "$filename")"
    else
        echo "Grim failed to capture." >> "$log_file"
    fi
}

# Decision Logic
case "$choice" in
    "Region (Edit)")
        area=$(slurp < /dev/null 2>> "$log_file")
        [ -n "$area" ] && capture_edit "$area"
        ;;
    "Full (Edit)")
        sleep 0.2 &&
        capture_edit
        ;;
    "Timer 5s (Edit)")
        sleep 5 && capture_edit
        ;;
    "Timer 10s (Edit)")
        sleep 10 && capture_edit
        ;;
    "Region (Direct)")
        area=$(slurp < /dev/null 2>> "$log_file")
        [ -n "$area" ] && capture_direct "$area"
        ;;
    "Full (Direct)")
        sleep 0.2 &&
        capture_direct
        ;;
    "Timer 5s (Direct)")
        sleep 5 && capture_direct
        ;;
    "Timer 10s (Direct)")
        sleep 10 && capture_direct
        ;;
    "")
        echo "Rofi closed without selection or crashed." >> "$log_file"
        exit 0
        ;;
    *)
        echo "Unrecognized choice: $choice" >> "$log_file"
        exit 0
        ;;
esac
