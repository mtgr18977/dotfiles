#!/bin/bash
# Night Light toggle for polybar, backed by redshift.
ICON_ON=""
ICON_OFF=""

case "$1" in
  toggle)
    if pgrep -x redshift >/dev/null; then
      pkill -x redshift
      redshift -x >/dev/null 2>&1
      notify-send -a "nightlight" "Night Light desativado"
    else
      if ! command -v redshift >/dev/null 2>&1; then
        notify-send -a "nightlight" "redshift nao instalado" "sudo pacman -S redshift"
        exit 1
      fi
      setsid redshift -O 4000 -P >/dev/null 2>&1 &
      notify-send -a "nightlight" "Night Light ativado"
    fi
    ;;
  status|*)
    if pgrep -x redshift >/dev/null; then
      echo "$ICON_ON"
    else
      echo "$ICON_OFF"
    fi
    ;;
esac
