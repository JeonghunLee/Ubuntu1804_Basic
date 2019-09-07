#!/bin/bash 
#
# Author: Jeonghun Lee
#
#

LAPTOP_NAME=Lenovo_Y540
DATE=$(date)

echo $DATE
echo "Start Checking $LAPTOP_NAME Laptop"

checkLaptop() {


   ARCHITECTURE=`uname -m`
   if [ "$ARCHITECTURE" != "x86_64" ] && [ "$ARCHITECTURE" != "aarch64" ] ; then
       echo "$APP_NAME is not supported any more on 32-bit systems."
       exit 1
   fi

   echo "Checked your CPU $ARCHITECTURE "



   CHECK_IDEAPAD=`lsmod | grep ideapad_laptop`
   if [ $CHECK_IDEAPAD ]; then

       echo "found wrong $CHECK_IDEAPAD module "
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
   echo "Checked your WIFI Driver "


}

checkLinux() {

   UBUNTU=`uname -v | grep Ubuntu`

   if [ ${UBUNTU:0:8} ]; then
       VERSION=`lsb_release -sr`
       echo "Check Linux: Ubuntu $VERSION"
   fi 	   

   #release="ubuntu"$(lsb_release -sr | sed -e "s/\.//g")
   #echo $UBUNTU
}

checkLaptop
checkLinux

