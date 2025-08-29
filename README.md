# Beluga

Run ROS2 in a dockerised environment!

> **System tested**
> - ✅ Ubuntu 22.04 (amd64/arm64)
> - ✅ Ubuntu 24.04 (amd64)
> - ✅ Fedora 42 (amd64)

## Pre-requisites

> **Note:** This docker image only works with Nvidia GPU currently.

Ensure that [Docker](https://docs.docker.com/engine/install/ubuntu/) & [Nvidia Container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) is installed before running the container.

# Config

## ROS Version
The target distro could be change via the `ROS_ENV` arguement inside `docker-compose.yml` file.

```yaml
    ...
    args:
      ROS_ENV="jazzy" # Change here
    ...
```

## Workspace
The workspace directory that is attached to the container is defined in the `volumes` section inside `docker-compose.yml` file, which is attached with the following structure: `<host_dir>:<container_dir>`.

```yaml
    ...
    volumes:
      - ./beluga_ws:/home/user/beluga_ws
    ...
```

# Docker
## Building the image

Currently, the image have to be build locally before it could be used. To build the Docker image. To build the image:

```sh
cd ~/beluga
docker compose build
```

> **Note:** To build with verbose, add the `--progress=plain` flag after the build.

## Running the container

Enter the docker container via the `enter_env` script.
```sh
cd ~/beluga
sudo chmod +x enter_env.sh
./enter_env.sh
```

## Wayland/Fedora specific

> If you are using Wayland and/or Fedora, please do not skip this section as RViz2 may crash upon launching the usual way.

To run RViz2 in docker, there are a few additional steps to be taken. Before starting the container, ensure that Docker is allowed to access the X server (the display).

> **Note:** If the container is currently running, stop the container first before adding the docker to the xhost. 

```sh
xhost +local:docker
```

After that, restart the container.

```sh
cd ~/beluga
./enter_env.sh
```

### RViz2

To start Rviz2, export `QT_QPA_PLATFORM` as `xcb`, since [Rviz2 does not support Wayland](https://github.com/ros2/rviz/pull/1254).

```sh
QT_QPA_PLATFORM=xcb rviz2
```

### Gazebo

Similarly, export `QT_QPA_PLATFORM` as `xcb` before running gazebo. [(Reference)](https://discuss.px4.io/t/running-gazebo-harmonic-in-24-04-wayland/40801)

```sh
QT_QPA_PLATFORM=xcb gz sim
```

# License
<a href="LICENSE" ><img src="https://img.shields.io/github/license/quantumxt/beluga?style=flat-square"/></a>
