#!/bin/bash 
#
# Author: Jeonghun Lee
#
#


update_ubuntu() {

   echo "--Start APT UPDATE"
   sudo apt update
   echo "--Start APT UPGRADE"
   sudo apt upgrade
}

install_chrome(){
   CHECK_PKG=`dpkg -l | grep google-chrome-stable `
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
	echo "---- alreadly installed google chrome"
   else
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
        sudo apt-get update
        sudo apt-get install google-chrome-stable
        sudo rm -rf /etc/apt/sources.list.d/google.list
   fi
}

install_basic(){

   CHECK_PKG=`dpkg -l | grep vim`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
	echo "---- alreadly installed vim"
   else
        sudo apt install vim
	sudo apt install curl
	sudo apt install minicom
        sudo apt install cheese
   fi

   CHECK_PKG=`dpkg -l | grep python`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
	echo "---- alreadly installed cheese"
   else
        sudo apt install git
        sudo apt install smartgit
        sudo apt install python3-pip
        sudo apt install python-pip
        sudo pip install notebook	
        sudo pip3 install notebook	
   fi
}

install_anaconda(){

   CHECK_PKG=`dpkg -l | grep vim`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "---- alreadly installed Anaconda"
   else
        wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
        CHECKSUM=`mdsum Anaconda3-2019.07-Linux-x86_64.sh`
        if [ CHECKSUM -eq "63f63df5ffedf3dbbe8bbf3f56897e07"]; then
               echo " try to install"
	fi


   fi




}



update_ubuntu
install_chrome
install_basic
