#!/usr/bin/env bash
# Builds Bookshelf theme packs into $OUT. Usage: build_packs.sh <art_dir> <out_dir>
set -euo pipefail
ART=$1; OUT=$2; W=1072; H=1448
rm -rf "$OUT"; mkdir -p "$OUT"
T=$(mktemp -d)

# plank <dir> <Name> <surface> <edge> <front> <shadow_alpha>
# Same geometry as the built-in oak: 960x360 middle, surface y120-213,
# edge line 213-215, front 216-237, shadow below; 220x360 ends.
plank() {
  local d=$1/theme n=$2 s=$3 e=$4 f=$5 a=$6
  mkdir -p "$d"
  magick -size 960x360 xc:none \
    -fill "$s" -draw "rectangle 0,120 959,212" \
    -fill "$e" -draw "rectangle 0,213 959,215" \
    -fill "$f" -draw "rectangle 0,216 959,237" \
    \( -size 960x52 gradient:"rgba(0,0,0,$a)-rgba(0,0,0,0)" \) -geometry +0+238 -composite \
    "$d/plank.$n.middle.png"
  endpiece "$d/plank.$n.middle.png" "$d/plank.$n.left.png"
  magick "$d/plank.$n.left.png" -flop "$d/plank.$n.right.png"
}
# The hairline: a thin rule where the shelf's edge is, nothing else.
hairline() {
  local d=$1/theme n=$2 c=$3
  mkdir -p "$d"
  magick -size 960x360 xc:none -fill "$c" -draw "rectangle 0,211 959,215" "$d/plank.$n.middle.png"
  endpiece "$d/plank.$n.middle.png" "$d/plank.$n.left.png"
  magick "$d/plank.$n.left.png" -flop "$d/plank.$n.right.png"
}
# Left end from the middle: clear before x=70, rounded corner, fading out
# over x=120..210 so it blends into the middle like the oak's does.
endpiece() {
  magick -size 220x360 xc:black -fill white \
    -draw "roundrectangle 70,120 400,237 8,8" -draw "rectangle 74,238 400,300" "$T/shape.png"
  magick -size 220x360 xc: -fx "i<120?1:(i>210?0:(210-i)/90)" "$T/fade.png"
  magick "$T/shape.png" "$T/fade.png" -compose multiply -composite "$T/mask.png"
  magick "$1" -crop 220x360+0+0 +repage "$T/crop.png"
  magick "$T/crop.png" \( "$T/crop.png" -alpha extract "$T/mask.png" -compose multiply -composite \) \
    -alpha off -compose CopyOpacity -composite "$2"
}
solid_wall() { mkdir -p "$1/theme"; magick -size ${W}x${H} xc:"$2" -colorspace gray "$1/theme/wallpaper.png"; }
# A print faded to a pale wash, so covers and text stay readable over it.
faded_wall() {
  mkdir -p "$1/theme"
  magick "$2" -colorspace gray -resize ${W}x${H}^ -gravity center -extent ${W}x${H} \
    -auto-level +level "$3",100% "$1/theme/wallpaper.png"
}
# A print in a white mat and a dark frame, standing on the shelf.
framed() {
  magick "$2" -colorspace gray -resize x520 -auto-level \
    -bordercolor white -border 34 -bordercolor "#222222" -border 16 "$1/$3.png"
}
json() { printf '%s\n' "$2" > "$1"; }

# ── Smooth planks: planks only, so they show in Theme > Plank, not as a theme
P="$OUT/Smooth planks"
hairline "$P" Hairline "#222222"
plank "$P" Paper    "#F4F4F4" "#FFFFFF" "#D2D2D2" 0.18
plank "$P" Graphite "#5C5C5C" "#8A8A8A" "#3A3A3A" 0.30
plank "$P" Ink      "#1C1C1C" "#4A4A4A" "#000000" 0.35

