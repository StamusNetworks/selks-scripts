#!/bin/bash

# Copyright(C) 2014, Stamus Networks
# All rights reserved
# Part of Debian SELKS scripts
# Written by Peter Manev <pmanev@stamus-networks.com>
#
# Please run on Debian
#
# This script comes with ABSOLUTELY NO WARRANTY!
# 
#Tested using - http://www.webupd8.org/2012/06/how-to-install-oracle-java-7-in-debian.html
#


echo -e "##########################"
echo -e "# SETTING UP ORACLE JAVA #"
echo -e "##########################"

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update

# to automatically accept the ORACLE license (no user input needed)
#echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y oracle-java8-installer
apt-get install -y oracle-java8-set-default

echo -e "###############################"
echo -e "# RUNNING ORACLE JAVA VERSION # ==>"
echo -e "###############################"

/usr/bin/java -version
