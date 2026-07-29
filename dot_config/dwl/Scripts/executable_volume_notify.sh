#!/bin/sh
# volume_notify.sh
# Adjust volume with pamixer and display synchronized notification.
# Usage: ./volume_notify.sh up|down|mute

set -u

case "${1-}" in
    up)
        pamixer -i 5
        ;;
    down)
        pamixer -d 5
        ;;
    mute)
        pamixer -t
        ;;
    *)
        exit 1
        ;;
esac

mute="$(pamixer --get-mute)"

if [ "$mute" = 'true' ]; then
    notify-send -a 'Volume' -h string:x-canonical-private-synchronous:audio '  Audio Muted'
else
    volume="$(pamixer --get-volume)"
    notify-send \
        -a 'Volume' \
        -h string:x-canonical-private-synchronous:audio \
        -h int:value:"$volume" \
        "  Volume: ${volume}%"
fi
