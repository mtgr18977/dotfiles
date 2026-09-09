#!/bin/bash
# Omarchy-style rofi power menu.

options="   Lock\n   Suspend\n   Logout\n   Reboot\n   Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "" -theme ~/.config/rofi/themes/powermenu.rasi)

case "$chosen" in
  *Lock*) blurlock ;;
  *Suspend*) blurlock && systemctl suspend ;;
  *Logout*) i3-msg exit ;;
  *Reboot*) systemctl reboot ;;
  *Shutdown*) systemctl poweroff ;;
esac
