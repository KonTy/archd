#!/bin/bash

# Path to your background images directory
BACKGROUND_DIR="$HOME/.config/configs/backgrounds"

# Get the current tag (workspace) index from the first argument
tag=$1

# Calculate the corresponding image index (1-based)
image_index=$((tag + 1))

# Construct the path to the background image
background_image="$BACKGROUND_DIR/bg${image_index}.jpg"

# Function to set background with a fade effect
set_background_with_fade() {
    # Set the background with feh initially (without transition)
    feh --bg-scale "$background_image"

    # Use picom to fade in the background image
    picom-trans -c &
    sleep 0.2  # Adjust this sleep duration for your desired fade-in speed
    picom-trans -o
}

# Call the function to set background with fade effect
set_background_with_fade