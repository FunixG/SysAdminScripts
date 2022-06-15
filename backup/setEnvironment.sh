#!/bin/sh

echo "Entrez le path pterodactyl:"
read -r pterodactyl_path
export PTERODACTYL_PATH="$pterodactyl_path"

echo "Entrez le path de backup ptero (backup):"
read -r backup_pterodactyl_path
export BACKUP_PTERODACTYL_PATH="$backup_pterodactyl_path"

