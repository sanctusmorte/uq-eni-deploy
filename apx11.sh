#!/bin/bash
OUT=/tmp/eni-apx11-status.txt
H=$(hostname)
{
  echo "APX11 TEST host=$H date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "=== docker start ==="
  docker start 2b4a7f33730b 2>&1 | head -5
  sleep 6
  docker ps -a --format '{{.ID}} {{.Names}} {{.Status}}' 2>&1 | head -15
  echo "=== 8100 ==="
  curl -s -m 5 -o /dev/null -w "8100:%{http_code}" http://127.0.0.1:8100/ 2>&1; echo
  echo "APX11 DONE"
} > "$OUT" 2>&1
curl -s -m 15 --data-binary "@$OUT" "http://170.106.52.184:8867/eni-apx11-done?host=$H" >/dev/null 2>&1
exit 0
