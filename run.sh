docker run \
	-p 6080:80 \
	-p 2222:22 \
	-p 10940:10940 \
	-p 2368:2368/udp \
	-p 8308:8308/udp \
	-e HOME=/home/ubuntu \
	-e SHELL=/bin/bash \
	--shm-size=512m \
	--entrypoint '/startup.sh' \
	--device /dev/ZLAC8015D:/dev/ZLAC8015D:mwr \
	--device /dev/sensors/imu:/dev/sensors/imu:mwr \
	--device /dev/sensors/insta360_air:/dev/sensors/insta360_air:mwr \
	--device /dev/input/js0:/dev/input/js0:mwr \
	--device /dev/sensors/CLAS:/dev/sensors/CLAS:mwr \
	--device /dev/sensors/GNSSbase:/dev/sensors/GNSSbase:mwr \
	--device /dev/sensors/GNSSrover:/dev/sensors/GNSSrover:mwr \
	--device /dev/sensors/LED:/dev/sensors/LED:mwr \
	igvc2023
	
	#-e RESOLUTION=1920x1080
	#--device /dev/E-Stop:/dev/E-Stop:mwr \
	#--device /dev/sensors/hokuyo_urg:/dev/sensors/hokuyo_urg:mwr \
