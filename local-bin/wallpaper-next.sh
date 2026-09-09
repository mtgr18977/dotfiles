#!/bin/bash
# Cycles through ~/Pictures/wallpapers and applies the next one with feh.
WALL_DIR="$HOME/Pictures/wallpapers"
STATE_FILE="$HOME/.cache/wallpaper-current"
mkdir -p "$HOME/.cache"

mapfile -t WALLS < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)
[ ${#WALLS[@]} -eq 0 ] && exit 0

current=$(cat "$STATE_FILE" 2>/dev/null)
next_index=0
for i in "${!WALLS[@]}"; do
  if [ "${WALLS[$i]}" = "$current" ]; then
    next_index=$(( (i + 1) % ${#WALLS[@]} ))
    break
  fi
done

next="${WALLS[$next_index]}"
feh --bg-fill "$next"
echo "$next" > "$STATE_FILE"
notify-send -a "wallpaper" "Wallpaper alterado" "$(basename "$next")"
