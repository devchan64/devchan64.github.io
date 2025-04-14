#!/bin/bash

set -e

INPUT_DIR="./ppt"
OUTPUT_DIR="../assets/ppt"
ENGINE="./engine.js"

mkdir -p "$OUTPUT_DIR"

for mdfile in "$INPUT_DIR"/*.md; do
  filename=$(basename -- "$mdfile" .md)
  outfile="$OUTPUT_DIR/$filename.html"

  if [ -f "$outfile" ]; then
    echo "✅ Skipping $filename (already exists)"
  else
    echo "⚙️  Building $filename..."
    npx marp "$mdfile" \
      --html \
      --engine "$ENGINE" \
      -o "$outfile"
  fi
done

echo "✅ All done."
