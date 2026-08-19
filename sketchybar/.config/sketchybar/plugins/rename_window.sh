#!/bin/sh

window_id="$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)"
[ -n "$window_id" ] || exit 0

state_file="${TMPDIR:-/tmp}/sketchybar-window-names-$(id -u)"
current_name=""
if [ -r "$state_file" ]; then
  current_name="$(awk -F '\t' -v id="$window_id" '$1 == id { sub(/^[^\t]*\t/, ""); print; exit }' "$state_file")"
fi

name="$(osascript - "$current_name" <<'APPLESCRIPT' 2>/dev/null
on run argv
  set oldName to item 1 of argv
  set answer to display dialog "Name this window:" default answer oldName with title "AeroSpace Window" buttons {"Cancel", "Save"} default button "Save" cancel button "Cancel"
  return text returned of answer
end run
APPLESCRIPT
)" || exit 0

# Tabs/newlines would corrupt the small tab-separated state file.
name="$(printf '%s' "$name" | tr '\t\r\n' '   ')"
tmp_file="${state_file}.tmp.$$"

if [ -r "$state_file" ]; then
  awk -F '\t' -v id="$window_id" '$1 != id' "$state_file" > "$tmp_file"
else
  : > "$tmp_file"
fi

# Saving an empty name clears the override and restores the application title.
[ -n "$name" ] && printf '%s\t%s\n' "$window_id" "$name" >> "$tmp_file"
mv "$tmp_file" "$state_file"

sketchybar --trigger aerospace_focus_changed
