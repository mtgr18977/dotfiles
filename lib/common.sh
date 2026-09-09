#!/usr/bin/env bash
# Shared helpers for install.d/*.sh. Sourced, not executed directly.

C_RESET="\033[0m"; C_BLUE="\033[1;34m"; C_YELLOW="\033[1;33m"; C_RED="\033[1;31m"

log()  { printf "${C_BLUE}==>${C_RESET} %s\n" "$*"; }
warn() { printf "${C_YELLOW}==> WARNING:${C_RESET} %s\n" "$*"; }
err()  { printf "${C_RED}==> ERROR:${C_RESET} %s\n" "$*" >&2; }

# One backup dir per install.sh run, created lazily on first actual backup
# so a clean re-run leaves no empty directory behind.
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.rice-backup-$(date +%Y%m%d-%H%M%S)}"

_ensure_backup_root() {
  mkdir -p "$BACKUP_ROOT"
}

# link_file <source-in-repo> <destination-in-home>
# Idempotent: no-ops if dest already links to source. Backs up anything
# else (file, dir, or a symlink to something different) before linking.
link_file() {
  local src="$1" dest="$2"

  if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
    return 0
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local rel="${dest#"$HOME"/}"
    _ensure_backup_root
    mkdir -p "$BACKUP_ROOT/$(dirname "$rel")"
    mv "$dest" "$BACKUP_ROOT/$rel"
    warn "backed up existing $dest -> $BACKUP_ROOT/$rel"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  log "linked $dest -> $src"
}

# retry <attempts> <sleep-base-seconds> -- <command...>
# Retries a command with exponential-ish backoff (sleep-base * attempt).
retry() {
  local attempts="$1" base="$2"; shift 2
  [ "$1" = "--" ] && shift
  local n=1
  until "$@"; do
    if [ "$n" -ge "$attempts" ]; then
      return 1
    fi
    warn "attempt $n/$attempts failed, retrying in $((base * n))s..."
    sleep "$((base * n))"
    n=$((n + 1))
  done
}

require_arch_like() {
  if ! command -v pacman >/dev/null 2>&1; then
    err "pacman not found - this installer targets Arch/Manjaro-based systems."
    exit 1
  fi
}
