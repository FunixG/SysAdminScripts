#!/bin/sh

BACKUP_NAME="$(date +'%d-%m-%Y_%H:%M:%S')"

#Delete older backup of 30 days
find "$BACKUP_PTERODACTYL_PATH" -type f -mtime +14 -delete

#Create backup of pterodactyl
zip -r "$BACKUP_PTERODACTYL_PATH/$BACKUP_NAME.zip" "$PTERODACTYL_PATH"
