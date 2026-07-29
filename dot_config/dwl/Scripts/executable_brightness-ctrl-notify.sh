#!/bin/sh
# brightness-ctrl-notify.sh
# Adjust backlight and show a synchronized desktop notification.
# Usage: ./brightness-ctrl-notify.sh up|down

set -u

case "${1-}" in
    up)
        brightnessctl set +1% >/dev/null
        ;;
    down)
        brightnessctl set 1%- >/dev/null
        ;;
    *)
        exit 1
        ;;
esac

# brightnessctl -m output is CSV; field 4 is percentage (e.g. 60%).
line="$(brightnessctl -m)"
IFS=,
set -- $line
brightness="${4-0%}"
brightness="${brightness%\%}"

notify-send \
    -a 'Brightness' \
    -h string:x-canonical-private-synchronous:brightness \
    -h int:value:"$brightness" \
    "󰃟 Brightness: ${brightness}%"
