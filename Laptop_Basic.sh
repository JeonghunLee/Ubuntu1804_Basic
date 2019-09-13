#!/bin/bash 
#
# Lenovo Y540-15IRH LEGION
# Check for installing Ubuntu Package
# 
# BIOS in this latop is not working properly , especially ACIP Part  
# so it's convinient to install Ubuntu system
#
#
# Author: Jeonghun Lee
# https://ahyuo.blogspot.com/search/label/Laptop-Ubuntu
#
# refer to
# - Laptop info
# https://forums.lenovo.com/t5/Gaming-Laptops-Knowledge-Base/Installing-Ubuntu-on-the-Legion-Y530/ta-p/4187251
#
# - How to use Bash Shell 
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# https://ryanstutorials.net/bash-scripting-tutorial/bash-input.php
# 

LAPTOP_NAME=Lenovo_Y540
DATE=$(date)

echo -e "\e[91mStart Checking $LAPTOP_NAME Laptop\e[39m\n"

echo -e "\e[91mPlease check your date/time"
echo -e "\e[39mToday $DATE"


check_CPU() {

   echo -e "\e[91m>>> Checking your CPU $ARCHITECTURE\e[39m"

   ARCHITECTURE=`uname -m`
   if [ "$ARCHITECTURE" != "x86_64" ] && [ "$ARCHITECTURE" != "aarch64" ] ; then
       echo "$LAPTOP_NAME is not supported any more on 32-bit systems."
       exit 1
   else
       echo "Your CPU is $ARCHITECTURE"
   fi

}

check_WIFI() {

   echo -e "\e[91m>>> Checking your WIFI system\e[39m"

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
       echo "WIFI Driver Ok!!"
   fi	   
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
   PRINT=`nvidia-smi`
   echo "$PRINT"
}

check_GraphicCard() {

   echo -e "\e[91m>>> Checking your graphic card like NVIDIA not Intel \e[39m"
  
   CHECK_NVIDIA=/proc/driver/nvidia/version
   CHECK_RTX2060=`lspci -k | grep 1f11`

   if [ -f $CHECK_NVIDIA ]; then
	   
         if [ ${CHECK_RTX2060:0:5} ]; then
	      echo "found NVIDIA RTX2060 (notebook)"
         fi
	 echo "already Installed NVIDIA-Driver Ok"
	 nvidia-smi
         echo "checked NVIDIA graphic card"
   else
	 echo " not installed NVIDIA-Driver"   
	 install_NVIDIA
   fi

}

check_Ubuntu() {

   echo -e "\e[91m>>> Checking your Linux e.g Ubuntu Version\e[39m"

   UBUNTU=`uname -v | grep Ubuntu`

   if [ ${UBUNTU:0:8} ]; then
       VERSION=`lsb_release -sr`
       echo "Check Linux: Ubuntu $VERSION"
   fi 	   
}

check_CPU
check_WIFI
check_GraphicCard
check_Ubuntu

