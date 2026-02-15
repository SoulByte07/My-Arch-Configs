#!/bin/bash
# Status bar
dwlb &
swww-daemon &
# Wallpaper (assuming swww is installed)
swww img /home/soul/Pictures/wallpapers/Anime-Ladys/1377788.png &
dwlb -ipc &
# Notification daemon
#mako &
