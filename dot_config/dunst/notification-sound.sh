#!/bin/sh

set -eu

sound_type="${1:-normal}"
sound_dir="${HOME}/.local/share/sounds"

if [ "$sound_type" = "critical" ]; then
    sound_file="${sound_dir}/notification-critical.wav"
else
    sound_file="${sound_dir}/notification.wav"
fi

# Add personal WAV files at the paths above to use custom sounds. Otherwise,
# use the desktop sound theme so notifications still work out of the box.
if [ -f "$sound_file" ]; then
    if command -v pw-play >/dev/null 2>&1; then
        pw-play "$sound_file" >/dev/null 2>&1 &
    elif command -v paplay >/dev/null 2>&1; then
        paplay "$sound_file" >/dev/null 2>&1 &
    fi
elif command -v canberra-gtk-play >/dev/null 2>&1; then
    if [ "$sound_type" = "critical" ]; then
        canberra-gtk-play -i dialog-warning >/dev/null 2>&1 &
    else
        canberra-gtk-play -i message-new-instant >/dev/null 2>&1 &
    fi
fi
