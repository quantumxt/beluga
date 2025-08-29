FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

ARG ROS_ENV="placeholder"
ENV ROS_ENV=${ROS_ENV}
ENV PKG_FILE="docker/packages.txt"

RUN apt update && apt install -y software-properties-common && add-apt-repository universe && rm -rf /var/lib/apt/lists/*
COPY $PKG_FILE .
RUN echo -n "The following packages would be installed: [" && \
    grep -vE '^\s*($|#)' $PKG_FILE | paste -sd, - | tr -d '\n' && \
    echo "]"
RUN apt update && grep -vE '^\s*($|#)' $PKG_FILE | xargs apt install -y && \
    rm $PKG_FILE && rm -rf /var/lib/apt/lists/*

RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && echo ">>>> ROS_APT_SOURCE_VERSION = {$ROS_APT_SOURCE_VERSION}" && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME
RUN apt install /tmp/ros2-apt-source.deb

# Dev tools
RUN apt update && apt install -y ros-dev-tools && rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y ros-${ROS_ENV}-desktop && rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y ros-${ROS_ENV}-ros-gz && rm -rf /var/lib/apt/lists/*

RUN userdel -r ubuntu

# Add user
ARG UID=1000
ARG GID=1000
ENV USERNAME user
RUN groupadd -g $GID $USERNAME && \
    useradd -s /bin/bash -m -u $UID -g $GID -G sudo $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME

WORKDIR /home/$USERNAME
RUN echo "source /opt/ros/${ROS_ENV}/setup.bash" >> .bashrc

# Clone gazebo models for faster loading, comment section if not needed
#RUN cd ~/. && git clone https://github.com/osrf/gazebo_models --progress
#RUN mkdir -p ~/.gazebo/models
#RUN cd gazebo_models && cp -r ./* ~/.gazebo/models/.
