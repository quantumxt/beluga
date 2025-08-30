#!/bin/bash

source .utils/check_build.sh

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
        exit 1
    fi
}

CUDA_VER=$(cat /usr/local/cuda/version.json | grep -w "cuda" -A 2 | grep version | awk '{print substr($3,2,length($3)-2)}')

if [[ -z $CUDA_VER ]]; then
    echo -e "\nCUDA not found!\n"
else
    echo -e "\nCUDA version: [$CUDA_VER]\n"
fi

cd docker

if [[ "$BELUGA_BUILT" == 0 ]]; then
    d_build x11
    check_output $?
fi

echo "=== Detected display manager: $SESSION_TYPE ==="

if [ "$SESSION_TYPE" == "wayland" ]; then
    xhost +local:docker
    echo "<< Starting with wayland..."
elif [ "$SESSION_TYPE" == "x11" ]; then
    echo "<< Starting with x11..."
else
    echo "<< Unable to determine display manager [$SESSION_TYPE], using x11..."
    exit 1
fi

d_up $SESSION_TYPE
