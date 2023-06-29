#!/bin/bash

# check camera node exist
echo "Checking Tier IV C1 camera nodes..."
ls /dev/gmsl/tier4-isx021-cam1
if [ "$?" != 0 ]; then
	echo "tier4-isx021-cam1 not found"
	exit 2
fi
ls /dev/gmsl/tier4-isx021-cam3
if [ "$?" != 0 ]; then
        echo "tier4-isx021-cam3 not found"
        exit 2
fi
ls /dev/gmsl/tier4-isx021-cam5
if [ "$?" != 0 ]; then
        echo "tier4-isx021-cam5 not found"
        exit 2
fi
ls /dev/gmsl/tier4-isx021-cam7
if [ "$?" != 0 ]; then
        echo "tier4-isx021-cam7 not found"
        exit 2
fi

# check lidar alive
echo "Checking OS1-32 LiDAR is active or not..."
RETRY=5
for ((i=1; i<=$RETRY; i++))
do
	ping os-122226001129.local -c 3 -W 3
	ping_result=$?
	if [ "$ping_result" == 0 ]; then
		echo ""
		echo "LiDAR is active now."
		break
	else
		if [ $i != $RETRY ]; then
			echo "Retry ($i/$RETRY)"
		else
			echo "-----------------------------------------------------------------"
			echo "Error! LiDAR is not active, please check if LiDAR is powered up."
			echo "-----------------------------------------------------------------"
			exit 1
		fi
	fi
done

# restart PTP daemon for lidar to sync with RQX
echo "Enter login password to reset IEEE 1588 (PTP) daemon"
sudo systemctl restart ptp4l
echo "Waiting for IEEE 1588 (PTP) time sync between LiDAR and RQX..."
for i in {1..10};
do
	echo "."
	sleep 1
done

# run demo scripts
roslaunch ew_demo ew_demo.launch
