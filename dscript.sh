#!/bin/bash

echo "
██████  ███████  ██████ ██████  ██ ██████  ████████ 
██   ██ ██      ██      ██   ██ ██ ██   ██    ██    
██   ██ ███████ ██      ██████  ██ ██████     ██    
██   ██      ██ ██      ██   ██ ██ ██         ██    
██████  ███████  ██████ ██   ██ ██ ██         ██    
"


echo ""
echo "Give the exact name of the resource you want to delete e.g. node_modules"
read modules

echo ""

echo "Give the file path to delete all the $modules of its sub-directories"
echo "e.g. C:/Users/username/projects"
read file_path

echo ""
echo "Given file path: $file_path"
echo ""

echo "Finding all the $modules directories......"

echo ""

# Find all node_modules directories and store their paths in an array
mapfile -t modules_paths < <(find "$file_path" -type d -name "$modules" -prune)

# Check if any node_modules directories are found
if [ ${#modules_paths[@]} -eq 0 ]; then
    echo "No $modules directories found to delete."
    exit 1
fi

echo "Found the following $modules directories:"
# Print the relative paths of the found node_modules directories with line numbers
for ((i=0; i<${#modules_paths[@]}; i++)); do
    printf "%d. %s\n" "$(($i + 1))" "${modules_paths[$i]}"
done

echo ""
# Ask if user wants to exclude any directories
echo "Do you want to exclude any folder or folders? (y/n)"
read is_yes

echo ""

if [[ $is_yes == "y" ]]; then
    echo "Specify the folders from the above found directories to exclude (comma-separated) e.g. 1,2"
    read folders

    # Convert comma-separated string into an array
    IFS=',' read -ra exclude_array <<< "$folders"

    echo ""
    # Print the remaining directories after exclusion
    echo "Please wait deleting all the $modules directories except the excluded ones......"

    # Filter out excluded directories
    for ((i=0; i<${#modules_paths[@]}; i++)); do
        # Check if the current index should be excluded
        skip=0
        for index in "${exclude_array[@]}"; do
            if [ "$index" -eq "$(($i + 1))" ]; then
                skip=1
                break
            fi
        done
        # Print the directory if not excluded
        if [ "$skip" -eq 0 ]; then
            echo ""
            printf "Deleting %d. %s\n" "$(($i + 1))" "${modules_paths[$i]}"
            rm -rf "${modules_paths[$i]}"
        fi
    done
else
    echo "Please wait deleting all the $modules directories......"

    for path in "${modules_paths[@]}"; do
        rm -rf "$path"
    done
fi

echo ""
echo "Deleted all the $modules directories."
exit 0
