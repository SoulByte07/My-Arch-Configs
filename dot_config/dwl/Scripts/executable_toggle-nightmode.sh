#!/bin/sh
# toggle-nightmode.sh
# Toggle wlsunset and show desktop notification.
# Usage: ./toggle-nightmode.sh

if pkill -x wlsunset >/dev/null 2>&1; then
    notify-send 'Display' 'Nightmode Deactivated'
else
    wlsunset -l 16.5 -L 81.5 &
    notify-send 'Display' 'Nightmode Activated'
fi
