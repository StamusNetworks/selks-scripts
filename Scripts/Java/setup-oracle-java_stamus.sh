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
# Tested using - http://www.webupd8.org/2012/06/how-to-install-oracle-java-7-in-debian.html
# As per Elasticsearch recommendation -
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup.html


echo -e "##########################"
echo -e "# SETTING UP ORACLE JAVA #"
echo -e "##########################"

if ps aux | grep -v grep | grep elasticsearch |grep java > /dev/null 
then
    echo "Elasticsearch running - stopping before Java install!"
    ES_WAS_RUNNING=0
    /etc/init.d/elasticsearch stop
fi

if ps aux | grep -v grep | grep logstash |grep java > /dev/null 
then
    echo "Logstash running - stopping before Java install!"
    LG_WAS_RUNNING=0
    /etc/init.d/logstash stop
fi


echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update

# to automatically accept the ORACLE license (no user input needed)
#echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install  oracle-java7-installer
apt-get install  oracle-java7-set-default

if [ ${ES_WAS_RUNNING} -eq 0 ]; 
then
    echo "Starting up previously stopped Elasticsearch service after Java upgrade!"
    /etc/init.d/elasticsearch start
    ES_WAS_RUNNING=999
fi

sleep 5

if [ ${LG_WAS_RUNNING} -eq 0 ]; 
then
    echo "Starting up previously stopped Logstash service after Java upgrade!"
    /etc/init.d/logstash start
    LG_WAS_RUNNING=999
fi

echo -e "###############################"
echo -e "# RUNNING ORACLE JAVA VERSION # ==>"
echo -e "###############################"

/usr/bin/java -version

