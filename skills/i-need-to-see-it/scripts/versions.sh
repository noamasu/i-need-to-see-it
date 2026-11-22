#!/usr/bin/env bash
# Which releases a page applies to. Prints version tags (vX.Y…) only.
#
#   versions.sh <repo> contains <sha>              releases that contain the commit (first 5)
#   versions.sh <repo> since <ref> <path>          first release with the file (its adding commit)
#   versions.sh <repo> since <ref> <path> <text>   first release where <text> appears in the file
#   versions.sh <repo> latest                      latest final release tags (last 5)
#
# No tag printed means the commit is not in a release yet (new work on a branch).
set -euo pipefail

repo=$1
what=$2
tags() { git -C "$repo" tag --contains "$1" | grep -E '^v?[0-9]+\.[0-9]+' | sort -V; }

case $what in
  contains)
    tags "$3" | head -5
    ;;
  since)
    ref=$3 path=$4 text=${5:-}
    if [ -n "$text" ]; then
      commit=$(git -C "$repo" log "$ref" -S"$text" --format=%H --reverse -- "$path" | head -1)
    else
      commit=$(git -C "$repo" log "$ref" --diff-filter=A --format=%H -- "$path" | tail -1)
    fi
    [ -n "$commit" ] || { echo "not found under $ref" >&2; exit 1; }
    echo "introduced in ${commit:0:10}"
    tags "$commit" | head -3
    ;;
  latest)
    git -C "$repo" tag | grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -5
    ;;
  *)
    sed -n '2,8p' "$0"; exit 2
    ;;
esac
