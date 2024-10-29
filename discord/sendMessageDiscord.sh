#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <message>"
    exit 1
fi

# Message Content (JSON format)
MESSAGE_CONTENT="{
  \"content\": \"$1\"
}"

# Sending the message
curl -H "Content-Type: application/json" \
     -X POST \
     -d "$MESSAGE_CONTENT" \
     "$DISCORD_ALERTS_CHANNEL_WEBHOOK_URL"
