#!/usr/bin/env bash

set -u

readonly HISTORY_LIMIT=10

if ! command -v dunstctl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    printf '{"text":"","alt":"none","tooltip":"<b>Notifications unavailable</b>"}\n'
    exit 0
fi

paused="$(dunstctl is-paused 2>/dev/null || printf 'false')"
waiting="$(dunstctl count waiting 2>/dev/null || printf '0')"

if [[ "$paused" == "true" ]]; then
    state="DND enabled"
    [[ "$waiting" -gt 0 ]] && alt="dnd-notification" || alt="dnd-none"
else
    state="DND disabled"
    [[ "$waiting" -gt 0 ]] && alt="notification" || alt="none"
fi

tooltip="$(
    dunstctl history 2>/dev/null |
        jq -r --argjson limit "$HISTORY_LIMIT" --arg state "$state" --arg waiting "$waiting" '
            def plain:
                if type == "string" then .
                elif type == "array" then map(plain) | join("")
                elif type == "object" then ((.data // .text // .value // "") | plain)
                else tostring
                end;
            def xml:
                plain
                | gsub("&"; "&amp;")
                | gsub("<"; "&lt;")
                | gsub(">"; "&gt;")
                | gsub("\""; "&quot;");
            [.. | objects | select(has("appname") and has("id"))]
            | unique_by(.id)
            | .[0:$limit]
            | if length == 0 then
                "<b>󰂚  Notification Center</b>\n<span alpha=\"70%\">No recent notifications</span>\n\n<span alpha=\"70%\">" + $state + "  •  " + $waiting + " waiting</span>"
              else
                "<b>󰂚  Notification Center</b>\n<span alpha=\"70%\">" + $state + "  •  " + $waiting + " waiting</span>\n\n" +
                (to_entries | map(
                    "<span alpha=\"55%\">" + ((.key + 1) | tostring) + "</span>  " +
                    "<b>" + ((.value.appname // "Unknown") | xml) + "</b>\n" +
                    "<span size=\"large\">" + ((.value.summary // "Notification") | xml) + "</span>\n" +
                    (if ((.value.body // "") | plain | length) > 0 then
                        "<span alpha=\"75%\">" +
                        ((.value.body | plain | gsub("[\r\n\t]+"; " ") | xml)) +
                        "</span>"
                     else "" end)
                ) | join("\n<span alpha=\"25%\">────────────────────────</span>\n\n"))
              end
        ' 2>/dev/null
)"

if [[ -z "$tooltip" ]]; then
    tooltip="<b>󰂚  Notification Center</b>\n<span alpha=\"70%\">No recent notifications</span>"
fi

jq -cn \
    --arg alt "$alt" \
    --arg tooltip "$tooltip" \
    '{text:"", alt:$alt, tooltip:$tooltip}'
