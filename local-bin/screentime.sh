#!/usr/bin/env bash
# Reads what screentime-tracker.sh logged today. `screentime.sh` alone
# prints the bar label; `screentime.sh top` notifies the top-5 apps.
set -euo pipefail

DATA_DIR="$HOME/.local/share/screentime"
LOG="$DATA_DIR/$(date +%F).log"
STATE_FILE="$DATA_DIR/state"

total=0
[ -f "$LOG" ] && total=$(awk '{s+=$1} END {print s+0}' "$LOG")

# Add the live delta for whatever's focused right now (same cap as the
# tracker, see screentime-tracker.sh).
if [ -f "$STATE_FILE" ]; then
  read -r last_epoch _ < "$STATE_FILE"
  now=$(date +%s)
  delta=$((now - last_epoch))
  [ "$delta" -gt 1800 ] && delta=1800
  [ "$delta" -gt 0 ] && total=$((total + delta))
fi

case "${1:-bar}" in
  top)
    if [ -f "$LOG" ]; then
      summary=$(awk '{sum[$2]+=$1} END {for (c in sum) printf "%s\t%dm\n", c, sum[c]/60}' "$LOG" | sort -t$'\t' -k2 -rn | head -5)
      notify-send -a "screentime" "Tempo de tela hoje" "$summary"
    else
      notify-send -a "screentime" "Tempo de tela hoje" "Sem dados ainda"
    fi
    ;;
  *)
    printf '%dh%02dm\n' "$((total / 3600))" "$(((total % 3600) / 60))"
    ;;
esac
