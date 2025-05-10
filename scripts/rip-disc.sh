#!/bin/bash
set -e

DISC_LABEL=$(/Applications/MakeMKV.app/Contents/MacOS/makemkvcon -r info disc:0 | grep DRV:0 | cut -d',' -f6 | tr -d '"')
OUTPUT_DIR="/Volumes/data/rips/${DISC_LABEL}"
mkdir -p "$OUTPUT_DIR"

echo "🚀 Starting rip for disc: $DISC_LABEL"
echo "📁 Output directory: $OUTPUT_DIR"

# Detect the longest title using TINFO parsing (stable for any disc)
/Applications/MakeMKV.app/Contents/MacOS/makemkvcon -r --minlength=60 info disc:0 > /tmp/makemkv_info.log

longest_title=$(
  grep 'TINFO:[0-9]\+,9,0,' /tmp/makemkv_info.log | \
  sed -E 's/TINFO:([0-9]+),9,0,"([0-9]+):([0-9]+):([0-9]+)"/\1 \2 \3 \4/' | \
  awk '{ print $1, ($2 * 3600) + ($3 * 60) + $4 }' | \
  sort -k2 -nr | head -n1 | cut -d" " -f1
)

if [[ -z "$longest_title" ]]; then
  echo "❌ Could not detect the longest title."
  exit 1
fi

echo "🎯 Selected title $longest_title as the longest title"

# Rip that title
/Applications/MakeMKV.app/Contents/MacOS/makemkvcon mkv disc:0 $longest_title "$OUTPUT_DIR" --minlength=60 --decrypt

echo "✅ Rip complete for title $longest_title"