# ── Minimal
P="$OUT/Minimal"
hairline "$P" Hairline "#222222"; solid_wall "$P" "#FFFFFF"
json "$P/theme/theme.json" '{"name": "Minimal", "description": "White page, a hairline shelf, nothing else.", "shelf": "light", "plank": "Hairline"}'
json "$P/theme/colours.json" '{
  "day":   {"page": "#FFFFFF", "text": "#111111", "panel": "#FFFFFF", "panel text": "#111111", "menu bar": "#FFFFFF",
            "cover border": "#222222", "cover shadow": "#FFFFFF", "progress bar": "#222222", "progress track": "#DDDDDD",
            "selected shelf": "#111111", "selected shelf text": "#FFFFFF", "plank": "#222222"},
  "night": {"page": "#000000", "text": "#EEEEEE", "panel": "#000000", "panel text": "#EEEEEE", "menu bar": "#000000",
            "cover border": "#DDDDDD", "cover shadow": "#000000", "progress bar": "#DDDDDD", "progress track": "#333333",
            "selected shelf": "#EEEEEE", "selected shelf text": "#000000", "plank": "#DDDDDD"}}'

# ── Minimal Grey
P="$OUT/Minimal Grey"
plank "$P" Graphite "#5C5C5C" "#8A8A8A" "#3A3A3A" 0.25; solid_wall "$P" "#EEEEEE"
json "$P/theme/theme.json" '{"name": "Minimal Grey", "description": "Soft grey page on a smooth graphite shelf.", "shelf": "light", "plank": "Graphite"}'
json "$P/theme/colours.json" '{
  "day":   {"page": "#EEEEEE", "text": "#1A1A1A", "panel": "#F7F7F7", "panel text": "#1A1A1A", "menu bar": "#EEEEEE",
            "cover border": "#444444", "cover shadow": "#BBBBBB", "progress bar": "#333333", "progress track": "#CCCCCC",
            "selected shelf": "#444444", "selected shelf text": "#FFFFFF", "plank": "#5C5C5C"},
  "night": {"page": "#111111", "text": "#E6E6E6", "panel": "#1E1E1E", "panel text": "#E6E6E6", "menu bar": "#111111",
            "cover border": "#AAAAAA", "cover shadow": "#000000", "progress bar": "#CCCCCC", "progress track": "#444444",
            "selected shelf": "#CCCCCC", "selected shelf text": "#111111", "plank": "#5C5C5C"}}'

# ── Botanical: Cleveland Museum of Art, CC0
P="$OUT/Botanical"
plank "$P" Paper "#F4F4F4" "#FFFFFF" "#D2D2D2" 0.18
faded_wall "$P" "$ART/1993.45_print.jpg" 86%
framed "$P" "$ART/1993.45_print.jpg"  "Fern"
framed "$P" "$ART/2020.164_print.jpg" "Turban lily"
framed "$P" "$ART/1955.142_print.jpg" "Cape lily"
framed "$P" "$ART/1955.144_print.jpg" "Flowering rush"
json "$P/theme/theme.json" '{"name": "Botanical", "description": "Framed 19th-century plant prints on a pale fern wallpaper. Public domain, Cleveland Museum of Art.", "shelf": "light", "plank": "Paper", "hero": "Fern"}'
json "$P/theme/colours.json" '{
  "day":   {"page": "#F4F2EC", "text": "#1F2A1F", "panel": "#FAF8F2", "panel text": "#1F2A1F", "menu bar": "#F4F2EC",
            "progress bar": "#2F4A33", "progress track": "#D6D9CF", "selected shelf": "#2F4A33", "selected shelf text": "#FFFFFF", "plank": "#E8E8E8"},
  "night": {"page": "#0E120E", "text": "#E4E8E0", "panel": "#161B16", "panel text": "#E4E8E0", "menu bar": "#0E120E",
            "progress bar": "#C9D6C4", "progress track": "#333B33", "selected shelf": "#C9D6C4", "selected shelf text": "#0E120E", "plank": "#E8E8E8"}}'

# ── Library: Canaletto's The Library, Venice (CC0) and drawn curiosities
P="$OUT/Library"
plank "$P" Ink "#1C1C1C" "#4A4A4A" "#000000" 0.35
faded_wall "$P" "$ART/1925.1239.15_print.jpg" 84%
cat > "$P/Candle.svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!-- bookshelf:overhang=0 -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 40 106">
  <path d="M20 14 C26 22 25 30 20 32 C15 30 14 22 20 14 Z" fill="#d8d8d8" stroke="#222" stroke-width="1.2"/>
  <rect x="19.3" y="31" width="1.4" height="5" fill="#222"/>
  <rect x="14" y="36" width="12" height="44" rx="1.5" fill="#f2f2f2" stroke="#222" stroke-width="1.2"/>
  <path d="M6 86 A14 3 0 0 0 34 86 L30 80 H10 Z" fill="#6a6a6a" stroke="#222" stroke-width="1.2" stroke-linejoin="round"/>
  <path d="M10 80 H30 V82 H10 Z" fill="#8a8a8a" stroke="#222" stroke-width="1"/>
  <rect x="17" y="86" width="6" height="8" fill="#6a6a6a" stroke="#222" stroke-width="1.2"/>
  <ellipse cx="20" cy="97" rx="12" ry="3" fill="#4a4a4a" stroke="#222" stroke-width="1.2"/>
