#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

set -euo pipefail

notif="$HOME/.config/swaync/images/ja.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    hyprctl keyword decoration:active_opacity 1 || true
    hyprctl keyword decoration:inactive_opacity 1 || true
    awww kill 2>/dev/null || true
    killall waybar
    sudo sysctl vm.swappiness=10 > /dev/null 2>&1 || true
    sudo -n cpupower frequency-set -g performance 2>/dev/null || true
    sed -i '/xwayland {/,/^}/ s/enabled = false/enabled = true/' "$HOME/.config/hypr/configs/SystemSettings.conf"
    hyprctl reload
    notify-send -e -u low -i "$notif" " Gamemode:" " enabled"
    sleep 0.1
    exit
else
	awww-daemon --format xrgb && awww img "$HOME/.config/rofi/.current_wallpaper" &
    sudo -n cpupower frequency-set -g powersave 2>/dev/null || true
	sleep 0.1
	${SCRIPTSDIR}/WallustSwww.sh
	sleep 0.5
    sudo sysctl vm.swappiness=180 > /dev/null 2>&1 || true
    sed -i '/xwayland {/,/^}/ s/enabled = true/enabled = false/' "$HOME/.config/hypr/configs/SystemSettings.conf"
    hyprctl reload
	${SCRIPTSDIR}/Refresh.sh	 
    notify-send -e -u normal -i "$notif" " Gamemode:" " disabled"
    exit
fi
