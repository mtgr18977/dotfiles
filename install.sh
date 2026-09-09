#!/usr/bin/env bash
# Installs the Catppuccin Mocha i3 rice (i3 + polybar + rofi + picom + dunst
# + alacritty + fish/omf + LazyVim). Safe to re-run: existing configs are
# backed up (once per run) to ~/.rice-backup-<timestamp>/ before being
# replaced with symlinks into this repo.
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
# Computed once here and exported so every install.d/*.sh subshell shares
# the same backup directory for this run instead of each creating its own.
export BACKUP_ROOT="$HOME/.rice-backup-$(date +%Y%m%d-%H%M%S)"
source "$DOTFILES/lib/common.sh"

require_arch_like

for step in "$DOTFILES"/install.d/*.sh; do
  log "running $(basename "$step")"
  bash "$step"
done

log "done."
