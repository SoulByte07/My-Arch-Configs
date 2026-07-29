#!/bin/sh
# Script Name: toggle_touchpad.sh
# Description: Toggles touchpad via passwordless root helper.
# Input: None (Triggered via dwl keybind)
# Expected Output: Touchpad state toggled, notification sent to swaync.

DEV_ID="0018:06CB:CE2D.0001"
DRV_PATH="/sys/bus/hid/drivers/hid-multitouch"
NOTIF_ICON="$HOME/.config/swaync/images/ja.png"

# Check directly with POSIX [ -e ]
if [ -e "$DRV_PATH/$DEV_ID" ]; then
    # Action: Disable using the passwordless helper
    sudo /usr/local/bin/touchpad_hw_toggle unbind
    notify-send -u low -i "$NOTIF_ICON" "Touchpad" " Disabled"
else
    # Action: Enable using the passwordless helper
    sudo /usr/local/bin/touchpad_hw_toggle bind
    notify-send -u low -i "$NOTIF_ICON" "Touchpad" " Enabled"
fi
