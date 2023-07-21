#!/bin/sh

BACKUP_NAME="$(date +'%d-%m-%Y_%H:%M:%S')"

#Delete older backup of 30 days
find "$PATH_NAS_BACKUP/backup-servers" -type f -mtime +14 -delete

#Create backup of pterodactyl
zip -r "$PATH_NAS_BACKUP/backup-servers/$BACKUP_NAME.zip" "$PTERODACTYL_PATH"
