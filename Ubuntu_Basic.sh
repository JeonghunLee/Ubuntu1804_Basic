#!/bin/bash 
#
# Check for installing Ubuntu Package
# it's convinient to install Ubuntu packages I want 
# 
# 
# Author  : Jeonghun Lee
# Version : 0.1
#
# Refer to 
# 
# How to use Bash Shell Script
# - http://tldp.org/LDP/Bash-Beginners-Guide/html/index.html
#
# if syntenx in Bash Shell script 
# - http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
#
# Gawk/awk
# - http://tldp.org/LDP/Bash-Beginners-Guide/html/chap_06.html
#
# SED 
# - http://www.yourownlinux.com/2015/04/sed-command-in-linux-append-and-insert-lines-to-file.html
#  /etc/pulse/default.pa 

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

   echo -e "\e[91m>>> check skype package not use snap \e[39m"

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

   echo -e "\e[91m>>> check vim/curl/build-essential/minicom/cheese \e[39m"

   CHECK_PKG=`dpkg -l | grep vim`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
	echo "alreadly installed vim and others "
   else
        sudo apt install vim
        sudo apt install build-essential
	sudo apt install curl
	sudo apt install minicom
        sudo apt install cheese
   fi

   echo -e "\e[91m>>> check git/smartgit package \e[39m"

   CHECK_PKG=`dpkg -l | grep smartgit`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
	echo "alreadly installed git/smartgit"
   else
        sudo apt install git
        sudo apt install smartgit
   fi

   echo -e "\e[91m>>> check echo cancel function in Audio \e[39m"


# not used this 
# mouse problem   
# https://ubuntuforums.org/showthread.php?t=2410517
# sudo update-alternatives --config x-cursor-theme
# 
#   Selection    Path                                     Priority   Status
#------------------------------------------------------------
#* 0            /usr/share/icons/DMZ-White/cursor.theme   100       auto mode
#  1            /etc/X11/cursors/core.theme               30        manual mode
#  2            /etc/X11/cursors/handhelds.theme          20        manual mode
#  3            /etc/X11/cursors/redglass.theme           20        manual mode
#  4            /etc/X11/cursors/whiteglass.theme         20        manual mode
#  5            /usr/share/icons/Adwaita/cursor.theme     90        manual mode
#  6            /usr/share/icons/DMZ-Black/cursor.theme   30        manual mode
#  7            /usr/share/icons/DMZ-White/cursor.theme   100       manual mod
#
# vi ~/.Xresources
# Xcursor.size: 48
# 
# only install this package below 
# https://itsfoss.com/fix-right-click-touchpad-ubuntu/
# sudo apt install gnome-tweaks




#  Echo Cancel Function    
# - https://www.youtube.com/watch?v=gKsBAEnVxEA
# 

   CHECK_PKG=`grep -e "module-echo-cancel" /etc/pulse/default.pa`
   CHECK_PKG=`expr length "$CHECK_PKG"`
   
   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "already added echo cancle function into /etc/pulse/default.pa"
   else	
        sudo sed -i '/load-module module-filter-apply/ a load-module module-echo-cancel' /etc/pulse/default.pa
   fi


   echo -e "\e[91m>>> check snap package \e[39m"

####
#   
## How to use SNAP Package
#
# - https://itsfoss.com/use-snap-packages-ubuntu-16-04/
# - https://snapcraft.io/
# - https://tutorials.ubuntu.com/tutorial/basic-snap-usage
#
####

   CHECK_PKG=`dpkg -l | grep snapd`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed snap"
   else
        sudo apt install snapd
   fi

   echo -e "\e[91m>>> check docker package \e[39m"

   

