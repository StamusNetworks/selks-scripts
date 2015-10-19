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
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


echo -e "##########################"
echo -e "# SETTING UP ORACLE JAVA #"
echo -e "##########################"


echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get update

# to automatically accept the ORACLE license (no user input needed)
#echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install oracle-java8-installer libc6-dev 

if [ $? -eq 0 ];
then
    echo "Restarting Elasticsearch service after Java upgrade!"
    /etc/init.d/elasticsearch restart
    
    sleep 5
    
    echo "Restarting Logstash service after Java upgrade!"
    /etc/init.d/logstash restart
fi

echo -e "###############################"
echo -e "# RUNNING ORACLE JAVA VERSION # ==>"
echo -e "###############################"

/usr/bin/java -version
