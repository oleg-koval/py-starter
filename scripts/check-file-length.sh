#!/usr/bin/env bash
# Enforces RULES.md 2.2 -- no source file over 300 lines.
#
# Lives in a script rather than inline in .pre-commit-config.yaml on purpose:
# an unquoted YAML scalar terminates at ": ", so an inline `echo "ERROR: ..."`
# makes the whole config unparseable and every hook silently stops running.
set -euo pipefail

MAX=300
status=0

for f in "$@"; do
  [ -f "$f" ] || continue
  lines=$(wc -l < "$f" | tr -d ' ')
  if [ "$lines" -gt "$MAX" ]; then
    echo "ERROR: $f has $lines lines (max $MAX)"
    status=1
  fi
done

exit $status
