#!/usr/bin/env bash
# Snapshot your live HyDE setup into ./home so you can commit it.
# Usage: ./collect.sh [--with-machine]
set -euo pipefail
source "$(dirname "$0")/lib.sh"

WITH_MACHINE=0
[[ "${1:-}" == "--with-machine" ]] && WITH_MACHINE=1

count=0
while read -r flag path; do
  [[ "$flag" == machine && $WITH_MACHINE -eq 0 ]] && continue
  src="$HOME/$path"; dest="$STORE/$path"
  [[ -e "$src" ]] || continue
  rm -rf "$dest"
  mkdir -p "$(dirname "$dest")"
  cp -a "$src" "$dest"
  echo "  + $path"
  count=$((count + 1))
done < <(manifest)
echo "Collected $count item(s) into $STORE"

echo
echo "Scanning for things that look like secrets..."
if grep -rIniE '(api[_-]?key|secret|token|passw(or)?d|bearer)[[:space:]]*[=:]' "$STORE" 2>/dev/null | head -20; then
  echo
  echo "^ Review these before you push. Remove the lines or the path from paths.txt."
else
  echo "Nothing obvious found. Still skim 'git diff' before pushing."
fi
