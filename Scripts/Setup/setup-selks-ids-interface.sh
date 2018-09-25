#!/bin/bash

# Copyright(C) 2018, Stamus Networks
# All rights reserved
# Part of Debian SELKS scripts
# Written by Peter Manev <pmanev@stamus-networks.com>
#
# Please run on Debian
#
# This script comes with ABSOLUTELY NO WARRANTY!
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


echo -e "\nPlease supply a network interface to set up SELKS Suricata IDS inspection on"

echo -e "\nThe following are the available interfaces:"
sudo ifconfig -a | sed 's/[ \t].*//;/^$/d' | awk -F":" '{print $1}'

echo -e "\nConfigure INTERFACE: "
read interface

echo -e "\nThe supplied network interface is:  ${interface} \n";


  if ! grep --quiet "${interface}" /proc/net/dev
    then
      echo -e "\nUSAGE: `basename $0` -> the script requires 1 argument - a network interface!"
      echo -e "\nPlease supply a correct/existing network interface or check your spelling. Ex - eth1 \n"
      exit 1;
  fi

sudo /bin/systemctl stop suricata
sudo rm -rf /var/run/suricata.pid

sudo sed -i -e "/^af-packet:/{\$!N; s/  - interface:.*/  - interface: ${interface}/}" /etc/suricata/selks5-addin.yaml

sudo /bin/systemctl start suricata

echo "DONE!"



