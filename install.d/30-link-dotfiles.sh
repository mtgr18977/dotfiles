#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$DOTFILES/lib/common.sh"

log "linking dotfiles..."

# NOTE: i3's config lives at the legacy ~/.i3/config path on this setup
# (Manjaro i3 edition default), not ~/.config/i3/config.
link_file "$DOTFILES/config/i3/config"                       "$HOME/.i3/config"
link_file "$DOTFILES/config/picom/picom.conf"                 "$HOME/.config/picom/picom.conf"
link_file "$DOTFILES/config/rofi/config.rasi"                 "$HOME/.config/rofi/config.rasi"
link_file "$DOTFILES/config/rofi/themes/catppuccin-mocha.rasi" "$HOME/.config/rofi/themes/catppuccin-mocha.rasi"
link_file "$DOTFILES/config/rofi/themes/powermenu.rasi"        "$HOME/.config/rofi/themes/powermenu.rasi"
link_file "$DOTFILES/config/polybar/config.ini"                "$HOME/.config/polybar/config.ini"
link_file "$DOTFILES/config/polybar/launch.sh"                 "$HOME/.config/polybar/launch.sh"
link_file "$DOTFILES/config/dunst/dunstrc"                     "$HOME/.config/dunst/dunstrc"
link_file "$DOTFILES/config/alacritty/alacritty.toml"          "$HOME/.config/alacritty/alacritty.toml"
link_file "$DOTFILES/config/fish/config.fish"                  "$HOME/.config/fish/config.fish"

chmod +x "$HOME/.config/polybar/launch.sh"

log "dotfiles linked"
