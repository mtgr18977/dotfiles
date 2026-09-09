#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

# i3lock-color replaces stock i3lock (same binary name, AUR will prompt to
# remove i3lock) - the blurlock script needs its --blur/--ring-color/etc flags.
# xautolock is what actually drives the idle-lock in ~/.i3/config's autostart.
AUR_PKGS=(i3lock-color xautolock)

log "installing AUR packages via yay (interactive - may ask to replace i3lock)..."
yay -S --needed "${AUR_PKGS[@]}"
