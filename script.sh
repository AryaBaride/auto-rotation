#!/bin/bash

#verify is zip command is installed
if ! command -v zip &> /dev/null; then
  echo "Error: The 'zip' command is not installed. Please install it and try again." >&2
  exit 1
fi

#create a backup file
BACKUP_FILE='/home/ubuntu/backup_file'

#create the file where you want your backups to be stored
SOURCE_FILE='/home/ubuntu/source_file'

#list the number of backups you need
BACKUP_COUNT=3

#this will save the backup file along with time to make the file look unique
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

#combine the backup file with backup directory by creating a zip file
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.zip"

echo "Creating backup: $BACKUP_FILE"

#this will recursively include every file from backup file to source file
zip -r "$BACKUP_FILE" "$SOURCE_FILE"

#verify if backup is completed
if [ $? -eq 0 ]; then
        echo "backup completed"
else
        echo "backup creation failed"
        exit 1
fi

echo "Rotating backups"

#BACKUPS: Stores the list of backup files as an array.
BACKUPS=($(ls -t "$BACKUP_DIR/backup-*.zip))
COUNT={#BACKUPS[@]}

#COUNT IS EXISTING NUMBER OF BACKUPS
if [$COUNT -gt $BACKUP_COUNT]; then
	for((i=BACKUP_COUNT; i<COUNT; i++)); do
		echo "deleting backup files ${BACKUPS[$i]}"
		rm -f "${BACKUPS[$i]}"
  	done
else
  echo "No old backups to delete."
fi

