#!/bin/sh

# Show every window in the focused workspace. Custom names are kept by
# rename_window.sh for the lifetime of the current login session.
user_id="$(id -u)"
state_file="${TMPDIR:-/tmp}/sketchybar-window-names-${user_id}"
focused_id="$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)"
workspace="$(aerospace list-workspaces --focused 2>/dev/null)"

[ -n "$workspace" ] || exit 0

windows="$(aerospace list-windows --workspace "$workspace" \
  --format '%{window-id}|%{app-name}|%{window-title}' 2>/dev/null)"

label="$(printf '%s\n' "$windows" | awk -F '|' \
  -v focused_id="$focused_id" -v state_file="$state_file" '
    BEGIN {
      while ((getline line < state_file) > 0) {
        split(line, field, "\t")
        id = field[1]
        sub(/^[^\t]*\t/, "", line)
        custom[id] = line
      }
      close(state_file)
    }
    NF {
      id = $1
      app = $2
      title = $3
      for (i = 4; i <= NF; i++) title = title "|" $i

      if (custom[id] != "") {
        name = custom[id]
      } else if (title != "") {
        name = title
      } else {
        name = app
      }

      # Keep the bar compact when an application exposes a long title.
      if (length(name) > 20) name = substr(name, 1, 17) "..."
      if (id == focused_id) name = "[" name "]"
      result = result (result == "" ? "" : "  ·  ") name
    }
    END { print result }
  ')"

bar_command="${BAR_NAME:-sketchybar}"
if [ "$bar_command" = "sketchybar-bottom" ]; then
  bar_command="$HOME/.local/bin/sketchybar-bottom"
fi
if [ -n "$label" ]; then
  "$bar_command" --set "$NAME" drawing=on label="$label"
else
  "$bar_command" --set "$NAME" drawing=off
fi
