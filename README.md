# Beluga

Run ROS2 in a dockerised environment, which automatically detects the host hardware and selects the runtime accordingly.

> **System tested**
> - ✅ Ubuntu 22.04 (amd64/arm64)
> - ✅ Ubuntu 24.04 (amd64)
> - ✅ Fedora 42 (amd64)

## Pre-requisites

### GPU runtime (Optional)

> **Note:** Only Nvidia GPU is supported currently.

Ensure that [Docker](https://docs.docker.com/engine/install/ubuntu/) & [Nvidia Container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) is installed to use the GPU runtime of the container.

# Config

## ROS Version
The target distro could be change via the `ROS_ENV` arguement inside `ros_config` file.

```yaml
    ...
    # === Update config below ===
    ROS_ENV="jazzy"
    ROS_TYPE="desktop"
    ...
```

- `ROS_ENV`: The ROS distro.
- `ROS_TYPE`: The type of ROS installation. `core` consists of the minimum packages to run ROS, whereas `desktop_full` includes most of the core components, perception and simulation packages.

## Workspace
The workspace directory that is attached to the container is defined in the `volumes` section inside `docker-compose.yml` file, which is attached with the following structure: `<host_dir>:<container_dir>`.

```yaml
    ...
    volumes:
      - ./beluga_ws:/home/user/beluga_ws
    ...
```

# Docker

## Running the container

Enter the docker container via the `enter_env` script.
```sh
cd ~/beluga
sudo chmod +x enter_env.sh
./enter_env.sh
```

## Wayland/Fedora specific

> If you are using Wayland and/or Fedora, please do not skip this section as RViz2 may crash upon launching the usual way.

To run RViz2 in docker, there are a few additional steps to be taken.

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
