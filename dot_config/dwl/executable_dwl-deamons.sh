#!/bin/sh
# Script Name: dwl_autostart.sh
# Description: Handles all background daemons for the dwl session with minimal overhead.
# Input: None (Executed automatically by dwl on startup)
# Expected Output: Background processes spawned efficiently.

# 1. Start the wallpaper daemon
"$HOME/.config/dwl/Scripts/dwl-random-wall.sh" &

# 2. Start the clipboard watchers
# Boot Wiper: Delete all images from previous sessions immediately.
# Optimization: Use grep -F (Fixed string) which is much faster than regex matching.
cliphist list | grep -F "[[binary data" | cliphist delete

# Start the Text Watcher (Persistent, saves everything)
wl-paste --type text --watch cliphist store &

# Start the Image Watcher (Strict diet: keeps only the newest 5 images)
# Optimization: Replaced 'bash' with 'sh' and merged grep + tail into a single 'awk' process.
wl-paste --type image --watch sh -c 'cliphist store && cliphist list | awk "/\\[\\[binary data/ {if (++c > 5) print}" | cliphist delete' &

# Keep the active clipboard alive when apps close
wl-clip-persist --clipboard regular &

# 3. Start the notification daemon
mako &


# 4. HyprPoolkit: A lightweight, efficient compositor for Wayland.
hyprpolkitagent &


# 5. Night mode
wlsunset -S 07:00 -s 18:00 -t 4000 &

# 6. Pomodoro timer
"$HOME/.config/dwl/Scripts/dwl-pomodoro-timer.sh" 25 5 &
