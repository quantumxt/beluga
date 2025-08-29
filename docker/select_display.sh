#!/bin/bash

USER=$(whoami)
SESSION_ID=$(loginctl | grep "$USER" -m 1 | awk '{print $1}')
SESSION_TYPE=$(loginctl show-session "$SESSION_ID" --property=Type --value)

echo "Detected display manager: $SESSION_TYPE"

if [ "$SESSION_TYPE" == "wayland" ]; then
    docker compose -f docker-compose-wayland.yml up -d
elif [ "$SESSION_TYPE" == "x11" ]; then
    docker compose -f docker-compose-x11.yml up -d
else
    echo "Unable to detect display manager..."
    exit 1
fi
