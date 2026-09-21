#!/bin/bash
# GPU info module for waybar - handles NVIDIA GPUs and gracefully skips if none present

# Check if nvidia-smi exists
if ! command -v nvidia-smi &> /dev/null; then
    # No NVIDIA GPU, output empty (module will be hidden)
    echo '{"text": ""}'
    exit 0
fi

# Check if nvidia-smi returns valid data
if ! nvidia-smi &> /dev/null; then
    # nvidia-smi exists but GPU not available
    echo '{"text": ""}'
    exit 0
fi

# Get GPU info with a single nvidia-smi call (was 5+ forks every 5s)
INFO=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,name,memory.used,memory.total,power.draw,clocks.gr --format=csv,noheader,nounits)
USAGE=$(echo "$INFO" | awk -F',' '{gsub(/[^0-9.]/,"",$1); print $1}')
TEMP=$(echo "$INFO" | awk -F',' '{gsub(/[^0-9.]/,"",$2); print $2}')
NAME=$(echo "$INFO" | awk -F',' '{gsub(/^ +| +$/,"",$3); print $3}')
VRAM=$(echo "$INFO" | awk -F',' '{gsub(/[^0-9.]/,"",$4); gsub(/[^0-9.]/,"",$5); printf "%.0f/%.0f", $4/1024, $5/1024}')
POWER=$(echo "$INFO" | awk -F',' '{gsub(/[^0-9.]/,"",$6); print ($6 == "" ? "N/A" : $6)}')
CLOCK=$(echo "$INFO" | awk -F',' '{gsub(/[^0-9.]/,"",$7); print ($7 == "" ? "N/A" : $7)}')

# Build tooltip
TOOLTIP=$(printf "%s\n\nUsage: %s%%\nTemperature: %s°C\nVRAM: %sGB\nPower: %sW\nClock: %s" "$NAME" "$USAGE" "$TEMP" "$VRAM" "$POWER" "$CLOCK")

# Output JSON
if command -v jq &> /dev/null; then
    jq -n -c \
        --arg text "${USAGE}% ${TEMP}°C ${VRAM}GB" \
        --arg tooltip "$TOOLTIP" \
        '{text: $text, tooltip: $tooltip}'
else
    printf '{"text": "%s%% %s°C %sGB", "tooltip": "%s"}' "$USAGE" "$TEMP" "$VRAM" "$TOOLTIP"
fi
