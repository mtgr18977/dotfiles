#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

NVIM_CONFIG="$HOME/.config/nvim"

if [ -e "$NVIM_CONFIG" ] || [ -L "$NVIM_CONFIG" ]; then
  rel=".config/nvim"
  _ensure_backup_root
  mkdir -p "$BACKUP_ROOT/$(dirname "$rel")"
  mv "$NVIM_CONFIG" "$BACKUP_ROOT/$rel"
  warn "backed up existing $NVIM_CONFIG -> $BACKUP_ROOT/$rel"
fi

log "cloning LazyVim/starter..."
git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_CONFIG"
rm -rf "$NVIM_CONFIG/.git"

mkdir -p "$NVIM_CONFIG/lua/plugins"
cp "$DOTFILES/config/nvim/colorscheme.lua" "$NVIM_CONFIG/lua/plugins/colorscheme.lua"

log "syncing plugins headlessly (this can take a minute)..."
nvim --headless "+Lazy! sync" +qa || warn "plugin sync reported an issue - open nvim manually to check :Lazy"

log "LazyVim installed with Catppuccin Mocha colorscheme"
