#!/bin/sh
# Script Name: dwl_pomodoro.sh
# Description: Minimal, optimized suspend pomodoro timer for DWL.
# Input: ./dwl_pomodoro.sh 25
# Expected Output: Background daemon that triggers a menu and suspends system.

WORK_MINS=${1:-25}

while true; do
    # 1. Work Session
    sleep "$(( WORK_MINS * 60 ))"
    
    # 2. Break Prompt
    notify-send "󱫌 Pomodoro Timer" "Take a break."
    sleep 5
    
    # Optimization: Use printf for faster, POSIX-compliant string generation.
    CHOICE=$(printf "Yes\nNo\n" | tofi \
        --prompt "󱎫 Pomodoro Timer: Break?" \
        --num-results 2 \
        --ascii-input=false \
        --font="FiraCode Nerd Font" \
        --fuzzy-match=false)

    # Optimization: Use POSIX [ ] instead of bash-specific [[ ]]
    if [ "$CHOICE" = "Yes" ]; then
        
        sleep 1 
        
        # 3. Native Suspend
        systemctl suspend
        
        # --- SCRIPT PAUSES HERE ---
        # It resumes automatically upon manual wake and unlock.
        notify-send "󱎫 Pomodoro Timer" "Welcome back!"
    else
        # This also safely catches if you press 'Esc' to dismiss the tofi menu
        notify-send "󱫤 Pomodoro Timer" "Timer Reset. Focus mode extended."
    fi
done