</svg>
EOF
cat > "$P/Globe.svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!-- bookshelf:overhang=0 -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 70 106">
  <circle cx="35" cy="44" r="26" fill="#cfcfcf" stroke="#222" stroke-width="1.4"/>
  <path d="M22 30 C28 26 34 32 30 38 C26 44 32 48 28 54 C22 56 16 48 18 40 Z" fill="#6a6a6a" stroke="#222" stroke-width="1"/>
  <path d="M40 24 C48 22 56 30 54 38 C50 42 44 38 42 44 C40 50 46 56 42 62 C36 60 38 50 36 44 C34 36 36 28 40 24 Z" fill="#6a6a6a" stroke="#222" stroke-width="1"/>
  <path d="M35 18 A26 26 0 0 1 35 70" fill="none" stroke="#3a3a3a" stroke-width="3"/>
  <path d="M35 14 A30 30 0 0 1 35 74" fill="none" stroke="#3a3a3a" stroke-width="2.5"/>
  <rect x="32" y="74" width="6" height="14" fill="#4a4a4a" stroke="#222" stroke-width="1.2"/>
  <ellipse cx="35" cy="96" rx="16" ry="3.4" fill="#4a4a4a" stroke="#222" stroke-width="1.2"/>
  <path d="M22 96 L26 88 H44 L48 96 Z" fill="#5a5a5a" stroke="#222" stroke-width="1.2" stroke-linejoin="round"/>
</svg>
EOF
cat > "$P/Hourglass.svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!-- bookshelf:overhang=0 -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 44 106">
  <rect x="6" y="20" width="32" height="6" rx="1.5" fill="#3a3a3a" stroke="#222" stroke-width="1.2"/>
  <rect x="6" y="88" width="32" height="6" rx="1.5" fill="#3a3a3a" stroke="#222" stroke-width="1.2"/>
  <path d="M11 26 C11 44 20 50 20 57 C20 64 11 70 11 88 H33 C33 70 24 64 24 57 C24 50 33 44 33 26 Z" fill="#efefef" stroke="#222" stroke-width="1.2"/>
  <path d="M15 34 H29 C28 44 23 48 22 54 C21 48 16 44 15 34 Z" fill="#8a8a8a"/>
  <path d="M22 58 V80 M13 88 C16 80 28 80 31 88 Z" fill="#8a8a8a" stroke="#8a8a8a" stroke-width="1"/>
  <rect x="7" y="26" width="3" height="62" fill="#4a4a4a"/>
  <rect x="34" y="26" width="3" height="62" fill="#4a4a4a"/>
</svg>
EOF
json "$P/theme/theme.json" '{"name": "Library", "description": "Canaletto'\''s Library in Venice behind an ink-black shelf, with a candle, a globe and an hourglass.", "shelf": "light", "plank": "Ink", "hero": "Globe"}'
json "$P/theme/colours.json" '{
  "day":   {"page": "#EDE6DA", "text": "#1A1410", "panel": "#F6F1E8", "panel text": "#1A1410", "menu bar": "#EDE6DA",
            "progress bar": "#2A211A", "progress track": "#D3CBBE", "selected shelf": "#2A211A", "selected shelf text": "#FFFFFF", "plank": "#1C1C1C"},
  "night": {"page": "#14110D", "text": "#EAE3D6", "panel": "#1E1A15", "panel text": "#EAE3D6", "menu bar": "#14110D",
            "progress bar": "#D9CFBF", "progress track": "#3A342C", "selected shelf": "#D9CFBF", "selected shelf text": "#14110D", "plank": "#1C1C1C"}}'

