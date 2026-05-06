#!/bin/sh
set -eu

# bookmarks-menu.sh
# Rofi bookmark manager backed by folders/files.
# Usage: BM_DIR="$HOME/path/to/bookmarks" ./bookmarks-menu.sh

bm_dir="${BM_DIR:-$HOME/4_Backups/0_Sync/Bookmarks}"
rofi_theme="$HOME/.config/rofi/themes/KooL_Catppuccin_mocha.rasi"
cr_char="$(printf '\r')"

mkdir -p "$bm_dir"

if command -v flatpak >/dev/null 2>&1; then
    has_flatpak=1
else
    has_flatpak=0
fi

chromium_bin="$(command -v chromium 2>/dev/null || printf '%s\n' chromium)"

helium_bin="$(command -v helium-browser 2>/dev/null || printf '%s\n' helium-browser)"

brave_origin="$(command -v brave-origin-nightly 2>/dev/null || printf '%s\n' brave-origin-nightly)"

rofi_pick() {
    rofi -dmenu -i -theme "$rofi_theme" -p "$1"
}

trim_right() {
    val="$1"
    while :; do
        case "$val" in
            *"$cr_char") val="${val%"$cr_char"}" ;;
            *' ') val="${val% }" ;;
            *) break ;;
        esac
    done
    printf '%s' "$val"
}

get_bookmarks() {
    printf '%s\n' '[+] Add New Bookmark'

    find "$bm_dir" -mindepth 2 -type f | while IFS= read -r file; do
        rel_path="${file#"$bm_dir"/}"
        tag="${rel_path%/*}"
        name="${rel_path##*/}"

        raw_url=''
        IFS= read -r raw_url < "$file" || true
        url="$(trim_right "$raw_url")"

        printf '[%s] %s: %s\n' "$tag" "$name" "$url"
    done
}

choice="$(get_bookmarks | rofi_pick 'Bookmarks:' || true)"
[ -n "$choice" ] || exit 0

if [ "$choice" = '[+] Add New Bookmark' ]; then
    name="$(rofi_pick 'Name:' </dev/null || true)"
    [ -n "$name" ] || exit 0

    url="$(rofi_pick 'URL:' </dev/null || true)"
    [ -n "$url" ] || exit 0

    existing_tags="$(find "$bm_dir" -mindepth 1 -type d -printf '%P\n' 2>/dev/null || true)"
    if [ -z "$existing_tags" ]; then
        existing_tags="personal
work"
    fi

    tag="$(printf '%b\n' "$existing_tags" | rofi_pick 'Assign Folder:' || true)"
    [ -n "$tag" ] || exit 0

    browser="$(printf '%s\n' 'Librewolf' 'Brave' 'Chromium' 'Helium' 'Brave-Origin' | rofi_pick 'Select Browser:' || true)"
    [ -n "$browser" ] || exit 0

    mkdir -p "$bm_dir/$tag"
    printf '%s\n%s\n' "$url" "$browser" > "$bm_dir/$tag/$name"
    notify-send 'Bookmark Saved' "'$name' will open in $browser"
    exit 0
fi

tag="${choice%%]*}"
tag="${tag#\[}"
rest="${choice#*] }"
name="${rest%%: *}"
file_path="$bm_dir/$tag/$name"

[ -f "$file_path" ] || {
    notify-send 'Bookmark Error' "Cannot find file: $file_path"
    exit 1
}

raw_url=''
raw_browser=''
{
    IFS= read -r raw_url || true
    IFS= read -r raw_browser || true
} < "$file_path"

url="$(trim_right "$raw_url")"
saved_browser="$(trim_right "$raw_browser")"

case "$url" in
    http://*|https://*|file://*|about:*|chrome:*) ;;
    *) url="https://$url" ;;
esac

open_browser() {
    case "$saved_browser" in
        Librewolf)
            if [ "$has_flatpak" -eq 1 ]; then
                setsid flatpak run io.gitlab.librewolf-community "$url" >/dev/null 2>&1 &
            else
                setsid librewolf "$url" >/dev/null 2>&1 &
            fi
            ;;
        Brave)
            if [ "$has_flatpak" -eq 1 ]; then
                setsid flatpak run com.brave.Browser "$url" >/dev/null 2>&1 &
            else
                setsid brave "$url" >/dev/null 2>&1 &
            fi
            ;;
        Chromium)
            setsid "$chromium_bin" "$url" >/dev/null 2>&1 &
            ;;
        Helium)
            setsid "$helium_bin" "$url" >/dev/null 2>&1 &
            ;;
        Brave-Origin)
            setsid "$brave_origin" "$url" >/dev/null 2>&1 &
            ;;
        *)
            if [ "$has_flatpak" -eq 1 ]; then
                setsid flatpak run io.gitlab.librewolf-community "$url" >/dev/null 2>&1 &
            else
                setsid librewolf "$url" >/dev/null 2>&1 &
            fi
            ;;
    esac
}

open_browser
