#!/usr/bin/env bash
# snippets-insert.sh

set -euo pipefail

SNIPPET_DIR="${SNIPPET_DIR:-$HOME/.config/snippets}"
[[ -d "$SNIPPET_DIR" ]] || exit 1

selected_file=$(cd "$SNIPPET_DIR" && tv)
[[ -z "$selected_file" ]] && exit 0

FILE_PATH="$SNIPPET_DIR/$selected_file"
[[ -f "$FILE_PATH" ]] || exit 1

# Step 1: Read the file. Bash's $(<file) automatically strips the trailing newline!
CONTENT=$(<"$FILE_PATH")

# Step 2: Encode the clean text to Base64 so it safely bypasses all quoting issues.
B64_CONTENT=$(printf "%s" "$CONTENT" | base64 -w 0)

# Step 3: Dispatch to Hyprland
hyprctl dispatch exec -- "sh -c 'sleep 0.25; printf \"%s\" \"$B64_CONTENT\" | base64 -d | wtype -'"

# Sample Input: A file named 'email.txt' containing "user@example.com" (with a trailing newline in the text file)
# Expected Output: After 250ms, "user@example.com" is typed into the active window, leaving the cursor right after the "m" without pressing Enter.
