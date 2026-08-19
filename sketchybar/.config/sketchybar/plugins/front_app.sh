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

# AeroSpace may rotate list-windows output when focusing multiple windows from
# the same application. Preserve a focus-independent ID order per workspace.
order_file="${TMPDIR:-/tmp}/sketchybar-window-order-${user_id}-${workspace}"
order_tmp="${order_file}.$$"
printf '%s\n' "$windows" | awk -F '|' -v order_file="$order_file" '
  BEGIN {
    while ((getline id < order_file) > 0) previous[++previous_count] = id
    close(order_file)
  }
  NF {
    current[$1] = 1
    incoming[++incoming_count] = $1
  }
  END {
    for (i = 1; i <= previous_count; i++) {
      id = previous[i]
      if (current[id] && !seen[id]++) print id
    }
    for (i = 1; i <= incoming_count; i++) {
      id = incoming[i]
      if (!seen[id]++) print id
    }
  }
' > "$order_tmp" && mv "$order_tmp" "$order_file"

label="$(printf '%s\n' "$windows" | awk -F '|' \
  -v focused_id="$focused_id" -v state_file="$state_file" \
  -v order_file="$order_file" '
    BEGIN {
      while ((getline line < state_file) > 0) {
        split(line, field, "\t")
        id = field[1]
        sub(/^[^\t]*\t/, "", line)
        custom[id] = line
      }
      close(state_file)
      while ((getline id < order_file) > 0) order[++order_count] = id
      close(order_file)
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
      names[id] = name
    }
    END {
      for (i = 1; i <= order_count; i++) {
        id = order[i]
        if (names[id] == "") continue
        name = names[id]
        if (id == focused_id) name = "[" name "]"
        result = result (result == "" ? "" : "  ") name
      }
      print result
    }
  ')"

[ -n "$label" ] && sketchybar --set "$NAME" label="$label"
