#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

send_error_message() {
    "$SCRIPT_PATH/../discord/sendMessageDiscord.sh" ":warning: **Erreur:** $1"
}

send_success_message() {
    "$SCRIPT_PATH/../discord/sendMessageDiscord.sh" ":white_check_mark: $1"
}

send_message() {
    "$SCRIPT_PATH/../discord/sendMessageDiscord.sh" ":information_source: **Info:** $1"
}

BACKUP_NAME="$(date +'%d-%m-%Y_%H:%M:%S')"

#Delete older backup of 15 days
find "$PATH_NAS_BACKUP/backup-db" -type f -mtime +60 -delete

#Create backup for postgresql databases

send_message "Backup de la base de donnée FunixProductions en cours..."
PGPASSWORD=$PGPASSWORD_FUNIXPROD pg_dump -h "$POSTGRESQL_FUNIXPROD_ADDRESS" -p "$POSTGRESQL_FUNIXPROD_PORT" -U "$POSTGRESQL_FUNIXPROD_USER" -d funixproductions_db | zip > "$PATH_NAS_BACKUP/backup-db/postgresql-funixproductions-$BACKUP_NAME.zip" \
 || { send_error_message "Erreur lors du backup de la base de donnée FunixProductions"; exit 1; }
send_success_message "Backup de la base de donnée FunixProductions terminé !"

send_message "Backup de la base de donnée FunixGaming en cours..."
PGPASSWORD=$PGPASSWORD_FUNIXGAMING pg_dump -h "$POSTGRESQL_FUNIXGAMING_ADDRESS" -p "$POSTGRESQL_FUNIXGAMING_PORT" -U "$POSTGRESQL_FUNIXGAMING_USER" -d funixgaming_db | zip > "$PATH_NAS_BACKUP/backup-db/postgresql-funixgaming-$BACKUP_NAME.zip" \
 || { send_error_message "Erreur lors du backup de la base de donnée FunixGaming"; exit 1; }
send_success_message "Backup de la base de donnée FunixGaming terminé !"

send_message "Backup de la base de donnée Pacifista en cours..."
PGPASSWORD=$PGPASSWORD_PACIFISTA pg_dump -h "$POSTGRESQL_PACIFISTA_ADDRESS" -p "$POSTGRESQL_PACIFISTA_PORT" -U "$POSTGRESQL_PACIFISTA_USER" -d pacifista_db | zip > "$PATH_NAS_BACKUP/backup-db/postgresql-pacifista-$BACKUP_NAME.zip" \
 || { send_error_message "Erreur lors du backup de la base de donnée Pacifista"; exit 1; }
send_success_message "Backup de la base de donnée Pacifista terminé !"

#To import database follow this steps:
#1. unzip file
#2. rename the file in database.sql
#3. createdb -h HOST -p PORT -U USER database_name
#4. psql -h HOST -p PORT -U USER -d database_name < database.sql
