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


echo -e "\nPlease supply a network interface for inspection (mirror or inbound)"
echo -e "Example - eth1"
echo -e "\nThe script will make adjustments for(or in): "
echo -e "    1) the interface provided"
echo -e "    2) kernel tuning"

echo "INTERFACE: "
read interface

echo -e "\nThe supplied network interface is:  ${interface} \n";


  if ! grep --quiet "${interface}" /proc/net/dev
    then
      echo -e "\nUSAGE: `basename $0` -> the script requires 1 argument - a network interface!"
      echo -e "\nPlease supply a correct/existing network interface or check your spelling. Ex - eth1 \n"
      exit 1;
  fi


# Calling disable-interface-offloading_stamus.sh
echo -e "\nCalling disable-interface-offloading_stamus.sh"
/opt/selks/Scripts/Tuning/./disable-interface-offloading_stamus.sh ${interface}

# Calling kernel-tuneup_stamus.sh
echo -e "\nCalling kernel-tuneup_stamus.sh"
/opt/selks/Scripts/Tuning/./kernel-tuneup_stamus.sh



