#!/bin/bash
# CPU info module for waybar - works across different machines

# Get CPU usage
CPU_USAGE=$(cat /proc/stat | awk '/cpu / {print int(($2+$4)*100/($2+$4+$5))}')

# Try to find CPU temperature sensor (check multiple common ones)
CPU_TEMP=""
for sensor in "k10temp-pci-00c3" "coretemp-isa-0000" "acpitz-acpi-0"; do
    if sensors "$sensor" &>/dev/null; then
        CPU_TEMP=$(sensors "$sensor" 2>/dev/null | awk '/Tccd1|Tdie|Package id 0|temp1/ {print int($2); exit}')
        [ -n "$CPU_TEMP" ] && break
    fi
done

# Fallback if no temp sensor found
[ -z "$CPU_TEMP" ] && CPU_TEMP="N/A"

# Get load average
LOAD=$(uptime | sed 's/.*load average://')

# Get per-core usage for tooltip
CORE_INFO=$(awk '/^cpu[0-9]/ {
    usage=int(($2+$4)*100/($2+$4+$5))
    printf "Core %d: %d%%\n", NR-1, usage
}' /proc/stat)

# Build tooltip
if [ "$CPU_TEMP" != "N/A" ]; then
    TOOLTIP=$(printf "CPU: %s%%\nTemp: %s°C\n\nPer-Core:\n%s\n\nLoad:%s" "$CPU_USAGE" "$CPU_TEMP" "$CORE_INFO" "$LOAD")
else
    TOOLTIP=$(printf "CPU: %s%%\n\nPer-Core:\n%s\n\nLoad:%s" "$CPU_USAGE" "$CORE_INFO" "$LOAD")
fi

# Output JSON for waybar (fallback to printf if jq fails)
if command -v jq &> /dev/null; then
    jq -n -c \
        --arg text "${CPU_USAGE}% ${CPU_TEMP}°C" \
        --arg tooltip "$TOOLTIP" \
        '{text: $text, tooltip: $tooltip}'
else
    # Fallback without jq
    printf '{"text": "%s%% %s°C", "tooltip": "%s"}' "$CPU_USAGE" "$CPU_TEMP" "$TOOLTIP"
fi
