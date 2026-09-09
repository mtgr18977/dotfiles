#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

link_file "$DOTFILES/config/fish/config.fish" "$HOME/.config/fish/config.fish"

if [ ! -d "$HOME/.local/share/omf" ]; then
  log "installing Oh My Fish (get.oh-my.fish can be unreachable on some networks, cloning GitHub directly instead)..."
  tmpdir="$(mktemp -d)"
  git clone --depth 1 https://github.com/oh-my-fish/oh-my-fish "$tmpdir"
  fish "$tmpdir/bin/install" --local-source="$tmpdir" --noninteractive --yes
  rm -rf "$tmpdir"
else
  log "Oh My Fish already installed"
fi

if fish -c "omf list" 2>/dev/null | grep -qw "bobthefish"; then
  log "bobthefish theme already installed"
else
  log "installing bobthefish theme..."
  fish -c "omf install bobthefish"
fi
fish -c "omf theme bobthefish"

current_shell="$(getent passwd "$USER" | cut -d: -f7)"
if [ "$current_shell" != "$(command -v fish)" ]; then
  warn "your default shell is not fish yet. Run this yourself (needs your password):"
  warn "    chsh -s $(command -v fish)"
else
  log "default shell is already fish"
fi
