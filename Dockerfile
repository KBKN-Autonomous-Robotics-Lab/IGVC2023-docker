FROM tiryoh/ros-desktop-vnc:noetic
 

ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND noninteractive
ENV ROS_PYTHON_VERSION 3
ENV ROS_DISTRO=noetic
ENV PYTHONPATH="$PYTHONPATH:$HOME/.local/lib/python3.8/site-packages"


SHELL ["/bin/bash", "-c"]


EXPOSE 22 
EXPOSE 10940
EXPOSE 2368/udp
EXPOSE 8308/udp


RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

 
RUN apt-get autoclean -y && \
    apt-get clean all -y && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    dkms \
    openssh-server && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd && \
    echo 'root:ubuntu' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd 


COPY ./startup.sh /startup.sh

# ^ It is not recommended to edit above this line. 

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    python3-pip \
    python3-testresources \
    gedit \
    gimp \
    ros-noetic-rosserial \
    ros-noetic-rosserial-arduino \
    ros-noetic-urg-node \
    ros-noetic-joy \
    ros-noetic-teleop-twist-joy \
    ros-noetic-robot-pose-ekf \
    ros-noetic-tf2-sensor-msgs \
    ros-noetic-move-base-msgs \
    ros-noetic-velodyne-gazebo-plugins \
    libsdl1.2-dev \
    libsdl-image1.2-dev \
    libpcap-dev 
    
   
RUN apt-get update && \
    apt-get upgrade -y && \
    mkdir -p /home/ubuntu/catkin_ws/src && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash ; cd /home/ubuntu/catkin_ws/src ; catkin_init_workspace" && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash ; cd /home/ubuntu/catkin_ws ; catkin build" && \
    cd /home/ubuntu/catkin_ws/src && \
    git clone https://github.com/KBKN-Autonomous-Robotics-Lab/IGVC2023-src.git && \
    rm IGVC2023-src/CMakeLists.txt && \
    mv IGVC2023-src/* . && \mv IGVC2023-src/.git* . && \
    rm -rf IGVC2023-src && \
    chown -R $USER:$USER $HOME && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash ; cd /home/ubuntu/catkin_ws ; catkin build" && \
    echo "source /home/ubuntu/catkin_ws/devel/setup.bash" >> ~/.bashrc && \
    echo "export ROS_WORKSPACE=/home/ubuntu/catkin_ws" >> ~/.bashrc && \
    echo "alias cm='cd ~/catkin_ws;catkin build'" >> ~/.bashrc && \
    echo "alias cs='cd ~/catkin_ws/src'" >> ~/.bashrc && \
    echo "alias cw='cd ~/catkin_ws'" >> ~/.bashrc && \
    echo "alias start='roslaunch tsukuba2022 start.launch'" >> ~/.bashrc && \
    echo "alias start_sim='roslaunch tsukuba2022 start_sim.launch'" >> ~/.bashrc && \
    echo "alias buildmap='roslaunch tsukuba2022 buildmap_teleop_joy.launch'" >> ~/.bashrc && \
    echo "alias savemap='rosrun map_server map_saver -f ~/catkin_ws/src/tsukuba2022/maps/mymap && bash ~/catkin_ws/src/tsukuba2022/scripts/rename.sh'" >> ~/.bashrc && \
    echo "alias navigation='roslaunch tsukuba2022 waypoint_navigation.launch'" >> ~/.bashrc && \
    echo "alias waypoint_manager='python ~/catkin_ws/src/waypoint_navigation/waypoint_manager/scripts/manager_GUI.py'" >> ~/.bashrc && \
    echo "alias map_merger='python ~/catkin_ws/src/multi_map_manager/apps/map_merger.py'" >> ~/.bashrc && \
    echo "alias map_trimmer='python ~/catkin_ws/src/multi_map_manager/apps/map_trimmer.py'" >> ~/.bashrc


RUN python3 -m pip install --user --upgrade --no-cache-dir --no-warn-script-location pip && \
    python3 -m pip install --user --upgrade --no-cache-dir --no-warn-script-location \
    pymodbus \
    numpy-quaternion \
    ruamel.yaml \
    Pillow && \
    chown -R $USER:$USER $HOME/.local/