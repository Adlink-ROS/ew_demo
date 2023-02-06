cmake_minimum_required(VERSION 2.8.3)
project(ew_demo)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(catkin REQUIRED COMPONENTS roscpp sensor_msgs)

catkin_package(
  CATKIN_DEPENDS roscpp sensor_msgs
)

include_directories(${catkin_INCLUDE_DIRS})

add_executable(reset_camera src/reset_camera.cpp)
target_link_libraries(reset_camera ${catkin_LIBRARIES})
