#!/bin/bash 
#
# Author: Jeonghun Lee
#
#

LAPTOP_NAME=Lenovo_Y540
DATE=$(date)

echo "Today $DATE"
echo "Start Checking $LAPTOP_NAME Laptop"

check_CPU() {

   ARCHITECTURE=`uname -m`
   if [ "$ARCHITECTURE" != "x86_64" ] && [ "$ARCHITECTURE" != "aarch64" ] ; then
       echo "$LAPTOP_NAME is not supported any more on 32-bit systems."
       exit 1
   fi

   echo "-- Checked your CPU $ARCHITECTURE"
}

check_WIFI() {

   CHECK_IDEAPAD=`lsmod | grep ideapad_laptop`
   if [ $CHECK_IDEAPAD ]; then

       echo "Found wrong $CHECK_IDEAPAD module, WIFI is not working "
       BLACKLIST=/etc/modprobe.d/blacklist.conf
  
       REMOVE_IDEAPAD=`sudo rmmod ideapad_laptop`
       CHECK_IDEAPAD=`cat $BLACKLIST | grep ideapad_laptop`

       if [ $CHECK_IDEAPAD]; then
          echo "now already added ideapad_laptop in blacklist.conf"
       else	        
	  if [ -f $BLACKLIST ]; then
              UPDATE=`sudo echo "#for only $LAPTOP_NAME wifi"  >> $BLACKLIST`
              UPDATE=`sudo echo "blacklist ideapad_laptop"     >> $BLACKLIST`
              TEST0=`tail /etc/modprobe.d/blacklist.conf`
	      echo "$TEST0"
	      echo "Updated Blacklist file ok"
          fi 
       fi
   else
       echo "WIFI Driver Ok "
   fi	   
   echo "-- Checked your WIFI Driver "
}


install_NVIDIA(){
   release=`"ubuntu"$(lsb_release -sr | sed -e "s/\.//g")`
   echo $release
   sudo apt install sudo gnupg
   sudo apt-key adv --fetch-keys "http://developer.download.nvidia.com/compute/cuda/repos/"$release"/x86_64/7fa2af80.pub"
   sudo sh -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/'$release'/x86_64 /" > /etc/apt/sources.list.d/nvidia-cuda.list'
   sudo sh -c 'echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/'$release'/x86_64 /" > /etc/apt/sources.list.d/nvidia-machine-learning.list'
   sudo apt update
   sudo apt install nvidia-driver-430 
   nvidia-smi
}

check_GraphicCard() {
  
   CHECK_NVIDIA=/proc/driver/nvidia/version
   CHECK_RTX2060=`lspci -k | grep 1f11`

   if [ -f $CHECK_NVIDIA ]; then
	   
         if [ ${CHECK_RTX2060:0:5} ]; then
	      echo "found NVIDIA RTX2060 (notebook)"
         fi
	 echo "already Installed NVIDIA-Driver Ok"
	 nvidia-smi
   else
	 echo " not installed NVIDIA-Driver"   
	 install_NVIDIA
   fi

   echo "-- Checked NVIDIA Graphic Card Driver "

}

check_Ubuntu() {

   UBUNTU=`uname -v | grep Ubuntu`

   if [ ${UBUNTU:0:8} ]; then
       VERSION=`lsb_release -sr`
       echo "Check Linux: Ubuntu $VERSION"
   fi 	   

   #release="ubuntu"$(lsb_release -sr | sed -e "s/\.//g")
   #echo $UBUNTU
}

check_CPU
check_WIFI
check_GraphicCard
check_Ubuntu

