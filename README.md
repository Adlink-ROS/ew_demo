# Embedded World Demo

## Preparation

- Hardware
    - Ouster LiDAR
    - Tier4 C1 Camera with driver - [tier4-camera-gmsl_1.1.1_arm64.deb](https://github.com/tier4/tier4_automotive_hdr_camera/releases/tag/v1.1.1)
    - ADLINK RQX-58G with JetPack 4.6 - L4T R32.6.1

- ROS 1 Melodic Environment

    You can simply use [ros_menu](https://github.com/Adlink-ROS/ros_menu) to install ROS.

- Jetson Inference

    Please follow [jetson-inference](https://github.com/Adlink-ROS/ros_deep_learning#jetson-inference) to download and build the environment for Deep Learning. In this demo, we are going to use the **detectnet** of jetson-inference.

- All the other dependencies

    ```bash
    # for ouster lidar
    sudo apt install -y \
        build-essential \
        libeigen3-dev   \
        libjsoncpp-dev  \
        libspdlog-dev   \
        cmake
    ```

## Download

```bash
mkdir -p ~/ew_demo_ws/src
cd ~/ew_demo_ws/src
git clone https://github.com/Adlink-ROS/ew_demo.git
git clone https://github.com/Adlink-ROS/pc_filter_ros.git
git clone https://github.com/Adlink-ROS/ros_deep_learning.git -b ew_demo
git clone https://github.com/Adlink-ROS/cam_lidar_calib.git -b ew_demo
git clone --recurse-submodules https://github.com/Adlink-ROS/ouster-ros.git -b ew_demo
```

## ROS dependent packages

```bash
cd ~/ew_demo_ws
rosdep update
rosdep install --from-paths src --ignore-src -r -y
```

## Build workspace

```bash
cd ~/ew_demo_ws
catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release
# Then, add `source ~/ew_demo_ws/devel/setup.bash` to the .bashrc or ROS Menu
```

## Run calibration script

```bash
# example for camera port1
roslaunch ew_demo calibration.launch port1:=true
```

## Run demo script

```bash
roslaunch ew_demo ew_demo.launch
```
