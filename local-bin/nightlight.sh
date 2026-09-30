#!/bin/bash
# Night Light toggle for polybar, backed by redshift.
#
# redshift -O (one-shot manual mode) applies the color temp and exits
# immediately - it never stays resident. So state can't be tracked via
# `pgrep redshift` (it's always "not running" a moment later); use a state
# file instead.
ICON_ON=""
ICON_OFF=""
STATE_FILE="$HOME/.cache/nightlight-state"

is_on() {
  [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "on" ]
}

case "$1" in
  toggle)
    if is_on; then
      redshift -x >/dev/null 2>&1
      echo "off" > "$STATE_FILE"
      notify-send -a "nightlight" "Night Light desativado"
    else
      if ! command -v redshift >/dev/null 2>&1; then
        notify-send -a "nightlight" "redshift nao instalado" "sudo pacman -S redshift"
        exit 1
      fi
      redshift -O 4000 -P >/dev/null 2>&1
      echo "on" > "$STATE_FILE"
      notify-send -a "nightlight" "Night Light ativado"
    fi
    ;;
  status|*)
    if is_on; then
      echo "$ICON_ON"
    else
      echo "$ICON_OFF"
    fi
    ;;
esac
