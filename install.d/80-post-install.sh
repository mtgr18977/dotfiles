#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

log "install finished."

if [ -d "$BACKUP_ROOT" ]; then
  warn "existing configs were backed up to: $BACKUP_ROOT"
fi

if pgrep -x i3 >/dev/null 2>&1; then
  log "i3 is running - reload it to pick up the new config: \$mod+Shift+c (or run: i3-msg reload)"
else
  log "log into the 'i3' session at your display manager to see the rice"
fi

log "reminders:"
echo "  - if chsh to fish wasn't run automatically, do it yourself: chsh -s \$(command -v fish)"
echo "  - i3lock-color and xautolock now handle screen locking / idle auto-lock"
echo "  - polybar/launch.sh auto-detects your monitor and network interface at every launch"
