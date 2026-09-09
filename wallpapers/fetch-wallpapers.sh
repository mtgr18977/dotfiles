#!/usr/bin/env bash
# Downloads the Catppuccin Mocha wallpapers used by this rice from
# orangci/walls-catppuccin-mocha. Not vendored in the repo on purpose -
# keeps it lightweight. Safe to re-run (skips files already present and
# large enough).
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

DEST="$HOME/Pictures/wallpapers"
mkdir -p "$DEST"

RAW_BASE="https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/master"
JSDELIVR_BASE="https://cdn.jsdelivr.net/gh/orangci/walls-catppuccin-mocha@master"
MIN_SIZE=10240 # 10KB - catches rate-limited CDN responses that save an HTML error page

FILES=(
  cat-minimalist-black-hole.png
  cat-misty-boat.jpg
  cat-moon-beach.png
  cat-mountain-range.jpg
  cat-night-forest-path.png
  cat-purpled-night.jpg
  cat-purple-horizon.jpg
  cat-space.png
)

file_ok() {
  local path="$1"
  [ -f "$path" ] && [ "$(stat -c%s "$path" 2>/dev/null || echo 0)" -gt "$MIN_SIZE" ]
}

download_one() {
  local name="$1" dest="$2" upstream_name="${1#cat-}"
  if retry 3 2 -- curl -sL --max-time 20 -o "$dest" "$RAW_BASE/$upstream_name"; then
    file_ok "$dest" && return 0
  fi
  warn "raw.githubusercontent.com failed for $name, trying jsdelivr mirror..."
  curl -sL --max-time 20 -o "$dest" "$JSDELIVR_BASE/$upstream_name" || true
  file_ok "$dest"
}

for name in "${FILES[@]}"; do
  dest="$DEST/$name"
  if file_ok "$dest"; then
    log "$name already present, skipping"
    continue
  fi
  log "downloading $name..."
  if download_one "$name" "$dest"; then
    log "$name OK"
  else
    warn "could not download $name after all retries/mirrors - skipping, continuing with the rest"
  fi
done
