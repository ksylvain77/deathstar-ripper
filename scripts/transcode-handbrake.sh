#!/bin/bash

# Config
STAGING_BASE="/Volumes/data/staging"
FINAL_BASE="/Volumes/data/final"

# Find the most recently modified MKV file in staging
INPUT_FILE=$(find "$STAGING_BASE" -type f -iname "*.mkv" -print0 | xargs -0 ls -t | head -n 1)

if [ -z "$INPUT_FILE" ]; then
    echo "❌ No MKV file found in $STAGING_BASE"
    exit 1
fi

# Create output filename (same name, .mp4 extension)
BASENAME=$(basename "$INPUT_FILE" .mkv)
OUTPUT_FILE="$FINAL_BASE/$BASENAME.mp4"

echo "🎬 Transcoding: $INPUT_FILE → $OUTPUT_FILE"

# Run HandBrakeCLI
HandBrakeCLI -i "$INPUT_FILE" -o "$OUTPUT_FILE" --preset "Fast 1080p30"

echo "✅ Transcode complete. File saved to $OUTPUT_FILE"

# 🧹 Cleanup: remove staging MKV
echo "🧹 Removing MKV from staging..."
rm "$INPUT_FILE"
echo "✅ Removed: $INPUT_FILE"

# 🧹 Cleanup: remove original rip folder (based on MKV’s filename)
BASENAME_WITHOUT_EXT=$(basename "$INPUT_FILE" .mkv)
RIP_FOLDER=$(find /Volumes/data/rips -type d -name "*$BASENAME_WITHOUT_EXT*" | head -n 1)

if [ -n "$RIP_FOLDER" ] && [ -d "$RIP_FOLDER" ]; then
    echo "🧹 Removing matching rip folder: $RIP_FOLDER"
    rm -rf "$RIP_FOLDER"
    echo "✅ Removed: $RIP_FOLDER"
else
    echo "⚠️ Could not locate rip folder matching: $BASENAME_WITHOUT_EXT"
fi
