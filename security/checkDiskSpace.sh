#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# Set the directory you want to check
TARGET_DIR="/dev/md3"

# Calculate directory size (in human-readable format)
DIR_SIZE=$(df -h "$TARGET_DIR" | awk 'NR==2 {print $4}')

"$SCRIPT_PATH/../discord/sendMessageDiscord.sh" ":floppy_disk: **Espace disque:** Espace disponible $DIR_SIZE"
