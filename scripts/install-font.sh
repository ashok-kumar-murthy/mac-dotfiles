#!/usr/bin/env bash
# Install the exact IoskeleyMono Nerd Font release used by this configuration.

set -euo pipefail

VERSION="v2.0.0"
ARCHIVE="IoskeleyMono-NerdFont.zip"
URL="https://github.com/ahatem/IoskeleyMono/releases/download/$VERSION/$ARCHIVE"
SHA256="6883758c3a1c56573825b7e6ecda73d9bde6ddd9f5b504e977c9101e800fbab6"
FONT_DIR="$HOME/Library/Fonts"
DRY_RUN="${DRY_RUN:-}"

if [[ -f "$FONT_DIR/IoskeleyMonoNerdFont-Regular.ttf" ]]; then
  echo "IoskeleyMono Nerd Font is already installed"
  exit 0
fi

if [[ -n "$DRY_RUN" ]]; then
  printf 'would download %s\n' "$URL"
  printf 'would verify sha256 %s\n' "$SHA256"
  printf 'would install Normal/Unhinted TTF files into %s\n' "$FONT_DIR"
  exit 0
fi

temp_dir="$(mktemp -d -t ioskeley-font)"
trap 'rm -rf -- "$temp_dir"' EXIT

curl --fail --location --silent --show-error "$URL" --output "$temp_dir/$ARCHIVE"
printf '%s  %s\n' "$SHA256" "$temp_dir/$ARCHIVE" | shasum -a 256 -c -
unzip -q "$temp_dir/$ARCHIVE" -d "$temp_dir/unpacked"
mkdir -p "$FONT_DIR"

font_count=0
while IFS= read -r -d '' font; do
  cp "$font" "$FONT_DIR/"
  font_count=$((font_count + 1))
done < <(find "$temp_dir/unpacked" -path '*/Normal/Unhinted/*.ttf' -print0)

[[ "$font_count" -gt 0 ]] || {
  echo "no Normal/Unhinted fonts found in archive" >&2
  exit 1
}
printf 'installed %d IoskeleyMono Nerd Font files\n' "$font_count"
