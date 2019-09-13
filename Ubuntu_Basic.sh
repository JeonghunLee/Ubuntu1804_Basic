#!/bin/bash 
#
# Check for installing Ubuntu Package
# it's convinient to install Ubuntu packages I want 
# 
# 
# Author: Jeonghun Lee
#
# refer to 
# http://tldp.org/LDP/Bash-Beginners-Guide/html/index.html
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
# http://tldp.org/LDP/Bash-Beginners-Guide/html/chap_06.html
# 

VERSION=`lsb_release -sr`
echo -e "\e[91mStart checking Ubuntu $VERSION package \e[39m\n"

update_ubuntu() {

   echo -e "\e[91m>>> check apt update, /etc/apt/sources.list or /etc/apt/sources.list.d \e[39m"
   sudo apt update
   echo -e "\e[91m>>> check apt upgrade \e[39m"
   sudo apt upgrade
}

install_chrome(){

   echo -e "\e[91m>>> check google chrome package \e[39m"

   CHECK_PKG=`dpkg -l | grep google-chrome-stable `
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
	echo "alreadly installed google chrome"
   else
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
        sudo apt-get update
        sudo apt-get install google-chrome-stable
        sudo rm -rf /etc/apt/sources.list.d/google.list
   fi

   echo -e "\e[91m>>> check skype \e[39m"

   CHECK_PKG0=`dpkg -l | grep gdebi-core`
   CHECK_PKG0=`expr length "$CHECK_PKG0"`

   CHECK_PKG1=`dpkg -l | grep skypeforlinux`
   CHECK_PKG1=`expr length "$CHECK_PKG1"`

   if [ ${CHECK_PKG0} -gt 10 ] && [  ${CHECK_PKG1} -gt 10 ]; then
        echo "alreadly installed skype"
   else
        sudo apt install gdebi-core
        wget https://repo.skype.com/latest/skypeforlinux-64.deb
        sudo gdebi skypeforlinux-64.deb
   fi
   
}

install_basic(){

   echo -e "\e[91m>>> check vim/curl/minicom/cheese \e[39m"

   CHECK_PKG=`dpkg -l | grep vim`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
	echo "alreadly installed vim"
   else
        sudo apt install vim
	sudo apt install curl
	sudo apt install minicom
        sudo apt install cheese
   fi

   echo -e "\e[91m>>> check git/smartgit \e[39m"

   CHECK_PKG=`dpkg -l | grep python`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
	echo "alreadly installed git/smartgit"
   else
        sudo apt install git
        sudo apt install smartgit
   fi

   echo -e "\e[91m>>> check python/python3 \e[39m"

   CHECK_PKG=`dpkg -l | grep python`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed python/python3"
   else
        sudo apt install python3-pip
        sudo apt install python-pip
   fi   

   VER=`python2 --version`
   echo  "$VER"
   VER=`python3 --version`
   echo  "$VER"

   echo -e "\e[91m>>> check jupyter notebook for python2/3 \e[39m"

   CHECK_PKG=`pip list | grep notebook`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed jupyter notebook for python2/3"
   else
        sudo pip install notebook
        sudo pip3 install notebook
   fi

}

install_anaconda(){

   echo -e "\e[91m>>> check anaconda for python2/3 \e[39m"
   ID=`whoami`
   CHECK_PKG="/home/$ID/anaconda3"

   if [ -d $CHECK_PKG  ]; then
        echo "alreadly installed Anaconda"
   else
        echo "start downloading Anaconda package $CHECK_PKG"
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
install_anaconda
