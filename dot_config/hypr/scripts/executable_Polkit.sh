#!/usr/bin/env bash
# Optimized Polkit Starter for Soul (Arch-Hyprland)

# We check for the Hyprland agent first because it's the lightest (~12MB)
if [ -f /usr/lib/hyprpolkitagent ]; then
    echo "Starting HyprPolkitAgent..."
    exec /usr/lib/hyprpolkitagent
# Fallback to Gnome only if Hyprland agent isn't found
elif [ -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    echo "Starting Polkit-Gnome (Fallback)..."
    exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
else
    echo "No Polkit agent found. Please install hyprpolkitagent."
fi

# Sample Input: Run script at startup
# Expected Output: "Starting HyprPolkitAgent..." and ~15MB RAM usage.
