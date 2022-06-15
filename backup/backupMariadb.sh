#!/bin/sh

BACKUP_NAME="$(date +'%d-%m-%Y_%H:%M:%S')"

#Delete older backup of 15 days
find "$BACKUP_DATABASE_PATH_PACIFISTA" -type f -mtime +15 -delete
find "$BACKUP_DATABASE_PATH_FUNIX" -type f -mtime +15 -delete

#start backup mariadb db pacifista
mysqldump -h "$MARIADB_ADDRESS" -P "$MARIADB_PORT_PACIFISTA" -u "$MARIADB_USER_PACIFISTA" -p"$MARIADB_PASSWORD_PACIFISTA" --all-databases | zip > "$BACKUP_DATABASE_PATH_PACIFISTA/mariadb-pacifista-$BACKUP_NAME.zip"

#start backup mariadb db funix
mysqldump -h "$MARIADB_ADDRESS" -P "$MARIADB_PORT_FUNIX" -u "$MARIADB_USER_FUNIX" -p"$MARIADB_PASSWORD_FUNIX" --all-databases | zip > "$BACKUP_DATABASE_PATH_FUNIX/mariadb-funix-$BACKUP_NAME.zip"
