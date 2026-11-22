#!/usr/bin/env bash
# Screenshot an explainer page the way the Artifact publisher serves it:
# the page fragment wrapped in a document skeleton, opened at a view/step hash.
#
#   shoot.sh <page.html> [view[/step]] [out.png]
#   SIZE=390,1800 shoot.sh ...   phone width (default 1440,1000)
#   DARK=1 shoot.sh ...          with the page's dark mode on
#   CHROME=/path/to/chrome       when Chrome or Chromium is not on PATH
#
# Examples: shoot.sh page.html after/3   shoot.sh page.html compare cmp.png
set -euo pipefail

page=$(realpath "$1")
hash=${2:-}
hash=${hash#\#}
out=${3:-${page%.html}${hash:+-${hash//\//-}}.png}
out=$(realpath -m "$out")
wrap="$(dirname "$out")/.shoot-$$-$(basename "$page")"
trap 'rm -f "$wrap"' EXIT

if head -c 200 "$page" | grep -qi '<!doctype'; then
  cp "$page" "$wrap"
else
  {
    printf '<!doctype html><html><head><meta charset=utf8><meta name=viewport content="width=device-width,initial-scale=1,viewport-fit=cover"><style>:root{color-scheme:light;box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}html{scroll-padding-top:env(safe-area-inset-top,0px)}body{margin:0;padding:0;font:14px -apple-system,BlinkMacSystemFont,sans-serif;background:#fff;color:#000}img{max-width:100%%}[hidden]:not([hidden=until-found i]){display:none!important}</style></head><body>\n'
    cat "$page"
    printf '</body></html>\n'
  } > "$wrap"
fi

if [ -n "${DARK:-}" ]; then sed -i 's/let dark = false/let dark = true/' "$wrap"; fi

chrome=${CHROME:-$(command -v google-chrome || command -v google-chrome-stable || command -v chromium || command -v chromium-browser || true)}
[ -n "$chrome" ] || { echo "shoot.sh: no Chrome or Chromium found; set CHROME=<path>" >&2; exit 127; }
timeout 60 "$chrome" --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
  --window-size="${SIZE:-1440,1000}" --virtual-time-budget=6000 \
  --screenshot="$out" "file://$wrap${hash:+#$hash}" >/dev/null 2>&1
echo "$out"
