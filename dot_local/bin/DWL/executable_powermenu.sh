#!/bin/bash

# Sample Input: Execute the script
# Expected Output: Power menu launches with full UTF-8 icons, ignoring global ASCII settings

# Define the options using UTF-8 hex escape sequences
OPTIONS="\U000f0425 Shutdown\n\U000f0709 Reboot\n\U000f05fc Exit\n\U000f0904 Suspend\n"

# Launch tofi, get user choice, and override the ASCII config
# --ascii-input=false acts as the bypass flag
CHOICE=$(echo -e "$OPTIONS" | tofi \
    --prompt-text "Power Menu: " \
    --num-results 4 \
    --ascii-input=false \
    --font="FiraCode Nerd Font" \
    --fuzzy-match=false
  )



case "$CHOICE" in
    *Shutdown)
        systemctl poweroff
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Exit)
        # Using killall for dwl as per your previous setup
        killall dwl
        ;;
    *Suspend)
        systemctl suspend
        ;;
   *)
        exit 1
        ;;
esac
