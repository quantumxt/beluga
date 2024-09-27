# Beluga
ROS2 with Docker.

> Tested on Ubuntu 24.04.1

## Pre-requisites
Ensure that [Docker](https://docs.docker.com/engine/install/ubuntu/) & [Nvidia Container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) is installed beforehand.

# Config

## ROS Version
The target distro could be change via the `ROS_ENV` arguement inside `docker-compose.yml` file.

```yaml
    ...
    args:
      ROS_ENV="humble" # Change here
    ...
```

## Workspace
The workspace directory that is attached to the container is defined in the `volumes` section inside `docker-compose.yml` file.

> Info: <host_dir>:<container_dir>

```yaml
    ...
    volumes:
      - ./beluga_ws:/home/user/beluga_ws
    ...
```

# Docker
Enter the docker container.
```sh
cd ~/beluga
sudo chmod +x enter_env.sh
./enter_env.sh
```

# License
<a href="LICENSE" ><img src="https://img.shields.io/github/license/quantumxt/beluga?style=flat-square"/></a>
