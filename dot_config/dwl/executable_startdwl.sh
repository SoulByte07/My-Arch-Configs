#!/bin/sh
# Script Name: start_dwl.sh
# Description: Starts dwl, pipes slstatus, and triggers the autostart script.
# Input: Run this script from your TTY login (e.g., after typing startw).
# Expected Output: Login shell is replaced by dwl; slstatus pipes data cleanly.

# 1. Load environment variables
# Optimization: Use POSIX '.' instead of bash 'source'
# if [ -f "$HOME/.config/dwl/dwl-env.sh" ]; then
#     . "$HOME/.config/dwl/dwl-env.sh"
# fi

# 2. Launch Environment
# Optimization: 'exec' replaces the current shell process entirely. 
# Your TTY login shell dies, freeing memory, and dwl becomes the primary process.
exec sh -c "slstatus -s | dwl -s '$HOME/.config/dwl/dwl-deamons.sh'"
