#!/usr/bin/env bash
# html-ppt :: render.sh — headless Chrome screenshot(s)
#
# Usage:
#   render.sh <html-file>                     # one PNG, slide 1
#   render.sh <html-file> <N>                 # N PNGs, slides 1..N, via #/k
#   render.sh <html-file> all                 # autodetect .slide count
#   render.sh <html-file> <N> <out-dir>       # custom output dir
#
# Auto-detects Chrome on macOS, Linux, and Windows (Git Bash / MSYS).

set -euo pipefail

# --- Cross-platform Chrome detection ---
CHROME=""
if [[ "$(uname -s)" == MINGW* ]] || [[ "$(uname -s)" == MSYS* ]] || [[ "$(uname -s)" == CYGWIN* ]]; then
  # Windows (Git Bash / MSYS / Cygwin)
  for candidate in \
    "${LOCALAPPDATA:-}/Google/Chrome/Application/chrome.exe" \
    "${PROGRAMFILES:-}/Google/Chrome/Application/chrome.exe" \
    "/c/Program Files/Google/Chrome/Application/chrome.exe" \
    "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
  do
    if [[ -f "$candidate" ]]; then CHROME="$candidate"; break; fi
  done
elif [[ "$(uname -s)" == "Darwin" ]]; then
  # macOS
  if [[ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]]; then
    CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  fi
else
  # Linux
  for candidate in google-chrome google-chrome-stable chromium chromium-browser; do
    if command -v "$candidate" &>/dev/null; then
      CHROME="$candidate"
      break
    fi
  done
fi

if [[ -z "$CHROME" ]]; then
  echo "error: Google Chrome not found. Install Chrome or set CHROME env var." >&2
  exit 1
fi

FILE="${1:-}"
if [[ -z "$FILE" ]]; then
  echo "usage: render.sh <html> [N|all] [out-dir]" >&2
  exit 1
fi
if [[ ! -f "$FILE" ]]; then
  echo "error: $FILE not found" >&2
  exit 1
fi

COUNT="${2:-1}"
OUT="${3:-}"

ABS="$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"
STEM="$(basename "${FILE%.*}")"

if [[ "$COUNT" == "all" ]]; then
  COUNT="$(grep -c 'class="slide"' "$FILE" || true)"
  [[ -z "$COUNT" || "$COUNT" -lt 1 ]] && COUNT=1
fi

if [[ -z "$OUT" ]]; then
  if [[ "$COUNT" -gt 1 ]]; then
    OUT="$(dirname "$FILE")/${STEM}-png"
    mkdir -p "$OUT"
  fi
fi

render_one() {
  local url="$1" target="$2"
  "$CHROME" \
    --headless=new \
    --disable-gpu \
    --hide-scrollbars \
    --no-sandbox \
    --virtual-time-budget=4000 \
    --window-size=1920,1080 \
    --screenshot="$target" \
    "$url" >/dev/null 2>&1
  echo "  ✔ $target"
}

if [[ "$COUNT" == "1" ]]; then
  OUT_FILE="${OUT:-$(dirname "$FILE")/${STEM}.png}"
  render_one "file://$ABS" "$OUT_FILE"
else
  for i in $(seq 1 "$COUNT"); do
    render_one "file://$ABS#/$i" "$OUT/${STEM}_$(printf '%02d' "$i").png"
  done
fi

echo "done: rendered $COUNT slide(s) from $FILE"
