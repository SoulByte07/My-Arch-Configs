#!/usr/bin/env bash
set -u

# One-shot system snapshot for Dunst. It samples CPU and network counters
# twice, rather than keeping a background polling process alive.

readonly NETWORK_INTERFACE="wlp0s20f3"
readonly BATTERY_DEVICE="BAT0"
readonly SAMPLE_INTERVAL="0.25"
readonly NOTIFICATION_TIMEOUT_MS="15000"

read_cpu_counters() {
  awk '$1 == "cpu" { print $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9, $5 + $6 }' /proc/stat
}

read_network_bytes() {
  local rx=0 tx=0
  if [[ -r "/sys/class/net/$NETWORK_INTERFACE/statistics/rx_bytes" ]]; then
    read -r rx < "/sys/class/net/$NETWORK_INTERFACE/statistics/rx_bytes"
    read -r tx < "/sys/class/net/$NETWORK_INTERFACE/statistics/tx_bytes"
  fi
  printf '%s %s\n' "${rx:-0}" "${tx:-0}"
}

format_rate() {
  awk -v bytes="${1:-0}" -v seconds="$SAMPLE_INTERVAL" '
    BEGIN {
      rate = bytes / seconds
      if (rate >= 1048576) printf "%.1f MiB/s", rate / 1048576
      else if (rate >= 1024) printf "%.0f KiB/s", rate / 1024
      else printf "%.0f B/s", rate
    }
  '
}

format_duration() {
  awk -v hours="${1:-0}" '
    BEGIN {
      if (hours <= 0) { print "unknown"; exit }
      total_minutes = int(hours * 60 + 0.5)
      printf "%dh %02dm", int(total_minutes / 60), total_minutes % 60
    }
  '
}

send_notification() {
  local msg="$1"
  if command -v dunstify >/dev/null 2>&1; then
    dunstify -I /home/soul/.local/share/icons/Notification/system-monitor.png -u low -t "$NOTIFICATION_TIMEOUT_MS" -r 4242 "System monitor" "$msg"
  elif command -v notify-send >/dev/null 2>&1; then
    notify-send -u low -t "$NOTIFICATION_TIMEOUT_MS" "System monitor" "$msg"
  else
    printf '%s\n' "$msg" >&2
  fi
}

# 1. Gather static metrics first
read -r memory_total memory_available < <(
  awk '
    /^MemTotal:/ { total = $2 }
    /^MemAvailable:/ { available = $2 }
    END { print total, available }
  ' /proc/meminfo
)
memory_usage="$(awk -v total="$memory_total" -v available="$memory_available" '
  BEGIN {
    used = total - available
    if (total <= 0 || used < 0) { print "unknown"; exit }
    if (total >= 1048576)
      printf "%.1f GB", used / 1048576
    else
      printf "%.0f MB", used / 1024
  }
')"

battery_capacity="unknown"
battery_status="unknown"
battery_time="unknown"
battery_dir="/sys/class/power_supply/$BATTERY_DEVICE"
if [[ -r "$battery_dir/capacity" ]]; then
  read -r battery_capacity < "$battery_dir/capacity"
  read -r battery_status < "$battery_dir/status"

  if [[ -r "$battery_dir/energy_now" && -r "$battery_dir/power_now" ]]; then
    read -r energy_now < "$battery_dir/energy_now"
    read -r power_now < "$battery_dir/power_now"
    [[ "${power_now:-0}" -gt 0 ]] && battery_time="$(format_duration "$(awk -v now="$energy_now" -v power="$power_now" 'BEGIN { print now / power }')")"
  elif [[ -r "$battery_dir/charge_now" && -r "$battery_dir/current_now" ]]; then
    read -r charge_now < "$battery_dir/charge_now"
    read -r current_now < "$battery_dir/current_now"
    [[ "${current_now:-0}" -gt 0 ]] && battery_time="$(format_duration "$(awk -v now="$charge_now" -v current="$current_now" 'BEGIN { print now / current }')")"
  fi
fi

temperature="unknown"
fallback_temperature_input=""
for input in /sys/class/hwmon/hwmon*/temp*_input; do
  [[ -r "$input" ]] || continue
  [[ -z "$fallback_temperature_input" ]] && fallback_temperature_input="$input"
  hwmon_dir="${input%/*}"
  sensor_number="${input##*temp}"
  sensor_number="${sensor_number%_input}"
  label_file="$hwmon_dir/temp${sensor_number}_label"
  label=""
  [[ -r "$label_file" ]] && read -r label < "$label_file"
  if [[ "$label" =~ (Package|Tctl|Tdie|CPU|Core) ]]; then
    read -r millidegrees < "$input"
    temperature="$(awk -v value="$millidegrees" 'BEGIN { printf "%.0f°C", value / 1000 }')"
    break
  fi
done

if [[ "$temperature" == "unknown" && -n "$fallback_temperature_input" ]]; then
  read -r millidegrees < "$fallback_temperature_input"
  temperature="$(awk -v value="$millidegrees" 'BEGIN { printf "%.0f°C", value / 1000 }')"
fi

battery_display="N/A"
if [[ "$battery_capacity" != "unknown" ]]; then
  if [[ "$battery_time" != "unknown" ]]; then
    battery_display="${battery_capacity}% (${battery_time})"
  elif [[ "$battery_status" != "unknown" && -n "$battery_status" ]]; then
    battery_display="${battery_capacity}% (${battery_status})"
  else
    battery_display="${battery_capacity}%"
  fi
fi

# 2. Fire Instant Notification
cpu_before="$(read_cpu_counters)"
network_before="$(read_network_bytes)"

message=$(cat <<EOF
<span font_family="monospace">
<b>Resource</b>     │ <b>Status</b>
─────────────┼────────────────
 Download   │ ...
 Upload     │ ...
󰫆 Battery    │ $battery_display
󰓅 Memory     │ $memory_usage
󰈸 CPU        │ ...
 Temp       │ $temperature
</span>
EOF
)
send_notification "$message"

# 3. Wait and gather final counters
sleep "$SAMPLE_INTERVAL"
cpu_after="$(read_cpu_counters)"
network_after="$(read_network_bytes)"

cpu_usage="$(awk '
  NR == 1 { total_before = $1; idle_before = $2; next }
  { total_after = $1; idle_after = $2 }
  END {
    total_delta = total_after - total_before
    idle_delta = idle_after - idle_before
    if (total_delta > 0) printf "%.0f%%", (1 - idle_delta / total_delta) * 100
    else print "unknown"
  }
' <(printf '%s\n%s\n' "$cpu_before" "$cpu_after"))"

read -r rx_before tx_before <<< "$network_before"
read -r rx_after tx_after <<< "$network_after"
download_rate="$(format_rate "$((rx_after - rx_before))")"
upload_rate="$(format_rate "$((tx_after - tx_before))")"

# 4. Update Notification
message=$(cat <<EOF
<span font_family="monospace">
<b>Resource</b>     │ <b>Status</b>
─────────────┼────────────────
 Download   │ $download_rate
 Upload     │ $upload_rate
󰫆 Battery    │ $battery_display
󰓅 Memory     │ $memory_usage
󰈸 CPU        │ $cpu_usage
 Temp       │ $temperature
</span>
EOF
)
send_notification "$message"
