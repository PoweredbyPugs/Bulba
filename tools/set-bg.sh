#!/usr/bin/env bash
# Swap the new-tab background image. Resizes to <=2048px, embeds as base64
# into src/_variables.scss, and rebuilds theme.css. Reload Bulba in Obsidian
# afterwards to see the change.
#
# Usage: ./tools/set-bg.sh <path-to-image>
#        npm run set-bg -- <path-to-image>
set -euo pipefail

if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
    echo "usage: $0 <path-to-image>" >&2
    exit 64
fi

SRC="$1"
if [ ! -f "$SRC" ]; then
    echo "error: file not found: $SRC" >&2
    exit 66
fi

# Run from the theme root regardless of where the user invoked us from.
THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$THEME_DIR"

mkdir -p assets
DEST="assets/new-tab-bg.jpg"

if ! command -v magick >/dev/null 2>&1; then
    echo "error: ImageMagick (magick) not found. Install it or convert the image manually." >&2
    exit 69
fi

echo "[1/3] resizing → $DEST"
magick "$SRC" -resize '2048x2048>' -quality 85 -strip "$DEST"

echo "[2/3] embedding into src/_variables.scss"
python3 - <<'PY'
import base64, pathlib, re
b64 = base64.b64encode(pathlib.Path('assets/new-tab-bg.jpg').read_bytes()).decode('ascii')
data_url = f'url("data:image/jpeg;base64,{b64}")'
p = pathlib.Path('src/_variables.scss')
src = p.read_text()
pattern = re.compile(r'--new-tab-bg-image: url\("data:image/jpeg;base64,[^"]+"\);')
if not pattern.search(src):
    raise SystemExit('--new-tab-bg-image declaration not found in src/_variables.scss')
src = pattern.sub(f'--new-tab-bg-image: {data_url};', src, count=1)
p.write_text(src)
size_kb = (len(b64) * 3 // 4) // 1024
print(f'      embedded ~{size_kb} KB')
PY

echo "[3/3] building theme"
npm run build --silent

echo
echo "done. Reload Bulba in Obsidian (Settings → Appearance → Themes → Manage)."
