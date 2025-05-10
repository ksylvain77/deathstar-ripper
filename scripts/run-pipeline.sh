#!/bin/bash

# Prevent the Mac from sleeping while this script runs
caffeinate -s -w $$ &

echo "🚀 Starting Death Star Ripper Pipeline"

# Step 1: Rip from disc to /rips/{disc_label}
~/deathstar-ripper/scripts/rip-disc.sh || exit 1

# Step 2: Rename with FileBot to /staging
~/deathstar-ripper/scripts/rename-with-filebot.sh || exit 1

# Step 3: Transcode to /final
~/deathstar-ripper/scripts/transcode-handbrake.sh || exit 1

# Optional: Eject disc
echo "💿 Ejecting disc..."
drutil eject

echo "✅ Pipeline complete. Ready for the next victim."
