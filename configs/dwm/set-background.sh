#!/bin/bash

# Path to your background images directory
BACKGROUND_DIR="$HOME/.config/configs/backgrounds"

# Get the current tag (workspace) index from the first argument
tag=$1

# Calculate the corresponding image index (1-based)
image_index=$((tag + 1))

# Construct the path to the background image
background_image="$BACKGROUND_DIR/bg${image_index}.jpg"

# Set the background using feh
feh --bg-scale "$background_image"