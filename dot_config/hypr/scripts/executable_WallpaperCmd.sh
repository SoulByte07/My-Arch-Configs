#!/usr/bin/env bash
# Shared static wallpaper helpers for swaybg.

wallpaper_monitor_dimensions() {
  local monitor="${1:-}"
  local dims=""

  command -v hyprctl >/dev/null 2>&1 || return 1
  if command -v jq >/dev/null 2>&1; then
    if [ -n "$monitor" ]; then
      dims="$(hyprctl monitors -j 2>/dev/null | jq -r --arg mon "$monitor" '.[] | select(.name == $mon) | "\(.width) \(.height)"' | awk 'NF == 2 {print; exit}')"
    else
      dims="$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused == true) | "\(.width) \(.height)"' | awk 'NF == 2 {print; exit}')"
    fi
  fi
  [ -n "$dims" ] || return 1
  printf '%s\n' "$dims"
}

wallpaper_image_dimensions() {
  local image_path="$1"
  local dims=""

  [ -f "$image_path" ] || return 1
  if command -v magick >/dev/null 2>&1; then
    dims="$(magick identify -ping -format '%w %h' "${image_path}[0]" 2>/dev/null || true)"
  elif command -v identify >/dev/null 2>&1; then
    dims="$(identify -ping -format '%w %h' "${image_path}[0]" 2>/dev/null || true)"
  fi
  [ -n "$dims" ] || return 1
  printf '%s\n' "$dims"
}

wallpaper_resize_mode() {
  local mode="${WALLPAPER_RESIZE_MODE:-crop}"
  case "${mode,,}" in
    fit|stretch|tile|center)
      printf '%s\n' "${mode,,}"
      ;;
    *)
      printf '%s\n' "fill"
      ;;
  esac
}

wallpaper_set() {
  local image_path="$1"
  local mode="${2:-fill}"
  local swaybg_log="${XDG_CACHE_HOME:-$HOME/.cache}/hypr/swaybg.log"
  local swaybg_pid_file="${XDG_RUNTIME_DIR:-/tmp}/hypr-swaybg.pid"
  local previous_pid=""
  local swaybg_pid=""

  [ -f "$image_path" ] || return 1
  command -v swaybg >/dev/null 2>&1 || return 1

  mkdir -p "$(dirname "$swaybg_log")" || return 1
  mkdir -p "$(dirname "$swaybg_pid_file")" || return 1

  if [ -f "$swaybg_pid_file" ]; then
    read -r previous_pid <"$swaybg_pid_file" || true
    if [[ "$previous_pid" =~ ^[0-9]+$ ]] &&
      [ -r "/proc/$previous_pid/comm" ] &&
      [ "$(cat "/proc/$previous_pid/comm" 2>/dev/null)" = "swaybg" ]; then
      kill "$previous_pid" >/dev/null 2>&1 || true
      for _ in 1 2 3 4 5; do
        kill -0 "$previous_pid" >/dev/null 2>&1 || break
        sleep 0.1
      done
    fi
    rm -f "$swaybg_pid_file"
  fi

  swaybg -i "$image_path" -m "$mode" </dev/null >>"$swaybg_log" 2>&1 &
  swaybg_pid=$!
  printf '%s\n' "$swaybg_pid" >"$swaybg_pid_file"

  for _ in 1 2 3 4 5 6 7 8 9 10; do
    if ! kill -0 "$swaybg_pid" 2>/dev/null; then
      rm -f "$swaybg_pid_file"
      printf 'swaybg exited while loading %s; see %s\n' "$image_path" "$swaybg_log" >&2
      return 1
    fi
    sleep 0.1
  done

  if [ ! -r "/proc/$swaybg_pid/comm" ] ||
    [ "$(cat "/proc/$swaybg_pid/comm" 2>/dev/null)" != "swaybg" ]; then
    rm -f "$swaybg_pid_file"
    printf 'swaybg process became unavailable while loading %s; see %s\n' "$image_path" "$swaybg_log" >&2
    return 1
  fi
}

export -f wallpaper_monitor_dimensions wallpaper_image_dimensions
export -f wallpaper_resize_mode wallpaper_set
