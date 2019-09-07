#!/bin/bash 
#
# Author: Jeonghun Lee
#
#

LAPTOP_NAME=Lenovo_Y540

echo "Start Checking $LATOP_NAME  Laptop"

checkLaptop() {

   ARCHITECTURE=`uname -m`
   if [ "$ARCHITECTURE" != "x86_64" ] && [ "$ARCHITECTURE" != "aarch64" ] ; then
       echo "$APP_NAME is not supported any more on 32-bit systems."
       exit 1
   fi

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
              UPDATE=`sudo echo "#for only $LAPTOP_NAME wifi " >> $BLACKLIST`
              UPDATE=`sudo echo "blacklist ideapad_laptop"     >> $BLACKLIST`
              TEST0=`tail /etc/modprobe.d/blacklist.conf`
	      echo "$TEST0"
          fi 
       fi
   fi	   

   DISKSIZE=$(df -h)
   echo "$DISKSIZE"
}

checkLinux() {
   DATE=$(date)
   echo $DATE

}

checkLaptop
checkLinux

