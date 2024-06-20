1. **File Organizer:**
   - Create a bash script that organizes files in a directory based on their file extensions.
   - The script should create separate directories for each file type (e.g., images, documents, videos) and move the files into their respective directories.
   - Add options to specify the source directory and destination directory.
   - Extend the script to handle nested directories and provide a summary of the organization process.


```bash
#!/bin/bash

# Function to organize files
organize_files() {
    local source_dir=$1
    local dest_dir=$2

    # Create destination directories
    mkdir -p "$dest_dir"/images "$dest_dir"/documents "$dest_dir"/videos

    # Move files to respective directories
    find "$source_dir" -type f -name "*.jpg" -exec mv {} "$dest_dir"/images \;
    find "$source_dir" -type f -name "*.png" -exec mv {} "$dest_dir"/images \;
    find "$source_dir" -type f -name "*.pdf" -exec mv {} "$dest_dir"/documents \;
    find "$source_dir" -type f -name "*.doc" -exec mv {} "$dest_dir"/documents \;
    find "$source_dir" -type f -name "*.mp4" -exec mv {} "$dest_dir"/videos \;

    echo "File organization completed."
}

# Check if source and destination directories are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

source_directory=$1
destination_directory=$2

organize_files "$source_directory" "$destination_directory"
```