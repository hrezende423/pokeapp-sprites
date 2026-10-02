#!/usr/bin/env bash
# Mirrors PokeAPI's official artwork (Gen 5+) into this repo's releases,
# byte-identical, verified against artwork-manifest.json. Needs: gh (logged in), jq, curl.
# Usage: scripts/mirror-artwork.sh [tag ...]   (default: all tags in the manifest)
set -euo pipefail
cd "$(dirname "$0")/.."
REPO=hrezende423/pokeapp-sprites
SRC=https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
tags=("$@"); [ ${#tags[@]} -gt 0 ] || mapfile -t tags < <(jq -r 'keys[]' artwork-manifest.json)
for tag in "${tags[@]}"; do
  gh release view "$tag" -R $REPO >/dev/null 2>&1 || gh release create "$tag" -R $REPO \
    -t "Official artwork — $tag" -n "Static official artwork mirrored byte-identical from PokeAPI/sprites. Names: {id}-{n|s}.png (id = PokeAPI pokemon id; 10001+ are forms)."
  have=$(gh release view "$tag" -R $REPO --json assets -q '.assets[].name')
  jq -r --arg t "$tag" '.[$t].files | to_entries[] | "\(.key) \(.value)"' artwork-manifest.json |
  while read -r name sha; do
    grep -qxF "$name" <<<"$have" && continue
    id=${name%-*}; v=${name##*-}; v=${v%.png}; sub=""; [ "$v" = s ] && sub="shiny/"
    curl -sf --retry 3 -o "$tmp/$name" "$SRC/$sub$id.png"
    [ "$(sha256sum "$tmp/$name" | cut -d' ' -f1)" = "$sha" ] || { echo "CHECKSUM MISMATCH $name" >&2; exit 1; }
    gh release upload "$tag" "$tmp/$name" -R $REPO && rm -f "$tmp/$name"
  done
  echo "$tag done"
done
