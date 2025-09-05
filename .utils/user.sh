#!/bin/bash

USER=$(whoami)
SESSION_ID=$(loginctl | grep "$USER" -m 1 | awk '{print $1}')
SESSION_TYPE=$(loginctl show-session "$SESSION_ID" --property=Type --value)