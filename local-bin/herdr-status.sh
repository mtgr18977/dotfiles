#!/usr/bin/env bash
# Polybar port of the Omarchy "arch.herdr-status" plugin: shows the busiest
# agent state across all Herdr panes (blocked > done > working > idle),
# using the herdr CLI directly instead of talking to herdr.sock ourselves.
set -euo pipefail

command -v herdr >/dev/null 2>&1 || { echo ""; exit 0; }

agents_json=$(herdr agent list 2>/dev/null) || { echo ""; exit 0; }
agents=$(jq -c '.result.agents // []' <<< "$agents_json" 2>/dev/null) || agents="[]"

case "${1:-bar}" in
  top)
    summary=$(jq -r '.[] | "\(.agent_status)\t\(.terminal_title_stripped // .agent)"' <<< "$agents" 2>/dev/null)
    if [ -z "$summary" ]; then
      notify-send -a "herdr" "Agentes Herdr" "Nenhum agente ativo"
    else
      notify-send -a "herdr" "Agentes Herdr" "$summary"
    fi
    ;;
  *)
    count=$(jq 'length' <<< "$agents" 2>/dev/null || echo 0)
    if [ "$count" -eq 0 ]; then
      echo ""
      exit 0
    fi
statuses=$(jq -r '.[].agent_status' <<< "$agents")
if grep -qE '^(blocked|attention|error)$' <<< "$statuses"; then
  icon=""; color="#f38ba8"
elif grep -q '^done$' <<< "$statuses"; then
  icon=""; color="#a6e3a1"
elif grep -qE '^(working|busy|active)$' <<< "$statuses"; then
  icon=""; color="#cba6f7"
else
  icon=""; color="#a6adc8"
fi
echo "%{F$color}$icon $count%{F-}"
    ;;
esac
