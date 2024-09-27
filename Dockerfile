ARG ROS_ENV="humble"
FROM nvidia/cudagl:11.3.0-devel
FROM osrf/ros:${ROS_ENV}-desktop

RUN apt update && apt install -y vim tmux gdb wget git cmake python3-pip curl iputils-ping htop && rm -rf /var/lib/apt/lists/*		# Install Tools
RUN apt update && apt install -y python3-colcon-common-extensions python3-vcstool && rm -rf /var/lib/apt/lists/*			# Install ROS specific tools
RUN apt update && apt install -y lsb-release gnupg ros-${ROS_DISTRO}-ros-ign-bridge && rm -rf /var/lib/apt/lists/*	                # Prep gazebo install

# Setup Gazebo Harmonic
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN apt update && apt-get install gz-harmonic -y && rm -rf /var/lib/apt/lists/*

# Add user
ENV USERNAME user
RUN useradd -s /bin/bash -m -G sudo $USERNAME && echo "$USERNAME:$USERNAME" | chpasswd
USER $USERNAME

# Add to bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
WORKDIR /home/$USERNAME

# Clone gazebo models for faster loading, comment section if not needed
#RUN cd ~/. && git clone https://github.com/osrf/gazebo_models --progress
#RUN mkdir -p ~/.gazebo/models
#RUN cd gazebo_models && cp -r ./* ~/.gazebo/models/.

