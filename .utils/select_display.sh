#!/bin/bash

source .utils/check_build.sh
source .utils/user.sh

TARGET_IMG="ubuntu:24.04"
PROFILE="cpu"

get_config () {
    R_TYPE=$(cat .env | grep $1 | awk '{print $1}')
    echo $R_TYPE
}

d_up () {
    docker compose -f docker-compose-$1.yml --profile $2 up -d
}

d_build () {
    echo "<< Building image..."
    docker compose -f docker-compose-$1.yml build #--quiet
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
    echo ">> Unable to determine CUDA version, checking via nvidia-smi..."
    CUDA_VER=$(nvidia-smi | grep CUDA | awk '{print $9}')
fi

if [[ -z $CUDA_VER ]]; then
    echo -e "\nCUDA not found!\n"
else
    echo -e "\nCUDA version: [$CUDA_VER]\n"
    TARGET_IMG="nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04"
    PROFILE="gpu"
fi

cd docker

echo "=== Config ==="
get_config "ROS_ENV"
get_config "ROS_TYPE"
echo "Runtime: $PROFILE"
echo ""

if [[ "$BELUGA_BUILT" == 0 ]]; then
    d_build x11 --build-arg MYAPP_IMAGE=$TARGET_IMG
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

d_up $SESSION_TYPE $PROFILE

CONTAINER_NAME=$(docker ps | grep beluga_ros2 | grep $PROFILE | awk '{print $NF}')
docker exec -it $CONTAINER_NAME bash
