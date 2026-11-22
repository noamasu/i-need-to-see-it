#!/usr/bin/env bash
# Where the generated files live: one folder, the pool, chosen by the user on first use.
#
#   pool.sh               print the pool: $EXPLAINER_POOL, else the saved choice; nothing and exit 1 when none
#   pool.sh set <path>    save the choice and create the pool with its README
#
# The choice is kept in ${XDG_CONFIG_HOME:-~/.config}/i-need-to-see-it/pool.
set -euo pipefail

conf="${XDG_CONFIG_HOME:-$HOME/.config}/i-need-to-see-it/pool"

case ${1:-} in
  set)
    pool=$(realpath -m "${2/#\~/$HOME}")
    mkdir -p "$pool/visual" "$pool/stories" "$(dirname "$conf")"
    printf '%s\n' "$pool" > "$conf"
    [ -f "$pool/README.md" ] || printf '# Explainers\n\n## Visual explainers\n\n## Stories\n' > "$pool/README.md"
    echo "$pool"
    ;;
  "")
    pool=${EXPLAINER_POOL:-$(cat "$conf" 2>/dev/null || true)}
    [ -n "$pool" ] || exit 1
    echo "$pool"
    ;;
  *)
    sed -n '2,7p' "$0"; exit 2
    ;;
esac
