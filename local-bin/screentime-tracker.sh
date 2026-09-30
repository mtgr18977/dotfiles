#!/usr/bin/env bash
# Screen time daemon (Omarchy "rimuru.screentime" plugin, ported as a
# lightweight i3/polybar equivalent - no charts/history, just today's total
# and a top-apps breakdown). Subscribes to i3's own window-focus events via
# i3-msg, no extra dependency beyond i3-msg + jq (already installed).
set -euo pipefail

DATA_DIR="$HOME/.local/share/screentime"
STATE_FILE="$DATA_DIR/state"
mkdir -p "$DATA_DIR"

today_log() { echo "$DATA_DIR/$(date +%F).log"; }

last_class=""
last_epoch=$(date +%s)

i3-msg -t subscribe -m '["window"]' | while IFS= read -r line; do
  change=$(jq -r '.change' <<< "$line")
  [ "$change" != "focus" ] && continue

  class=$(jq -r '.container.window_properties.class // .container.window_properties.instance // .container.name // "unknown"' <<< "$line")
  now=$(date +%s)

  if [ -n "$last_class" ]; then
    delta=$((now - last_epoch))
    # ponytail: cap at 30min so a suspend/resume gap doesn't dump hours onto
    # whatever was focused before sleeping. Real fix: hook suspend/resume to
    # flush/reset instead of relying on this cap.
    [ "$delta" -gt 1800 ] && delta=1800
    [ "$delta" -gt 0 ] && echo "$delta $last_class" >> "$(today_log)"
  fi

  last_class="$class"
  last_epoch="$now"
  echo "$last_epoch $last_class" > "$STATE_FILE"
done
