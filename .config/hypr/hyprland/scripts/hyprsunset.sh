#!/bin/bash

# Define the options for the menu, including a custom number input prompt
OPTIONS="identity
evening
night"

# Use wofi to display the options and get the user's selection
SELECTION=$(echo -e "$OPTIONS" | wofi --dmenu --prompt "Select hyprsunset temperature")

# Check if a selection was made
if [ -n "$SELECTION" ]; then
    case "$SELECTION" in
    "identity")
        hyprctl hyprsunset identity
        ;;
    "evening")
        hyprctl hyprsunset temperature 2500
        ;;
    "night")
        hyprctl hyprsunset temperature 1500
        ;;
    *)
        if [[ -n "$SELECTION" && "$SELECTION" =~ ^[0-9]+$ ]]; then
            hyprctl hyprsunset temperature "$SELECTION"
        else
            echo "Invalid selection."
        fi
        ;;
    esac
else
    echo "Invalid input."
fi
