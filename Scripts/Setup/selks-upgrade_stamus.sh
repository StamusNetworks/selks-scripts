#!/bin/bash

# Copyright(C) 2017, Stamus Networks
# All rights reserved
# Part of Debian SELKS scripts
# Written by Peter Manev <pmanev@stamus-networks.com>
#
# Please run on Debian
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

if (( $EUID != 0 )); then
     echo -e "Please run this script as root or with \"sudo\".\n"
     exit 1
fi

echo -e "\e[1mNOTE:"
echo -e "\e[1mDepending on the size and how busy the system is the upgrade may take a while."
echo -e "\e[1mStarting the upgrade sequence..."
echo -e "\e[0m"

/bin/systemctl stop kibana

if [ "`/bin/systemctl is-active molochviewer-selks`" != "active" ] 
then
  /bin/systemctl stop molochviewer-selks
fi

if [ "`/bin/systemctl is-active molochpcapread-selks`" != "active" ] 
then 
  /bin/systemctl stop molochpcapread-selks
fi 

apt-get update && apt-get dist-upgrade

chown -R kibana /usr/share/kibana/optimize/

/bin/systemctl restart elasticsearch
/bin/systemctl restart kibana
/usr/bin/supervisorctl restart scirius 

# Moloch upgrade
moloch_latest=$(curl  https://api.github.com/repos/aol/moloch/tags  -s |jq -r '.[0].name' | cut -c 2-)
moloch_current=$(dpkg -l |grep moloch | awk '{print $3}')

if dpkg --compare-versions ${moloch_latest} gt ${moloch_current} ; then
  echo "Upgrading Moloch.."
  mkdir -p /opt/molochtmp
  cd /opt/molochtmp/
  
  if /usr/bin/wget -q --timeout=10s --tries=1  https://files.molo.ch/builds/ubuntu-18.04/moloch_${moloch_latest}-1_amd64.deb ; then
    dpkg -i /opt/molochtmp/moloch_${moloch_latest}-1_amd64.deb 
    printf 'UPGRADE\n' | /data/moloch/db/db.pl http://localhost:9200 upgrade
    rm /opt/molochtmp/moloch_${moloch_latest}-1_amd64.deb
    
    echo "Starting Moloch SELKS services.. "
    /bin/systemctl start molochpcapread-selks.service
    /bin/systemctl start molochviewer-selks.service
  else
    /bin/systemctl start molochpcapread-selks.service
    /bin/systemctl start molochviewer-selks.service
    echo "Could not download and upgrade Moloch. Please check your network connection."
    exit 1;
  fi

fi
