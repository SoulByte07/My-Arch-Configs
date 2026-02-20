#!/bin/bash

# Define the options
OPTIONS="󰐥 Shutdown\n󰜉 Reboot\n󰗼 Exit\n󰤄 Suspend\n"

# Launch tofi and get user choice
# --prompt-text can be customized to your liking
CHOICE=$(echo -e "$OPTIONS" | tofi --prompt-text "Power Menu: " --num-results 4)

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
