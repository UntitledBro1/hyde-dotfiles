# shared helpers, sourced by collect.sh and install.sh
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STORE="$REPO/home"

# prints "<flag> <path>" per manifest line; flag is core or machine
manifest() {
  local a b
  while read -r a b; do
    [[ -z "$a" || "$a" == \#* ]] && continue
    if [[ "$a" == machine ]]; then echo "machine $b"; else echo "core $a"; fi
  done < "$REPO/paths.txt"
}
