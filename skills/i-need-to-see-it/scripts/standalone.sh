#!/usr/bin/env bash
# Turn a page fragment (what the Artifact tool publishes) into a standalone HTML file
# that opens from disk, with the one rule the Artifact host otherwise supplies.
#
#   standalone.sh <page.html> <out.html>
#
# A page that already starts with <!doctype is copied as is.
set -euo pipefail

page=$1
out=$2
mkdir -p "$(dirname "$out")"

if head -c 200 "$page" | grep -qi '<!doctype'; then
  cp "$page" "$out"
  echo "$out"
  exit 0
fi

{
  printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n<style>[hidden] { display: none !important; }</style>\n'
  sed -n '1,/^<\/style>$/p' "$page"
  printf '</head>\n<body>\n'
  sed '1,/^<\/style>$/d' "$page"
  printf '</body>\n</html>\n'
} > "$out"
echo "$out"
