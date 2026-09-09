#!/bin/bash
# Weather for the polybar bar - auto-detects location via IP (wttr.in).
OUT=$(curl -s --max-time 5 'wttr.in/?format=%t' 2>/dev/null | sed 's/+//')
if [ -z "$OUT" ]; then
  echo "N/D"
else
  echo "$OUT"
fi
