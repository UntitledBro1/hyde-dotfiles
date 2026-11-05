#!/usr/bin/env bash
# Install these dots on top of a working HyDE install.
# Usage: ./install.sh [--yes] [--dry-run] [--with-machine]
set -euo pipefail
source "$(dirname "$0")/lib.sh"

YES=0; DRY=0; WITH_MACHINE=0
for a in "$@"; do
  case "$a" in
    --yes) YES=1 ;;
    --dry-run) DRY=1 ;;
    --with-machine) WITH_MACHINE=1 ;;
    *) echo "Unknown option: $a"; exit 1 ;;
  esac
done

# HyDE must already be installed
if ! command -v hyde-shell >/dev/null 2>&1 && [[ ! -d "$HOME/.config/hyde" ]]; then
  echo "HyDE doesn't look installed (no hyde-shell, no ~/.config/hyde). Install HyDE first:"
  echo "  git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE && cd ~/HyDE/Scripts && ./install.sh"
  exit 1
fi

# Work out what we'd touch
items=()
while read -r flag path; do
  [[ "$flag" == machine && $WITH_MACHINE -eq 0 ]] && continue
  [[ -e "$STORE/$path" ]] && items+=("$path")
done < <(manifest)

if [[ ${#items[@]} -eq 0 ]]; then
  echo "Nothing to install. Run ./collect.sh first, or check that ./home exists."
  exit 1
fi

BACKUP="$HOME/.config/hyde-dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
echo "This will install:"
for p in "${items[@]}"; do
  if [[ -e "$HOME/$p" ]]; then echo "  ~ $p   (exists, will be backed up)"; else echo "  + $p"; fi
done
echo
echo "Backups go to: $BACKUP"
[[ $WITH_MACHINE -eq 0 ]] && echo "Skipping monitors.conf / nvidia.conf (machine specific). Use --with-machine to include them."
echo

if [[ $DRY -eq 1 ]]; then echo "Dry run, nothing changed."; exit 0; fi
if [[ $YES -eq 0 ]]; then
  read -r -p "Continue? [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]] || { echo "Cancelled."; exit 0; }
fi

for p in "${items[@]}"; do
  if [[ -e "$HOME/$p" ]]; then
    mkdir -p "$BACKUP/$(dirname "$p")"
    cp -a "$HOME/$p" "$BACKUP/$p"
  fi
  mkdir -p "$(dirname "$HOME/$p")"
  if [[ -d "$STORE/$p" ]]; then
    mkdir -p "$HOME/$p"
    cp -a "$STORE/$p/." "$HOME/$p/"
  else
    cp -a "$STORE/$p" "$HOME/$p"
  fi
done

echo "Installed ${#items[@]} item(s). Backup: $BACKUP"
echo "Reloading..."
hyde-shell reload >/dev/null 2>&1 || true
hyprctl reload >/dev/null 2>&1 || true
echo "Done. If anything looks off, log out and back in."

# Restore the saved Waybar layout
command -v hyde-shell >/dev/null && hyde-shell waybar --set 07 || true
