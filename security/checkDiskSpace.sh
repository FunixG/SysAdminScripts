#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# Set the directory you want to check
TARGET_DIR="/dev/md3"

# Calculate directory size (in human-readable format)
DIR_SIZE=$(df -h "$TARGET_DIR")

"$SCRIPT_PATH/../discord/sendMessageDiscord.sh" ":floppy_disk: **Espace disque:**\n$DIR_SIZE"
