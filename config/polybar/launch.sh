#!/bin/bash
killall -q polybar
while pgrep -u "$UID" -x polybar > /dev/null; do sleep 0.2; done

# Auto-detect monitor and wired/wireless interface so config.ini never needs
# a manual edit on a different machine (falls back to the defaults baked
# into config.ini's ${env:VAR:default} if detection comes up empty).
export MONITOR="${MONITOR:-$(xrandr --query 2>/dev/null | awk '/ connected/{print $1; exit}')}"
export NET_IFACE="${NET_IFACE:-$(ip -o -4 route show to default 2>/dev/null | awk '{print $5; exit}')}"
if [ -z "$NET_IFACE" ]; then
  export NET_IFACE="$(ip -o link show up 2>/dev/null | awk -F': ' '$2 != "lo" {print $2; exit}')"
fi

polybar main -c ~/.config/polybar/config.ini &
