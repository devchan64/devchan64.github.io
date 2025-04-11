#!/bin/bash

set -e

INPUT_DIR="./slides"
OUTPUT_DIR="../assets/images/slides"
ENGINE="./engine.js"
THEME="theme.css"

mkdir -p "$OUTPUT_DIR"

for mdfile in "$INPUT_DIR"/*.md; do
  filename=$(basename -- "$mdfile" .md)
  outfile="$OUTPUT_DIR/$filename.jpg"

  if [ -f "$outfile" ]; then
    echo "✅ Skipping $filename (already exists)"
  else
    echo "⚙️  Building $filename..."
    npx marp "$mdfile" \
      --html \
      --image jpeg \
      --theme "$THEME" \
      --engine "$ENGINE" \
      --template bare \
      -o "$outfile"
  fi
done

echo "✅ All done."
