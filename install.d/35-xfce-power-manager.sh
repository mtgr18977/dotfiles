#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

# xfce4-power-manager tries to lock the screen itself before suspend/hibernate,
# using its own hardcoded list of known lockers (xflock4, light-locker, etc).
# It doesn't recognize our custom blurlock/i3lock-color setup, so it pops
# "None of the screen lock tools ran successfully" - even though blurlock
# (via i3exit, see local-bin/i3exit) already locked the screen correctly on
# its own. Disable xfpm's redundant attempt to avoid the error dialog.
if command -v xfconf-query >/dev/null 2>&1; then
  xfconf-query -c xfce4-power-manager \
    -p /xfce4-power-manager/lock-screen-suspend-hibernate \
    -s false -t bool --create
  log "disabled xfce4-power-manager's own (broken) lock-on-suspend"
else
  warn "xfconf-query not found, skipping xfce4-power-manager tweak"
fi
