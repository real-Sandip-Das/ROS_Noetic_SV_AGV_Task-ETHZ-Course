FROM osrf/ros:noetic-desktop-full

#Installing dependencies of turtlesim3
RUN apt-get update \
  && apt-get install -y ros-noetic-joy ros-noetic-teleop-twist-joy \
  ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
  ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
  ros-noetic-rosserial-python ros-noetic-rosserial-client \
  ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
  ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
  ros-noetic-compressed-image-transport ros-noetic-rqt* ros-noetic-rviz \
  ros-noetic-gmapping ros-noetic-navigation ros-noetic-interactive-markers \
  && rm -rf /var/lib/apt/lists/*
#Installing turtlebot3 via Debian Packages
RUN apt-get update \
  && apt-get -y install ros-noetic-dynamixel-sdk \
  && apt-get -y install ros-noetic-turtlebot3-msgs \
  && apt-get -y install ros-noetic-turtlebot3 \
  && rm -rf /var/lib/apt/lists/*

#A few other utilities
RUN apt-get update \
  && apt-get install -y \
  nano \
  vim \
  tmux \
  bash-completion \
  python3-argcomplete \
  && rm -rf /var/lib/apt/lists/*

#TODO:change it to USERNAME=ros
ARG USERNAME=anonub
ARG USER_UID=1000
ARG USER_GID=$USER_UID

#Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

#Copying custom configurations
COPY /config /site_config/

#setting up an entrypoint and bashrc
COPY entrypoint.sh /entrypoint.sh
COPY .bashrc /home/${USERNAME}/.bashrc

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["bash"]
