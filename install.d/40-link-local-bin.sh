#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

log "linking ~/.local/bin scripts..."
mkdir -p "$HOME/.local/bin"

for f in "$DOTFILES"/local-bin/*; do
  name="$(basename "$f")"
  chmod +x "$f"
  link_file "$f" "$HOME/.local/bin/$name"
done

log "local-bin scripts linked"