# ── Night Sky: generated star field, drawn moon and telescope
P="$OUT/Night Sky"
plank "$P" Graphite "#5C5C5C" "#8A8A8A" "#3A3A3A" 0.30
mkdir -p "$P/theme"
magick -size ${W}x${H} xc:"#0d1014" -colorspace gray \
  \( -size ${W}x${H} xc: -seed 7 +noise Random -channel G -separate +channel -threshold 99.75% -blur 0x0.7 -level 0,60% \) \
  -compose screen -composite \
  \( -size ${W}x${H} xc: -seed 11 +noise Random -channel R -separate +channel -threshold 99.97% -morphology dilate disk:1.5 -blur 0x1 \) \
  -compose screen -composite "$P/theme/wallpaper.png"
cat > "$P/Moon.svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!-- bookshelf:overhang=0 -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 106">
  <path d="M38 12 A27 27 0 1 0 38 66 A34 34 0 0 1 38 12 Z" fill="#d6d6d6" stroke="#222" stroke-width="1.4"/>
  <circle cx="22" cy="30" r="3" fill="#a8a8a8"/><circle cx="18" cy="46" r="4" fill="#a8a8a8"/><circle cx="28" cy="56" r="2.4" fill="#a8a8a8"/>
  <rect x="27" y="68" width="6" height="18" fill="#5a5a5a" stroke="#222" stroke-width="1.2"/>
  <path d="M14 98 L20 86 H40 L46 98 Z" fill="#6a6a6a" stroke="#222" stroke-width="1.2" stroke-linejoin="round"/>
</svg>
EOF
cat > "$P/Telescope.svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!-- bookshelf:overhang=0 -->
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 80 106">
  <g transform="rotate(-28 40 48)">
    <rect x="6" y="40" width="54" height="14" rx="2" fill="#b8b8b8" stroke="#222" stroke-width="1.4"/>
    <rect x="58" y="37" width="12" height="20" rx="2" fill="#8a8a8a" stroke="#222" stroke-width="1.4"/>
    <rect x="0" y="43" width="8" height="8" rx="1" fill="#6a6a6a" stroke="#222" stroke-width="1.2"/>
    <rect x="26" y="38" width="5" height="18" fill="#6a6a6a" stroke="#222" stroke-width="1"/>
  </g>
  <path d="M40 54 L24 98 M40 54 L56 98 M40 54 V98" stroke="#222" stroke-width="5" stroke-linecap="round"/>
  <path d="M40 54 L24 98 M40 54 L56 98 M40 54 V98" stroke="#8a8a8a" stroke-width="2.6" stroke-linecap="round"/>
</svg>
EOF
json "$P/theme/theme.json" '{"name": "Night Sky", "description": "A dark star field over a graphite shelf, with a moon and a telescope.", "shelf": "dark", "plank": "Graphite", "hero": "Moon"}'
json "$P/theme/colours.json" '{
  "day":   {"page": "#0D1014", "text": "#E6E6E6", "panel": "#1A1F26", "panel text": "#EEEEEE", "menu bar": "#0D1014",
            "progress bar": "#DDDDDD", "progress track": "#3A3F46", "selected shelf": "#E6E6E6", "selected shelf text": "#0D1014", "plank": "#5C5C5C"},
  "night": {"page": "#0D1014", "text": "#E6E6E6", "panel": "#1A1F26", "panel text": "#EEEEEE", "menu bar": "#0D1014",
            "progress bar": "#DDDDDD", "progress track": "#3A3F46", "selected shelf": "#E6E6E6", "selected shelf text": "#0D1014", "plank": "#5C5C5C"}}'

# Credits for the CC0 artwork
cat > "$OUT/Botanical/CREDITS.txt" <<'EOF'
All prints CC0, The Cleveland Museum of Art Open Access (clevelandart.org/open-access):
Fern - Henry Bradbury, Ferns of Great Britain and Ireland: Polypodium Phegopteris, 1855-56 (1993.45)
Turban lily - De Gouy after Redouté, Lillium Pomponium, plate 7 from Les Liliacées, 1802-16 (2020.164)
Cape lily - Sydenham Edwards, The Botanical Magazine: White Cape-Coast Lily, 1806 (1955.142)
Flowering rush - Thomas Curtis, The Botanical Magazine: Umbel-Flowering Bu..., 1807 (1955.144)
EOF
cat > "$OUT/Library/CREDITS.txt" <<'EOF'
Wallpaper: Antonio Canaletto, Views: The Library, Venice, 1735-46. CC0, The Cleveland Museum of Art (1925.1239.15).
Candle, globe and hourglass drawn for this pack.
EOF
rm -rf "$T"
