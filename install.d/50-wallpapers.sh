#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

log "fetching wallpapers..."
bash "$DOTFILES/wallpapers/fetch-wallpapers.sh"

DEFAULT_WALLPAPER="$HOME/Pictures/wallpapers/cat-mountain-range.jpg"
if [ -f "$DEFAULT_WALLPAPER" ] && command -v feh >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  feh --bg-fill "$DEFAULT_WALLPAPER" || true
fi

log "wallpapers ready"
