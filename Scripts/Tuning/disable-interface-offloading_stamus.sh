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



interface=$1
ARGS=1         # The script requires 1 argument.


echo -e "\n The supplied network interface is :  ${interface} \n";

  if [ $# -ne "$ARGS" ];
    then
      echo -e "\n USAGE: `basename $0` -> the script requires 1 argument - a network interface!"
      echo -e "\n Please supply a network interface. Ex - ./disable-interface-offloading.sh eth0 \n"
      exit 1;
  fi

/sbin/ethtool -K ${interface} tso off
/sbin/ethtool -K ${interface} gro off
/sbin/ethtool -K ${interface} lro off
/sbin/ethtool -K ${interface} gso off
/sbin/ethtool -K ${interface} rx off
/sbin/ethtool -K ${interface} tx off
/sbin/ethtool -K ${interface} sg off
/sbin/ethtool -K ${interface} rxvlan off
/sbin/ethtool -K ${interface} txvlan off
/sbin/ethtool -K ${interface} ntuple off
/sbin/ethtool -K ${interface} rxhash off
/sbin/ethtool -L ${interface} combined 1
/sbin/ethtool -N ${interface} rx-flow-hash udp4 sdfn
/sbin/ethtool -N ${interface} rx-flow-hash udp6 sdfn
/sbin/ethtool -n ${interface} rx-flow-hash udp6
/sbin/ethtool -n ${interface} rx-flow-hash udp4
/sbin/ethtool -C ${interface} rx-usecs 1 rx-frames 0
/sbin/ethtool -C ${interface} adaptive-rx off
/sbin/ethtool -G ${interface} rx 4096

echo -e "###################################"
echo -e "# CURRENT STATUS - NIC OFFLOADING #"
echo -e "###################################"
/sbin/ethtool -k ${interface} 
echo -e "######################################"
echo -e "# CURRENT STATUS - NIC RINGS BUFFERS #"
echo -e "######################################"
/sbin/ethtool -g ${interface} 
