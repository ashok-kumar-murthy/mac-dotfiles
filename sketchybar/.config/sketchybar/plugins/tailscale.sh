#!/bin/sh

tailscale_bin=$(command -v tailscale 2>/dev/null)
if [ -z "$tailscale_bin" ] && [ -x /usr/local/bin/tailscale ]; then
  tailscale_bin=/usr/local/bin/tailscale
fi

if [ -n "$tailscale_bin" ] &&
   "$tailscale_bin" status --json 2>/dev/null | grep -q '"BackendState"[[:space:]]*:[[:space:]]*"Running"'; then
  sketchybar --set "$NAME" drawing=on icon="󰒍" label="TS"
else
  sketchybar --set "$NAME" drawing=off
fi
