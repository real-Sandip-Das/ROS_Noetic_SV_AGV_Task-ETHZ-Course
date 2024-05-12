#TODO: add the --rm flag after completion of work
#TODO: change it to --user ros
docker run -it --user anonub --env="DISPLAY" --network=host \
    --ipc=host --device=/dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v ./Tasks:/home/ros/Tasks/ --name agv_ros_noetic_container agv_ros_noetic_try1 
