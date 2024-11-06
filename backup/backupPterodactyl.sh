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

#Delete older backup of 30 days
find "$PATH_NAS_BACKUP/backup-servers" -type f -mtime +14 -delete

#Create backup of pterodactyl
send_message "Backup de Pterodactyl en cours..."

ERROR=$(zip -r "$PATH_NAS_BACKUP/backup-servers/$BACKUP_NAME.zip" "$PTERODACTYL_PATH" 2>&1) 
if [ $? -ne 0 ]; then
    send_error_message "Erreur lors du backup de Pterodactyl : $ERROR"
    exit 1
else
    send_success_message "Backup de Pterodactyl terminé !"
fi
