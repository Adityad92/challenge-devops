3. **Backup Script:**
   - Create a bash script that automates the backup process for a specified directory.
   - The script should compress the directory into a tar archive and timestamp the backup file.
   - Add options to specify the source directory, destination directory, and backup frequency.
   - Implement rotation of old backups, keeping only a certain number of recent backups.
   - Extend the script to support incremental backups and remote backup destinations (e.g., SSH, FTP).

```bash
#!/bin/bash

# Function to create a backup
create_backup() {
    local source_dir=$1
    local dest_dir=$2
    local backup_filename="backup_$(date +%Y%m%d_%H%M%S).tar.gz"

    # Create backup archive
    tar -czf "$dest_dir/$backup_filename" "$source_dir"

    echo "Backup created: $backup_filename"
}

# Check if source and destination directories are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

source_directory=$1
destination_directory=$2

create_backup "$source_directory" "$destination_directory"
```