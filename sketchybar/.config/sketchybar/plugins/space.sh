#!/bin/sh

# Match the currently selected Modus palette.
MODUS_THEME="operandi"
[ -r "$HOME/.cache/modus-theme/current" ] && MODUS_THEME="$(cat "$HOME/.cache/modus-theme/current")"
if [ "$MODUS_THEME" = "vivendi" ]; then
  ACTIVE_BG=0xff2fafff
  ACTIVE_FG=0xff000000
  INACTIVE_BG=0xff1e1e1e
  INACTIVE_FG=0xff989898
else
  ACTIVE_BG=0xffd8e2f1
  ACTIVE_FG=0xff0031a9
  INACTIVE_BG=0xfff2f2f2
  INACTIVE_FG=0xff595959
fi

workspace="${NAME#space.}"
focused_workspace="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$workspace" = "$focused_workspace" ]; then
  sketchybar --set "$NAME" \
    background.color="$ACTIVE_BG" \
    icon.color="$ACTIVE_FG" \
    label.color="$ACTIVE_FG"
else
  sketchybar --set "$NAME" \
    background.color="$INACTIVE_BG" \
    icon.color="$INACTIVE_FG" \
    label.color="$INACTIVE_FG"
fi
