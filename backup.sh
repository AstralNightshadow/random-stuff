#!/bin/bash

# main function
function create_backup {
    echo ""
    echo "┌───────────────┐"
    echo "│ Configuration │"
    echo "└───────────────┘"
    echo ""

    # get path
    read -p "Enter the file/directory to backup: " source_path
    read -p "Enter the destination directory for the backup: " destination_path

    # variable stuff
    timestamp=$(date +"%Y%m%d%H%M%S")
    log_file="$destination_path/backup_log.txt"
    backup_file="$destination_path/backup_$timestamp.tar.gz"

    # check if path exists
    if [[ -e "$source_path" ]]; then
        # try making backup
        {
            tar -czf "$backup_file" "$source_path" &&
            echo "Backup created successfully: $backup_file" &&
            echo "[$(date)] SUCCESS: Backup of $source_path created at $backup_file" >> "$log_file"
        } || {
            # error handling
            echo "An error occurred while creating the backup." &&
            echo "[$(date)] ERROR: Failed to create backup of $source_path" >> "$log_file"
        }
    else
        echo "Source path does not exist: $source_path"
        echo "[$(date)] ERROR: Source path not found: $source_path" >> "$log_file"
    fi
}

# start
echo ""
echo "###############################"
echo "# Welcome to my backup script #"
echo "###############################"
echo ""
echo "Enjoy and keep your data safe!"
echo ""

create_backup
