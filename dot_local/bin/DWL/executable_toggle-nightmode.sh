#!/bin/sh
# Lightweight toggle for wlsunset

if pgrep -x "wlsunset" > /dev/null
then
    pkill -x "wlsunset"
else
    # Your specific coordinates for Vijayawada
    wlsunset -l 16.5 -L 80.6 &
fi
