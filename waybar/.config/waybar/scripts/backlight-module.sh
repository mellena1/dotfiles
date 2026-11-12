#!/bin/bash
# Backlight module for waybar - emits nothing when the machine has no
# backlight device (e.g. a desktop), so the module hides itself.
# The built-in backlight module leaves a stale "0%" label in that case
# (waybar 0.16 regression).

for device in /sys/class/backlight/*; do
    # An unmatched glob stays literal, hence the readability checks
    [ -r "$device/max_brightness" ] && [ -r "$device/brightness" ] || continue

    read -r max < "$device/max_brightness"
    read -r current < "$device/brightness"
    [ -n "$max" ] && [ "$max" -gt 0 ] || continue

    percent=$(( (current * 100 + max / 2) / max ))
    [ "$percent" -gt 100 ] && percent=100

    printf '{"text": "%d", "percentage": %d, "tooltip": "%d%%"}\n' "$percent" "$percent" "$percent"
    exit 0
done
