#!/usr/bin/env bash
set -euo pipefail

# Ultra-fast System Monitor Launcher
# Prefers the compiled C binary (slstatus-style direct syscall engine) for near-zero CPU usage.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BIN="$SCRIPT_DIR/system_monitor"
SRC="$SCRIPT_DIR/system_monitor.c"

# 1. Run compiled C binary if available
if [[ -x "$BIN" ]]; then
  exec "$BIN" "$@"
fi

# 2. Auto-compile if source exists and gcc/clang is available
if [[ -f "$SRC" ]]; then
  CC=""
  if command -v gcc &>/dev/null; then
    CC="gcc"
  elif command -v clang &>/dev/null; then
    CC="clang"
  elif command -v cc &>/dev/null; then
    CC="cc"
  fi

  if [[ -n "$CC" ]]; then
    if "$CC" -O3 -Wall -Wextra -pedantic "$SRC" -o "$BIN" 2>/dev/null; then
      exec "$BIN" "$@"
    fi
  fi
fi

# 3. Fallback: Pure Bash implementation if C binary cannot be built
readonly NETWORK_INTERFACE="wlp0s20f3"
readonly BATTERY_DEVICE="BAT0"
readonly SAMPLE_INTERVAL="0.25"
readonly NOTIFICATION_TIMEOUT_MS="15000"

format_rate() {
  local bytes="${1:-0}"
  # rate in bytes per sec: bytes * 4 (since interval is 0.25s)
  local rate=$(( bytes * 4 ))
  if (( rate >= 1048576 )); then
    local mib=$(( rate / 1048576 ))
    local dec=$(( ((rate % 1048576) * 10) / 1048576 ))
    printf '%d.%d MiB/s' "$mib" "$dec"
  elif (( rate >= 1024 )); then
    printf '%d KiB/s' $(( rate / 1024 ))
  else
    printf '%d B/s' "$rate"
  fi
}

send_notification() {
  local msg="$1"
  local icon="/home/soul/.config/dunst/Icons/system-monitor.png"
  [[ -r "$icon" ]] || icon="${HOME}/.local/share/icons/Notification/system-monitor.png"

  if command -v dunstify >/dev/null 2>&1; then
    dunstify -h int:suppress-sound:1 -I "$icon" -u low -t "$NOTIFICATION_TIMEOUT_MS" -r 4242 "System monitor" "$msg"
  elif command -v notify-send >/dev/null 2>&1; then
    notify-send -h int:suppress-sound:1 -u low -t "$NOTIFICATION_TIMEOUT_MS" "System monitor" "$msg"
  else
    printf '%s\n' "$msg" >&2
  fi
}

# Read meminfo with bash built-ins (zero fork)
mem_total=0
mem_avail=0
while read -r key val _; do
  case "$key" in
    MemTotal:) mem_total="$val" ;;
    MemAvailable:) mem_avail="$val" ;;
  esac
  [[ "$mem_total" -gt 0 && "$mem_avail" -gt 0 ]] && break
done < /proc/meminfo

memory_usage="unknown"
if [[ "$mem_total" -gt 0 ]]; then
  mem_used=$(( mem_total - mem_avail ))
  if (( mem_total >= 1048576 )); then
    gb=$(( mem_used / 1048576 ))
    dec=$(( ((mem_used % 1048576) * 10) / 1048576 ))
    memory_usage="${gb}.${dec} GB"
  else
    memory_usage="$(( mem_used / 1024 )) MB"
  fi
fi

# Battery
battery_display="N/A"
battery_dir="/sys/class/power_supply/$BATTERY_DEVICE"
if [[ -r "$battery_dir/capacity" ]]; then
  read -r battery_capacity < "$battery_dir/capacity"
  battery_status=""
  [[ -r "$battery_dir/status" ]] && read -r battery_status < "$battery_dir/status"
  battery_display="${battery_capacity}%"
  [[ -n "$battery_status" ]] && battery_display="${battery_capacity}% (${battery_status})"
fi

# Temperature
temperature="unknown"
for input in /sys/class/hwmon/hwmon*/temp*_input; do
  [[ -r "$input" ]] || continue
  mdeg=""
  read -r mdeg < "$input" 2>/dev/null || continue
  if [[ -n "$mdeg" && "$mdeg" -gt 0 ]]; then
    temperature="$(( (mdeg + 500) / 1000 ))°C"
    break
  fi
done

# Read initial CPU & net counters
read -r _ u1 n1 s1 i1 io1 ir1 so1 st1 _ < /proc/stat
cpu_total1=$(( u1 + n1 + s1 + i1 + io1 + ir1 + so1 + st1 ))
cpu_idle1=$(( i1 + io1 ))

rx1=0; tx1=0
net_rx="/sys/class/net/$NETWORK_INTERFACE/statistics/rx_bytes"
net_tx="/sys/class/net/$NETWORK_INTERFACE/statistics/tx_bytes"
[[ -r "$net_rx" ]] && read -r rx1 < "$net_rx"
[[ -r "$net_tx" ]] && read -r tx1 < "$net_tx"

message="<span font_family=\"monospace\">
<b>Resource</b>     │ <b>Status</b>
─────────────┼────────────────
 Download   │ ...
 Upload     │ ...
󰫆 Battery    │ $battery_display
󰓅 Memory     │ $memory_usage
󰈸 CPU        │ ...
 Temp       │ $temperature
</span>"
send_notification "$message"

sleep "$SAMPLE_INTERVAL"

read -r _ u2 n2 s2 i2 io2 ir2 so2 st2 _ < /proc/stat
cpu_total2=$(( u2 + n2 + s2 + i2 + io2 + ir2 + so2 + st2 ))
cpu_idle2=$(( i2 + io2 ))

rx2=0; tx2=0
[[ -r "$net_rx" ]] && read -r rx2 < "$net_rx"
[[ -r "$net_tx" ]] && read -r tx2 < "$net_tx"

cpu_delta=$(( cpu_total2 - cpu_total1 ))
idle_delta=$(( cpu_idle2 - cpu_idle1 ))
cpu_usage="unknown"
if (( cpu_delta > 0 )); then
  cpu_usage="$(( ((cpu_delta - idle_delta) * 100) / cpu_delta ))%"
fi

download_rate="$(format_rate "$(( rx2 - rx1 ))")"
upload_rate="$(format_rate "$(( tx2 - tx1 ))")"

message="<span font_family=\"monospace\">
<b>Resource</b>     │ <b>Status</b>
─────────────┼────────────────
 Download   │ $download_rate
 Upload     │ $upload_rate
󰫆 Battery    │ $battery_display
󰓅 Memory     │ $memory_usage
󰈸 CPU        │ $cpu_usage
 Temp       │ $temperature
</span>"
send_notification "$message"
