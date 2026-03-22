#!/usr/bin/env bash
# Optimized Portal Starter for Soul (Arch-Hyprland)

# 1. Kill everything to start fresh
killall -q xdg-desktop-portal-hyprland
killall -q xdg-desktop-portal-gtk
killall -q xdg-desktop-portal

# 2. Start the Hyprland backend (Essential for screen sharing)
/usr/lib/xdg-desktop-portal-hyprland &
sleep 1

# 3. Start the Core portal (This automatically pulls in the GTK backend when needed)
/usr/lib/xdg-desktop-portal &

# Note: You don't usually need to manually start the -gtk one; 
# the core portal calls it as a 'child' when an app asks for a file picker.
