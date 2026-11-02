#!/bin/sh
set -eu

BIN="$HOME/.local/bin"
DATA="$HOME/.local/share/kaku"
URL="https://raw.githubusercontent.com/skk-dev/dict/master/SKK-JISYO.L"

make kaku

mkdir -p "$BIN" "$DATA"
cp kaku "$BIN/kaku"
cp ime.lua "$DATA/ime.lua"

if [ ! -f "$DATA/okuri-nasi.txt" ]; then
    echo "fetching dictionary..."
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    curl -fsSL -o "$tmp/jisyo" "$URL"
    iconv -f EUC-JP -t UTF-8 "$tmp/jisyo" > "$tmp/utf8"
    start=$(grep -n '^;; okuri-nasi entries\.' "$tmp/utf8" | cut -d: -f1)
    [ -n "$start" ] || { echo "dictionary header not found" >&2; exit 1; }
    tail -n +$((start + 1)) "$tmp/utf8" \
        | LC_ALL=C sort -t' ' -k1,1 > "$DATA/okuri-nasi.txt"
fi

echo "installed: $BIN/kaku"
