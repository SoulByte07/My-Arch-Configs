#!/bin/bash

# --- Environment Variables (System Setup) ---
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=wlroots
export XDG_SESSION_DESKTOP=dwl
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1

# --- Launch dwl ---
# Apps like mako/swaybg will start automatically via the C patch
exec dwl > ~/.cache/dwl.log 2>&1
