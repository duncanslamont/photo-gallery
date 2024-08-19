#!/bin/bash

# The path to the images directory
IMAGES_DIR="images"

# Function to rename files in a given directory
rename_files() {
    local dir="$1"
    local prefix="$(basename "$dir")"

    for file in "$dir"/*.JPG; do
        # Check if there are any JPG files in the directory
        if [ -e "$file" ]; then
            # Extract the base name of the file
            local base_name=$(basename "$file")
            # Create the new name with the prefix
            local new_name="${prefix}_${base_name}"
            # Rename the file
            mv "$file" "$dir/$new_name"
            echo "Renamed $file to $dir/$new_name"
        fi
    done
}

# Export the function so it can be used by find
export -f rename_files

# Find all directories within the images directory and apply the renaming function
find "$IMAGES_DIR" -type d -mindepth 1 -exec bash -c 'rename_files "$0"' {} \;

echo "Renaming completed."
