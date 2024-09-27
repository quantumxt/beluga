docker compose up -d
CONTAINER_NAME=$(docker ps | grep beluga_ros2 | awk '{print $NF}')
docker exec -it $CONTAINER_NAME bash
