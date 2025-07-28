#!/bin/bash

RAMFILE="/dev/shm/cava_output.txt"

# Read last line from cava-file
line=$(cat $RAMFILE)

# Check if music is playing
if [[ "$(playerctl status 2>/dev/null)" != "Playing" ]]; then
    echo ""
    exit 0
fi

# Check if fil exists or empty
if [[ -z "$line" ]]; then
    echo ""
    exit 0
fi

bars=()

# swap semicolon to space and match the number with ASCII
for value in ${line//;/ }; do
    height=$value
    if (( height > 8 )); then height=8; fi

    case $height in
        0) bars+=("⠀") ;;
        1) bars+=("⠉") ;;
        2) bars+=("⠋") ;;
        3) bars+=("⠛") ;;
        4) bars+=("⠟") ;;
        5) bars+=("⠿") ;;
        6) bars+=("⡿") ;;
        7) bars+=("⣿") ;;
        8) bars+=("⣿") ;;
    esac
done

# output for hyprlock
echo "${bars[*]}"
