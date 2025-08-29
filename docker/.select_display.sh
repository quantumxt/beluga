#!/bin/bash

source .check_build.sh

USER=$(whoami)
SESSION_ID=$(loginctl | grep "$USER" -m 1 | awk '{print $1}')
SESSION_TYPE=$(loginctl show-session "$SESSION_ID" --property=Type --value)

d_up () {
    docker compose -f docker-compose-$1.yml up -d
}

d_build () {
    echo "<< Building image..."
    docker compose -f docker-compose-$1.yml build --quiet
}

check_output() {
    if [[ $1 -eq 0 ]]; then
        echo ">> Build: OK"
    else
        echo ">> Build: ERROR"
    fi
}

cd docker
echo "=== Detected display manager: $SESSION_TYPE ==="

if [ "$SESSION_TYPE" == "wayland" ]; then
    if [[ "$BELUGA_BUILT" == 0 ]]; then
        d_build $SESSION_TYPE
        check_output $?
    fi
    xhost +local:docker
    d_up $SESSION_TYPE
elif [ "$SESSION_TYPE" == "x11" ]; then
    if [[ "$BELUGA_BUILT" == 0 ]]; then
        d_build $SESSION_TYPE
        check_output $?
    fi
    d_up $SESSION_TYPE
else
    echo "Unable to detect display manager, exiting..."
    exit 1
fi
