#!/bin/sh

# 1. Start the Keyring Daemon
if [ -z "$GNOME_KEYRING_CONTROL" ]; then
    eval $(gnome-keyring-daemon --start --components=secrets)
    export GNOME_KEYRING_CONTROL
fi

# 2. Run Background/One-Shot tasks 
"$HOME/.config/dwl/Scripts/dwl-random-wall.sh" &

# Added '|| true' so the script doesn't fail if the grep finds nothing
cliphist list | grep -F "[[binary data" | cliphist delete || true

# 3. Start daemons via systemctl
systemctl --user start cliphist-text.service
systemctl --user start cliphist-image.service
systemctl --user start hyprpolkitagent.service
systemctl --user start wlsunset.service

# 4. Your Pomodoro script
"$HOME/.config/dwl/Scripts/dwl-pomodoro-timer.sh" 25 5 &
