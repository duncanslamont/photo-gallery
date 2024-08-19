#!/bin/bash

# The path to the images directory
IMAGES_DIR="images"

# The index.html file
HTML_FILE="index.html"

# Temporary file to hold the new HTML content
TEMP_FILE="temp.html"

# Check if there are any JPG files in the directory
jpg_files=("$IMAGES_DIR"/*.JPG)

if [ -e "${jpg_files[0]}" ]; then
    # Start by copying the existing content up to the placeholder
    awk '/<!-- GALLERY_PLACEHOLDER -->/ {exit} {print}' "$HTML_FILE" > "$TEMP_FILE"

    # Add the image tags wrapped in a container div, only if they don't already exist in the file
    for img in "$IMAGES_DIR"/*.JPG; do
        if ! grep -q "src=\"$img\"" "$HTML_FILE"; then
            echo "    <div class=\"image-container\">" >> "$TEMP_FILE"
            echo "        <img src=\"$img\" alt=\"$(basename "$img")\">" >> "$TEMP_FILE"
            echo "    </div>" >> "$TEMP_FILE"
        fi
    done

    # Reinsert the placeholder
    echo "    <!-- GALLERY_PLACEHOLDER -->" >> "$TEMP_FILE"

    # Finish by copying the remaining content after the placeholder
    awk '/<!-- GALLERY_PLACEHOLDER -->/ {found=1; next} found' "$HTML_FILE" >> "$TEMP_FILE"

    # Replace the original index.html with the updated content
    mv "$TEMP_FILE" "$HTML_FILE"
else
    echo "No JPG files found in the $IMAGES_DIR directory."
fi
