#include <ros/ros.h>
#include <sensor_msgs/Image.h>

#include <cstdio>
#include <cstdlib>
#include <signal.h>
#include <sys/types.h>

int main(int argc, char **argv)
{
    ros::init(argc, argv, "reset_camera");
    ros::NodeHandle nh("~");
    
    int index;
    nh.param<int>("index", index, 0);
    std::string image_in_topic = "/port_" + std::to_string(index) + "/camera/image_raw";

    double timeout = 2.0;
    sensor_msgs::ImageConstPtr msg = ros::topic::waitForMessage<sensor_msgs::Image>(image_in_topic, ros::Duration(timeout));
    if (msg)
    {
        ROS_INFO("Images are received for topic %s", image_in_topic.c_str());
    }
    else
    {
        ROS_WARN("Timed out! No image received for topic %s", image_in_topic.c_str());
        
        int ret;
        std::string cmd = "ps x | grep 'port_" + std::to_string(index) + "-gscam' | awk '{print $1}'";
        FILE *fp = popen(cmd.c_str(), "r");
        
        std::vector<std::string> result;
        while (!feof(fp)) {
            char buf[256] = {0};
            if (fgets(buf, sizeof(buf), fp) > 0) {
                result.push_back(std::string(buf));
            }
        }
        pclose(fp);
        
        // send SIGTEM for the process
        ROS_WARN("Send signal to restart the camera port-%d", index);
        for (auto i = 0; i < result.size(); ++i) {
            pid_t _pid = std::stoi(result[i]);
            kill(_pid, SIGTERM);
        }
    }

    return 0;
}
