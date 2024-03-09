#!/bin/sh

BACKUP_NAME="$(date +'%d-%m-%Y_%H:%M:%S')"

#Delete older backup of 15 days
find "$PATH_NAS_BACKUP/backup-db" -type f -mtime +15 -delete

#Create backup for postgresql databases
PGPASSWORD=$PGPASSWORD_FUNIXPROD pg_dump -h "$POSTGRESQL_FUNIXPROD_ADDRESS" -p "$POSTGRESQL_FUNIXPROD_PORT" -U "$POSTGRESQL_FUNIXPROD_USER" -d funixproductions_db | zip > "$PATH_NAS_BACKUP/backup-db/postgresql-funixproductions-$BACKUP_NAME.zip"
PGPASSWORD=$PGPASSWORD_FUNIXGAMING pg_dump -h "$POSTGRESQL_FUNIXGAMING_ADDRESS" -p "$POSTGRESQL_FUNIXGAMING_PORT" -U "$POSTGRESQL_FUNIXGAMING_USER" -d funixgaming_db | zip > "$PATH_NAS_BACKUP/backup-db/postgresql-funixgaming-$BACKUP_NAME.zip"
PGPASSWORD=$PGPASSWORD_PACIFISTA pg_dump -h "$POSTGRESQL_PACIFISTA_ADDRESS" -p "$POSTGRESQL_PACIFISTA_PORT" -U "$POSTGRESQL_PACIFISTA_USER" -d pacifista_db | zip > "$PATH_NAS_BACKUP/backup-db/postgresql-pacifista-$BACKUP_NAME.zip"

#To import database follow this steps:
#1. unzip file
#2. rename the file in database.sql
#3. createdb -h HOST -p PORT -U USER database_name
#4. psql -h HOST -p PORT -U USER -d database_name < database.sql
