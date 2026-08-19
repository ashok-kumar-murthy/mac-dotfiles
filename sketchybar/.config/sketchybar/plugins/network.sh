#!/bin/sh

interface=$(route -n get default 2>/dev/null | awk '/interface:/{print $2; exit}')

if [ -z "$interface" ]; then
  sketchybar --set "$NAME" icon="󰖪" label="Offline"
  exit 0
fi

hardware_port=$(networksetup -listallhardwareports 2>/dev/null |
  awk -v target="$interface" '
    /^Hardware Port:/ { port=substr($0, 16) }
    /^Device:/ && $2 == target { print port; exit }
  ')

case "$hardware_port" in
  *Wi-Fi*) icon="󰖩" ;;
  *Ethernet*|*LAN*) icon="󰈀" ;;
  *) icon="󰛳" ;;
esac

ip_address=$(ipconfig getifaddr "$interface" 2>/dev/null)
[ -n "$ip_address" ] || ip_address="No IP"

sketchybar --set "$NAME" icon="$icon" label="$ip_address"
