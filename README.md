# i3 rice — Catppuccin Mocha (Omarchy-inspired)

Reproducible install for a hand-tuned i3 setup styled after
[Omarchy](https://omarchy.org/): i3 + polybar + rofi + picom + dunst +
alacritty + fish/oh-my-fish + LazyVim, all in Catppuccin Mocha.

Targets Arch/Manjaro-based systems.

## What it installs

- **i3** window manager config (`~/.i3/config`) — Mod4, JetBrainsMono Nerd Font,
  alacritty as terminal, rofi as launcher (`$mod+d` / `$mod+space`), a rofi
  power menu (`$mod+Escape`), wallpaper cycling (`$mod+Shift+w`), i3-gaps.
- **polybar** — flat, full-width top bar (no i3bar/i3status), workspaces,
  clock, weather, CPU/RAM, night light toggle, volume, network, tray. Monitor
  and network interface are auto-detected at every launch.
- **rofi** — Catppuccin Mocha spotlight-style launcher theme + a small power
  menu theme.
- **picom** — glx backend, blur, rounded corners, shadows.
- **dunst** — Catppuccin Mocha notification theme.
- **alacritty** — Catppuccin Mocha terminal theme.
- **A themed lock screen** (`~/.local/bin/blurlock`) using `i3lock-color`'s
  native blur, shadowing any system `blurlock`/`i3lock` via `$PATH`.
- **fish + oh-my-fish** with the `bobthefish` theme.
- **LazyVim** (cloned fresh from the official starter each run) themed with
  `catppuccin/nvim` (mocha flavour).
- 8 Catppuccin Mocha wallpapers, fetched from
  [orangci/walls-catppuccin-mocha](https://github.com/orangci/walls-catppuccin-mocha).

## Prerequisites

- Arch or an Arch-based distro (Manjaro, etc.) with `pacman`.
- `sudo` access. `yay` will be bootstrapped automatically if missing.

## Usage

```sh
git clone https://github.com/mtgr18977/dotfiles ~/i3-rice-dotfiles
cd ~/i3-rice-dotfiles
./install.sh
```

Safe to re-run. Existing configs are backed up (once per run, only if
something is actually about to be overwritten) to `~/.rice-backup-<timestamp>/`
before being replaced with symlinks into this repo — so editing anything
under `config/` or `local-bin/` and re-running `install.sh`, or just doing a
`git pull`, is enough to update the live setup (everything is symlinked, not
copied), except for the neovim config which is regenerated fresh each run.

## Things the script will ask you to do yourself

- Enter your `sudo` password (pacman/yay installs).
- Confirm the AUR build/replacement of `i3lock` with `i3lock-color` (`yay`
  prompt).
- `chsh -s $(command -v fish)` if fish isn't already your default shell — the
  script detects this and prints the exact command instead of running it for
  you, since changing your login shell needs your password and is worth a
  deliberate decision.

## Notes

- `~/.i3/config` is the **legacy** i3 config path (`~/.i3/config`, not
  `~/.config/i3/config`) — that's what Manjaro's i3 edition uses by default,
  and this repo follows suit.
- `polybar/launch.sh` re-detects the primary monitor and default network
  interface every time it starts polybar, so moving this to a different
  machine (or a different GPU/driver) doesn't need any manual edit to
  `polybar/config.ini`.
- Wallpapers and the LazyVim config are fetched from upstream at install time
  rather than vendored in this repo, to keep it small and always current.
