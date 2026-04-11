#!/bin/sh
# Script Name: toggle_touchpad.sh
# Description: Toggles touchpad via kernel driver unbinding.
# Input: None (Triggered via dwl keybind)
# Expected Output: Touchpad state toggled, notification sent to mako/swaync.

DEV_ID="0018:06CB:CE2D.0001"
DRV_PATH="/sys/bus/hid/drivers/hid-multitouch"
NOTIF_ICON="$HOME/.config/swaync/images/ja.png"

# Optimization: Check directly with POSIX [ -e ]
if [ -e "$DRV_PATH/$DEV_ID" ]; then
    # Action: Disable
    # Optimization: Use 'sudo sh -c' to handle the redirect natively. 
    # This removes the need to spawn the 'tee' utility.
    sudo sh -c "echo '$DEV_ID' > '$DRV_PATH/unbind'"
    notify-send -u low -i "$NOTIF_ICON" "Touchpad" "Disabled"
else
    # Action: Enable
    sudo sh -c "echo '$DEV_ID' > '$DRV_PATH/bind'"
    notify-send -u low -i "$NOTIF_ICON" "Touchpad" "Enabled"
fi
