#!/bin/bash
# Flat, grain-free planks on the same canvas as Bookshelf's built-in oak:
# 960x360 middle, 220x360 ends; top surface y120-214, highlight 214-216,
# front edge 216-238, shadow fading out by ~280. Ends are rounded at x=70
# and fade out from x=120 to x=210 so they blend into the middle piece.
# usage: make_planks.sh <outdir> <Name> <surface> <highlight> <front> <outline> <shadow-alpha 0-1>
#        make_planks.sh <outdir> Hairline   (special: a thin line, no slab)
set -euo pipefail
out=$1; name=$2; mkdir -p "$out"
mid="$out/plank.$name.middle.png"; left="$out/plank.$name.left.png"; right="$out/plank.$name.right.png"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

if [ "$name" = Hairline ]; then
    # A 4px rule where the plank's front edge would be, with a faint 1px shadow line.
    magick -size 960x360 xc:none \
        -fill '#2A2A2A' -draw 'rectangle 0,213 959,216' \
        -fill '#BDBDBD' -draw 'rectangle 0,217 959,218' "$mid"
    # Ends: the same rule with a square-cut end at x=70, no fade needed (flat colour).
    magick -size 220x360 xc:none \
        -fill '#2A2A2A' -draw 'rectangle 70,213 219,216' \
        -fill '#BDBDBD' -draw 'rectangle 70,217 219,218' "$left"
    magick "$left" -flop "$right"
    exit 0
fi

surface=$3; hi=$4; front=$5; line=$6; sh=$7

# Shadow: a vertical alpha ramp under the front edge.
magick -size 960x42 gradient:"rgba(0,0,0,$sh)"-"rgba(0,0,0,0)" "$tmp/shadow.png"
magick -size 960x360 xc:none \
    "$tmp/shadow.png" -geometry +0+238 -composite \
    -fill "$surface" -draw 'rectangle 0,120 959,213' \
    -fill "$hi"      -draw 'rectangle 0,214 959,215' \
    -fill "$front"   -draw 'rectangle 0,216 959,237' \
    -fill "$line"    -draw 'rectangle 0,120 959,121' -draw 'rectangle 0,237 959,237' \
    "$mid"

# Left end: the middle's first 220px, cut to a rounded corner at x=70 and
# faded out to the right so it overlaps the middle piece without a seam.
magick "$mid" -crop 220x360+0+0 +repage "$tmp/end.png"
magick -size 220x360 xc:black -fill white -draw 'roundrectangle 70,120 400,290 10,10' "$tmp/shape.png"
magick -size 220x360 xc:white \( -size 360x90 gradient:white-black -rotate -90 \) -geometry +120+0 -composite \
    -fill black -draw 'rectangle 210,0 219,359' "$tmp/fade.png"
magick "$tmp/shape.png" "$tmp/fade.png" -compose multiply -composite "$tmp/mask.png"
magick "$tmp/end.png" \( "$tmp/end.png" -alpha extract "$tmp/mask.png" -compose multiply -composite \) \
    -alpha off -compose copy_opacity -composite "$left"
magick "$left" -flop "$right"
