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

# Get GPU info
USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader)
VRAM=$(nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk -F',' '{printf "%.0f/%.0f", $1/1024, $2/1024}')
POWER=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits)
CLOCK=$(nvidia-smi --query-gpu=clocks.gr --format=csv,noheader,nounits)

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
