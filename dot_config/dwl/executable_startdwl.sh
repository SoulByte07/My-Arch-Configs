#!/bin/bash
# Description: Starts dwl, pipes slstatus, and triggers the autostart script.

# Sample Input: Run this script from your TTY login.
# Expected Output: slstatus pipes into dwl, dwl launches and runs dwl-autostart.sh cleanly.

# 1. Load environment variables
if [ -f "$HOME/.config/dwl/dwl-env" ]; then
    source "$HOME/.config/dwl/dwl-env"
fi


slstatus -s | dwl -s ~/.config/dwl/dwl-deamons.sh
