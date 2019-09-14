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
##  EXAMPLE OF DOCKER USE IN DGX-1

VERSION=`lsb_release -sr`
echo -e "\e[91mStart checking Ubuntu $VERSION package \e[39m\n"
echo -e "\e[91mplease execute Ubuntu_Basic.sh before this program \e[39m\n"


INSTALL_NVIDIA_DOCKER2(){

# - https://github.com/NVIDIA/nvidia-docker
# - https://forums.docker.com/t/unit-docker-service-not-found/75817

   CHECK_PKG=`dpkg -l | grep nvidia-container-toolkit`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
        echo "alreadly installed NVIDIA Docker2"
   else
        #remove NVIDIA Docker version1 if have 
        echo "remove NVIDIA Docker version 1"
        docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
        sudo apt-get purge nvidia-docker
        #install NVIDIA Docker Version2 	
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



PULL_NVIDIA_TENSORRT(){

##
# - https://ngc.nvidia.com/catalog/containers/nvidia:tensorrt
##

   CHECK_PKG=`sudo docker images | grep nvidia/cuda | awk '{ print $1 }' `
   VERSION=`sudo docker images | grep nvidia/cuda | awk '{ print $2 }' `

   if [ ${CHECK_PKG} == "nvidia/cuda" ] && [ ${VERSION} == "10.1-devel" ]    ; then
        echo "alreadly have TENSORRT image"
   else
        echo "start to pull TENSORRT image"
        #sudo docker pull nvcr.io/nvidia/tensorrt:19.08-py2
        sudo docker pull nvcr.io/nvidia/tensorrt:19.08-py3
   fi
}


# transfer learning toolkit
# - https://ngc.nvidia.com/catalog/containers/nvidia:tlt-streamanalytics

PULL_NVIDIA_DEEPSTREAM(){

##
# - https://ngc.nvidia.com/catalog/containers/nvidia:deepstream
##

   CHECK_PKG=`sudo docker images | grep nvidia/cuda | awk '{ print $1 }' `
   VERSION=`sudo docker images | grep nvidia/cuda | awk '{ print $2 }' `

   if [ ${CHECK_PKG} == "nvidia/cuda" ] && [ ${VERSION} == "10.1-devel" ]    ; then
        echo "alreadly have DEEPSTREAM image"
   else
        echo "start to pull DEEPSTREAM image"
        sudo docker pull nvcr.io/nvidia/deepstream-l4t:4.0-19.07
   fi
}


PULL_NVIDIA_TENSORFLOW(){

##
# - https://ngc.nvidia.com/catalog/containers/nvidia:tensorflow
##

   CHECK_PKG=`sudo docker images | grep tensorflow | awk '{ print $1 }' `
   VERSION=`sudo docker images | grep tensorflow | awk '{ print $2 }' `

   if [ ${CHECK_PKG} == "nvcr.io/nvidia/tensorflow" ] && [ ${VERSION} == "19.08-py3" ]    ; then
        echo "alreadly have Tensorflow image"
   else
        echo "start to pull Tensorflow image"
        sudo docker pull nvcr.io/nvidia/tensorflow:19.08-py3
   fi

   INFO=`sudo docker inspect nvcr.io/nvidia/tensorflow:19.08-py`
   echo "$INFO"

}



####
#
### CUDA/CUDNN
#
# - https://github.com/NVIDIA/nvidia-docker/wiki/CUDA
# - https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html
# - https://ngc.nvidia.com/catalog/containers/nvidia:cuda
#
####


PULL_NVIDIA_CUDA(){

   CHECK_PKG=`sudo docker images | grep cuda | awk '{ print $1 }' `
   VERSION=`sudo docker images | grep cuda | awk '{ print $2 }' `

   if [ ${CHECK_PKG} == "nvidia/cuda" ] && [ ${VERSION} == "10.1-devel" ]    ; then
        echo "alreadly have NVIDIA Docker image"
   else
        echo "start to pull CUDA 10.1 devel image"
	sudo docker pull nvcr.io/nvidia/cuda:10.1-devel-ubuntu18.04
   fi
}


PULL_NVIDIA_CUDNN(){

   CHECK_PKG=`sudo docker images | grep cuda | awk '{ print $1 }' `
   VERSION=`sudo docker images | grep cuda | awk '{ print $2 }' `

   if [ ${CHECK_PKG} == "nvidia/cuda" ] && [ ${VERSION} == "10.1-devel" ]    ; then
        echo "alreadly have NVIDIA Docker image"
   else
        echo "start to pull Docker CUDNN 10.1 devel image"
        sudo docker pull nvcr.io/nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
   fi
}


PULL_NVIDIA_DOCKERS(){

    echo -e "\e[91m>>> Do you want to check Ubuntu default packages \nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       bash Ubuntu_Basic.sh 
    fi

    echo -e "\e[91m>>> Do you want to install NVIDIA Docker 2?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       INSTALL_NVIDIA_DOCKER2
    fi

    echo -e "\e[91m>>> Do you want to pull NVIDIA CUDA Docker Image\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       PULL_NVIDIA_CUDA
    fi

    echo -e "\e[91m>>> Do you want to pull NVIDIA CUDNN Docker Image\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       PULL_NVIDIA_CUDNN
    fi

    echo -e "\e[91m>>> Do you want to pull Tensorflow Docker Image\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       PULL_NVIDIA_TENSORFLOW
    fi

    echo -e "\e[91m>>> Do you want to pull TENSORRT Docker Image\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       PULL_NVIDIA_TENSORRT
    fi

    echo -e "\e[91m>>> Do you want to pull DEEPSTREAM Docker Image\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       PULL_NVIDIA_DEEPSTREAM
    fi
    
}

RUN_NVIDIA_DOCKERS(){

    echo -e "\e[91m>>> Do you want to run NVIDIA CUDA/cuDNN\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
         nvidia-docker run --rm -ti –u $(id –u):$(id –g) --name cuda nvcr.io/nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04 nvidia-smi
    fi

    echo -e "\e[91m>>> Do you want to run Tensorflow\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
         nvidia-docker run --rm -ti –u $(id –u):$(id –g) --name tensorflow -p 8888:8888 -p 6006:6006 -v $(pwd):/workspace \
    fi

}



CHECK_NVIDIA_SDK(){

    echo -e "\e[91m>>> Do you want to install NVIDIA DOCKER \nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       PULL_NVIDIA_DOCKERS
    fi

    echo -e "\e[91m>>> Do you want to run NVIDIA DOCKER \nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       RUN_NVIDIA_DOCKERS
    fi    

    CHECK=`sudo docker ps -a`
    echo "Check Docker Containter $CHECK"

    CHECK=`sudo docker images`
    echo "Check Docker Images $CHECK"
    

}



CHECK_NVIDIA_SDK

echo -e "\e[91m>>> finished chekcing NVIDIA SDK packages for x86 \e[39m"