####
#
## 2 Ways how to Install docker e.g apt,snap , not used snap version  
# 
# - https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
# - https://www.unixtutorial.org/how-to-install-docker-in-ubuntu-using-snap   
# - https://www.unixtutorial.org/install-docker-in-linux-mint-19-1   
#
####

 
   CHECK_PKG=`snap list | grep docker`
   CHECK_PKG=`expr length "$CHECK_PKG"`
  
   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed docker by using snap "
        echo "try to remove docker in snap packages"
        sudo snap remove docker
   fi

   CHECK_PKG=`dpkg -l | grep docker`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10 ]; then
        echo "alreadly installed docker by dpkg"
   else
        sudo apt install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
        sudo apt update
        READ=`apt-cache policy docker-ce`
        echo -e "$READ"	
        sudo apt install docker-ce
	READ=`sudo systemctl status docker`
        echo -e "$READ"	
   fi
}

install_python(){

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
	
   echo -e "\e[91m>>> check anaconda for python2/3 \e[39m"
   ID=`whoami`
   CHECK_PKG="/home/$ID/anaconda3"

   if [ -d $CHECK_PKG  ]; then
        echo "alreadly installed Anaconda"
   else
        echo "start downloading Anaconda package"
        wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
        CHECKSUM=`mdsum Anaconda3-2019.07-Linux-x86_64.sh`
        if [ CHECKSUM -eq "63f63df5ffedf3dbbe8bbf3f56897e07"]; then
               echo " try to install"
	fi
   fi

}



install_virtualbox(){


####	
#
## How To install VirtualBox 6.0 
#
# - https://tecadmin.net/install-virtualbox-on-ubuntu-18-04/
# - https://www.linuxtechi.com/install-virtualbox6-ubuntu-18-04-centos-7/
####

   CHECK_PKG=`dpkg -l | grep virtualbox`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
        echo "alreadly installed virtualbox 6.0"
   else
        echo "Start setting for virtualbox 6.0"
        ADD_KEY=`wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -`
	ADD_KEY=`wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -`
        #sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
	sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
	sudo apt update
	echo "Start installing virtualbox 6.0 "
	sudo apt install virtualbox-6.0 -y
	echo "Start installing virtualbox 6.0 Extension Pack "
	wget https://download.virtualbox.org/virtualbox/6.0.0/Oracle_VM_VirtualBox_Extension_Pack-6.0.0.vbox-extpack
	sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.0.0.vbox-extpack
        TEST=`sudo VBoxManage list extpacks`
	echo "$TEST"
	sudo usermod -a -G vboxusers $USER
	sudo usermod -a -G vboxsf "$USER"
        #
	# https://blogger.pe.kr/523
	# /lib/udev/rules.d/50-udev-default.rules
	# libusb device nodes  644->666
        # SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0666"
	# 

   fi

   VERSION=`dpkg -l | grep virtualbox | awk '{ print $2 }'`
   echo "$VERSION"


}

install_pycharm(){

####    
#
## How To install pyCharm IDE
#
# - https://linuxize.com/post/how-to-install-pycharm-on-ubuntu-18-04/
#
####

   CHECK_PKG=`snap list | grep pycharm-community`
   CHECK_PKG=`expr length "$CHECK_PKG"`

   if [ ${CHECK_PKG} -gt 10  ]; then
        echo "alreadly installed pycharm-communnity"
   else
        echo "start installing pycharm-community "
	sudo snap install pycharm-community --classic
   fi

   VERSION=`snap list | grep pycharm-community | awk '{ print $1 " " $2 }'`
   echo "$VERSION"
      
}



install_option(){

    echo -e "\e[91m>>> Do you want to install virtualbox 6.0?\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       install_virtualbox
    fi

    echo -e "\e[91m>>> Do you want to install pycharm\nYes or No (y/n) \e[39m"
    read ANS
    if [ $ANS == "y" ] || [ $ANS == "Y" ]; then
       install_pycharm
    fi

}



update_ubuntu
install_chrome
install_basic
install_python
install_option

echo -e "\e[91m>>> finished chekcing ubuntu packages \e[39m"

