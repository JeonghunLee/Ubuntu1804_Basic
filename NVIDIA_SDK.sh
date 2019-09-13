#!/bin/bash 
#
# Check for installing NVIDIA SDK Package
# it's convinient to install NVIDIA SDK Package 
# 
# 
# Author  : Jeonghun Lee
# Version : 0.1
#
# Refer to 
# 
# How to use NVIDIA SDK
# - https://medium.com/@sh.tsang/docker-tutorial-5-nvidia-docker-2-0-installation-in-ubuntu-18-04-cb80f17cac65
# - https://github.com/NVIDIA/nvidia-docker

# - https://github.com/nvidia/nvidia-container-runtime
# - https://www.nvidia.co.kr/content/apac/event/kr/deep-learning-day-2017/dli-1/Docker-User-Guide-17-08_v1_NOV01_Joshpark.pdf
# - https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow
 

VERSION=`lsb_release -sr`
echo -e "\e[91mStart checking Ubuntu $VERSION package \e[39m\n"
echo -e "\e[91mplease execute Ubuntu_Basic.sh before this program \e[39m\n"


install_NVIDIA_docker2(){

## https://github.com/NVIDIA/nvidia-docker
## https://forums.docker.com/t/unit-docker-service-not-found/75817

   CHECK_PKG=`dpkg -l | grep nvidia-container-toolkit`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
        echo "alreadly installed NVIDIA Docker"
   else

        echo "remove NVIDIA Docker version 1"
        docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
        sudo apt-get purge nvidia-docker	   
        echo "start installing NVIDIA Docker Version 2"
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
        sudo systemctl restart docker

        sudo apt-get install nvidia-docker2
        sudo pkill -SIGHUP dockerd
   fi 
}


## https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow

## https://ngc.nvidia.com/catalog/containers/nvidia:deepstream


install_NVIDIA_CUDA(){

#https://ngc.nvidia.com/catalog/containers/nvidia:cuda

   CHECK_PKG=`dpkg -l | grep nvidia-container-toolkit`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
        echo "alreadly installed NVIDIA Docker"
   else

        echo "remove NVIDIA Docker version 1"
        docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
        sudo apt-get purge nvidia-docker
        echo "start installing NVIDIA Docker Version 2"
        distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
        curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
        sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
        sudo systemctl restart docker

        sudo apt-get install nvidia-docker2
        sudo pkill -SIGHUP dockerd
   fi
}



install_option(){
    echo -e "\e[91m>>> Do you want to check Ubuntu default packages \nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       bash Ubuntu_Basic.sh 
    fi

    echo -e "\e[91m>>> Do you want to install NVIDIA Docker 2?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       install_NVIDIA_docker2
    fi

    echo -e "\e[91m>>> Do you want to install pycharm\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       install_pycharm
    fi

}


install_option

echo -e "\e[91m>>> finished chekcing NVIDIA SDK packages for x86 \e[39m"

