#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

PKGS=(
  i3-wm picom rofi polybar dunst alacritty feh fish
  papirus-icon-theme ttf-jetbrains-mono-nerd ttf-cascadia-code-nerd
  brightnessctl redshift
  neovim ripgrep fd nodejs npm git lazygit
  imagemagick xclip jq playerctl xorg-xrandr
)

log "installing official repo packages (pacman -S --needed)..."
sudo pacman -S --needed "${PKGS[@]}"
