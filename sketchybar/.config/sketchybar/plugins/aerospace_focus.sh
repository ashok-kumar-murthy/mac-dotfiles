#!/bin/sh

# Keep only one observer alive across SketchyBar reloads.
pid_file="${TMPDIR:-/tmp}/sketchybar-aerospace-focus-$(id -u).pid"
if [ -r "$pid_file" ]; then
  old_pid=$(cat "$pid_file")
  if kill -0 "$old_pid" 2>/dev/null; then
    exit 0
  fi
fi
printf '%s\n' "$$" > "$pid_file"
trap 'rm -f "$pid_file"' EXIT INT TERM

# Forward AeroSpace focus events to SketchyBar immediately. Reconnect if
# AeroSpace restarts or its event socket is briefly unavailable.
while :; do
  aerospace subscribe focus-changed 2>/dev/null |
    while IFS= read -r event; do
      # The event already identifies the destination workspace. Using it avoids
      # racing a separate query against AeroSpace's focus-state update.
      focused_workspace=$(printf '%s\n' "$event" |
        sed -n 's/.*"workspace":"\([^"]*\)".*/\1/p')
      if [ -z "$focused_workspace" ]; then
        focused_workspace=$(aerospace list-workspaces --focused 2>/dev/null)
      fi
      [ -n "$focused_workspace" ] && \
        sketchybar --trigger aerospace_focus_changed \
          FOCUSED_WORKSPACE="$focused_workspace"
    done
  sleep 1
done
