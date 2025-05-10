#!/bin/bash

# Config
RIP_BASE="/Volumes/data/rips"
STAGING_BASE="/Volumes/data/staging"
LICENSE_PATH="$HOME/deathstar-ripper/config/filebot-license.txt"

# Detect most recent folder in rips
LATEST_RIP=$(find "$RIP_BASE" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 ls -td | head -n 1)

if [ -z "$LATEST_RIP" ]; then
    echo "❌ No rip folder found in $RIP_BASE"
    exit 1
fi

echo "📁 Using latest rip folder: $LATEST_RIP"

# Activate license if not already activated
if [ -f "$LICENSE_PATH" ]; then
    filebot --license "$LICENSE_PATH" >/dev/null 2>&1
fi

# Run FileBot to rename and move files
filebot -rename "$LATEST_RIP" \
        --db TheMovieDB \
        --output "$STAGING_BASE" \
        --format "{n} ({y})" \
        --conflict auto \
        -non-strict

echo "✅ Renaming complete. Files moved to $STAGING_BASE"
