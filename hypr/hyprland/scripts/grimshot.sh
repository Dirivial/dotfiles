#!/bin/bash

# Define the grimshot options
OPTIONS="active
screen
output
area
window
anything"

# Use wofi to display the options and get the user's selection
SELECTION=$(echo -e "$OPTIONS" | wofi --dmenu --prompt "Select grimshot action:")

# Check if a selection was made (user didn't cancel)
if [ -n "$SELECTION" ]; then
  # Execute the grimshot command with the selected option
  grimshot --notify copy "$SELECTION"
else
  echo "No grimshot action selected."
fi
