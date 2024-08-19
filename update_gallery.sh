#!/bin/bash

# The path to the images directory
IMAGES_DIR="images"

# The index.html file
HTML_FILE="index.html"

# Temporary file to hold the new HTML content
TEMP_FILE="temp.html"

# Create or clear temporary files for each tab
> temp_new_england.html
> temp_iceland.html
> temp_boston.html

# Function to add images to the appropriate tab based on prefix
add_image_to_tab() {
    local img="$1"
    local tab_file="$2"

    echo "    <div class=\"image-container\">" >> "$tab_file"
    echo "        <img src=\"$img\" alt=\"$(basename "$img")\">" >> "$tab_file"
    echo "    </div>" >> "$tab_file"
}

# Clear previous entries in the respective sections of the HTML file and prepare new content
prepare_tab_content() {
    local placeholder="$1"
    local temp_file="$2"

    awk "/<!-- $placeholder -->/ {exit} {print}" "$HTML_FILE" > "$TEMP_FILE"
    cat "$temp_file" >> "$TEMP_FILE"
    echo "    <!-- $placeholder -->" >> "$TEMP_FILE"
    awk "/<!-- $placeholder -->/ {found=1; next} found" "$HTML_FILE" >> "$TEMP_FILE"
    mv "$TEMP_FILE" "$HTML_FILE"
}

# Recursively find all JPG files and sort them into tabs
find "$IMAGES_DIR" -type f -name "*.JPG" | while read -r img; do
    basename_img=$(basename "$img")
    
    if [[ "$basename_img" == NH* ]]; then
        add_image_to_tab "$img" "temp_new_england.html"
    elif [[ "$basename_img" == iceland* ]]; then
        add_image_to_tab "$img" "temp_iceland.html"
    elif [[ "$basename_img" == "mt auburn"* ]]; then
        add_image_to_tab "$img" "temp_boston.html"
    fi
done

# Prepare and update each tab with new content
prepare_tab_content "NEW_ENGLAND_PLACEHOLDER" "temp_new_england.html"
prepare_tab_content "ICELAND_PLACEHOLDER" "temp_iceland.html"
prepare_tab_content "BOSTON_PLACEHOLDER" "temp_boston.html"

# Clean up temporary files
rm temp_new_england.html temp_iceland.html temp_boston.html

echo "Gallery update completed."
