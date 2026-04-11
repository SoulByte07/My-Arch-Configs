#!/bin/sh

# 1. Start the Keyring Daemon
if [ -z "$GNOME_KEYRING_CONTROL" ]; then
    eval $(gnome-keyring-daemon --start --components=secrets)
    export GNOME_KEYRING_CONTROL
fi

# 2. Run "One-Shot" tasks normally (these don't need to stay running)
"$HOME/.config/dwl/Scripts/dwl-random-wall.sh"
# Delelte any binary data from the clipboard history to prevent issues with cliphist
cliphist list | grep -F "[[binary data" | cliphist delete

# 3. Start daemons via systemctl
# This triggers the .service files we created
systemctl --user start cliphist-text.service
systemctl --user start cliphist-image.service
systemctl --user start hyprpolkitagent.service
systemctl --user start wlsunset.service

# 4. Your Pomodoro script (if it stays in the foreground/loops)
"$HOME/.config/dwl/Scripts/dwl-pomodoro-timer.sh" 25 5 &
