# RLLIB SUMO Docker environment for Windows


Step by step configuration and use:

1. install docker for windows

(https://hub.docker.com/editions/community/docker-ce-desktop-windows/)

2. install VcXsrv Windows X Server (https://sourceforge.net/projects/vcxsrv/files/latest/download)

(follow steps from https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde)

3. build the docker image using the docker cmd bash script

`./docker-cmd.sh -n=marl-parking-devel -b -c -r`

4. use the following command line: to set up VcXsrv:

`set-variable -name DISPLAY -value 192.168.xx.xx:0.0`

(/!\ replace "192.168.xx.xx" with your ip you can obtain using ipconfig command line)

5. use the following command line to run your docker image:

(of course replace "GroupID, UserID and FolderPath" accordingly

`docker run -u GroupID:UserID --net=host --privileged -v /c/FolderPath/MARL-Parking/rllibsumodocker/learning:/home/alice/learning -v /c/FolderPath/MARL-Parking/rllibsumodocker/devel:/home/alice/devel -it --rm -e DISPLAY=$DISPLAY marl-parking-devel:latest /bin/bash`