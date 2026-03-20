# Wayland ONLY - No X11 Fallback
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=wlroots

# Force Toolkits to Wayland
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export CLUTTER_BACKEND=wayland

export ELECTRON_OZONE_PLATFORM_HINT=wayland
