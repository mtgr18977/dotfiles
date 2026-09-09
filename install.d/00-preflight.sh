#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

require_arch_like

if ! command -v yay >/dev/null 2>&1; then
  log "yay not found, bootstrapping it from AUR..."
  sudo pacman -S --needed --noconfirm base-devel git
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmpdir"
  (cd "$tmpdir" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
else
  log "yay already installed"
fi

check_local_bin_path() {
  local IFS=: entries local_bin_idx=-1 usr_bin_idx=-1 i=0
  read -ra entries <<< "$PATH"
  for i in "${!entries[@]}"; do
    [ "${entries[$i]}" = "$HOME/.local/bin" ] && local_bin_idx=$i
    [ "${entries[$i]}" = "/usr/bin" ] && usr_bin_idx=$i
  done

  if [ "$local_bin_idx" -eq -1 ]; then
    warn "\$HOME/.local/bin is not in your \$PATH - add it (e.g. in ~/.profile or ~/.bash_profile) so local-bin/* scripts and the blurlock override work."
  elif [ "$usr_bin_idx" -ne -1 ] && [ "$local_bin_idx" -gt "$usr_bin_idx" ]; then
    warn "\$HOME/.local/bin is in PATH but not ahead of /usr/bin - the blurlock override script won't take priority over any system blurlock. Check your shell's PATH setup."
  fi
}
check_local_bin_path

log "preflight done"
