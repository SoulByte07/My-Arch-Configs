#!/usr/bin/env bash
# ==================================================
#  KoolDots (2026)
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# Hypridle & Caffeine mode controller for Waybar and scripts

PROCESS="hypridle"
SCRIPTSDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

is_running() {
    pgrep -x "$PROCESS" >/dev/null 2>&1
}

send_notify() {
    local title="$1" msg="$2" icon="${3:-dialog-information}"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Caffeine" -i "$icon" -u low "$title" "$msg"
    fi
}

case "${1:-status}" in
    status)
        if is_running; then
            echo '{"text": "󰈈", "alt": "active", "class": "active", "tooltip": "Caffeine Mode: OFF\n• Idle Alert: 5m\n• Auto-Lock: 6m\n• Locked Screen-Off: 10s\nLeft-Click: Enable Caffeine Mode\nRight-Click: Lock Screen"}'
        else
            echo '{"text": "󱫗", "alt": "inhibited", "class": "inhibited", "tooltip": "Caffeine Mode: ON (Awake)\n• Screen will stay awake permanently\nLeft-Click: Disable Caffeine Mode\nRight-Click: Lock Screen"}'
        fi
        ;;

    toggle)
        if is_running; then
            pkill -x "$PROCESS"
            send_notify "Caffeine Mode ON" "Screen will stay awake indefinitely" "dialog-warning"
        else
            if [ -x "$SCRIPTSDIR/HypridleStartup.sh" ]; then
                "$SCRIPTSDIR/HypridleStartup.sh" >/dev/null 2>&1 || true
            else
                hypridle >/dev/null 2>&1 &
            fi
            send_notify "Caffeine Mode OFF" "Normal idle timers restored (5m alert / 6m lock)" "dialog-information"
        fi
        ;;

    start)
        if ! is_running; then
            if [ -x "$SCRIPTSDIR/HypridleStartup.sh" ]; then
                "$SCRIPTSDIR/HypridleStartup.sh" >/dev/null 2>&1 || true
            else
                hypridle >/dev/null 2>&1 &
            fi
            send_notify "Hypridle Started" "Normal idle timers active" "dialog-information"
        fi
        ;;

    stop)
        if is_running; then
            pkill -x "$PROCESS"
            send_notify "Hypridle Stopped" "Caffeine active" "dialog-warning"
        fi
        ;;

    restart)
        pkill -x "$PROCESS" 2>/dev/null || true
        sleep 0.5
        if [ -x "$SCRIPTSDIR/HypridleStartup.sh" ]; then
            "$SCRIPTSDIR/HypridleStartup.sh" >/dev/null 2>&1 &
        else
            hypridle >/dev/null 2>&1 &
        fi
        send_notify "Hypridle Restarted" "Idle timers refreshed" "dialog-information"
        ;;

    *)
        echo "Usage: $0 {status|toggle|start|stop|restart}"
        exit 1
        ;;
esac
