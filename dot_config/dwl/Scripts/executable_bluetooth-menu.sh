#!/bin/sh
# bluetooth-menu.sh
# Minimal Bluetooth power/connect menu for rofi.
# Usage: ./bluetooth-menu.sh

set -u

chosen="$({
    printf '%s\n' '󰂯 Power On'
    printf '%s\n' '󰂲 Power Off'
    printf '%s\n' '󰂱 Connect Device'
} | rofi -dmenu -i -p 'Bluetooth: ' || true)"

case "$chosen" in
    '󰂯 Power On')
        bluetoothctl power on
        ;;
    '󰂲 Power Off')
        bluetoothctl power off
        ;;
    '󰂱 Connect Device')
        device="$(bluetoothctl devices Paired | rofi -dmenu -i -p 'Select Device: ' || true)"
        [ -n "$device" ] || exit 0

        # Input format: "Device MAC_ADDRESS Friendly Name"
        mac="${device#Device }"
        mac="${mac%% *}"
        [ -n "$mac" ] || exit 1

        bluetoothctl connect "$mac"
        ;;
esac
