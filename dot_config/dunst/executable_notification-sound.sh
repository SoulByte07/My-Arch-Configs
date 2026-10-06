#!/usr/bin/env bash

set -e

appname="${1:-}"
summary="${2:-}"

# Notification app names or summaries that should not play sound
MUTED_NOTIFICATIONS=(
    "System monitor"
    "Screen"
)

for muted in "${MUTED_NOTIFICATIONS[@]}"; do
    if [[ "$appname" == "$muted" || "$summary" == "$muted" ]]; then
        exit 0
    fi
done

# Dunst passes urgency (LOW, NORMAL, or CRITICAL) as the 5th argument
urgency="${5:-NORMAL}"
sound_dir="${HOME}/.local/share/sounds"

if [ "$urgency" = "CRITICAL" ]; then
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
    if [ "$urgency" = "CRITICAL" ]; then
        canberra-gtk-play -i dialog-warning >/dev/null 2>&1 &
    else
        canberra-gtk-play -i message-new-instant >/dev/null 2>&1 &
    fi
fi
