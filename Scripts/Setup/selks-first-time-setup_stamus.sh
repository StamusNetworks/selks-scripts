#!/bin/bash
#
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

# Wrapper around init/first time set up scripts

# make sure we save the logs for investigation if needed.
sudo mkdir -p /opt/selks/log/
(
echo "START of first time setup script - $(date) " 

sudo /opt/selks/Scripts/Setup/selks-setup-ids-interface.sh 

if [ $? -ne 0 ]; then
    echo "Previous job failed...Exiting..." 
    echo -e "\n### Exited with ERROR  ###\n" 
    echo -e "\nFull log located at - /opt/selks/log/selks-first-time-setup_stamus.log"
    echo -e "\nPress Enter to continue\n"
    read
    exit 1
fi

echo "FPC - Full Packet Capture. Suricata will rotate and delete the pcap captured files."
echo "FPC_Retain - Full Packet Capture with having Moloch's pcap retention/rotation. Keeps the pcaps as long as there is space available."
echo -e "None - disable packet capture\n"

PS3="Please choose an option. Type in a number and hit \"Enter\" "
select option in  FPC FPC_Retain NONE
do
    case $option in
        FPC) 
            echo "Enable Full Pcacket Capture"
            EXIT_STATUS="SUCCESS"
            sudo /opt/selks/Scripts/Setup/selks-molochdb-init-setup_stamus.sh FPC
            if [ $? -ne 0 ]; then
              echo "Moloch set up job failed...Exiting..." 
              echo -e "\n### Exited with ERROR  ###\n" 
              EXIT_STATUS="FAILED"
            fi
            break;;
        FPC_Retain) 
            echo "Enable Full Pcacket Capture with pcap retaining "
            EXIT_STATUS="SUCCESS"
            sudo /opt/selks/Scripts/Setup/selks-molochdb-init-setup_stamus.sh
            if [ $? -ne 0 ]; then
              echo "Moloch set up job failed...Exiting..." 
              echo -e "\n### Exited with ERROR  ###\n" 
              EXIT_STATUS="FAILED"
            fi
            break;;
        NONE)
            break;;
     esac
done

if (( $EUID != 0 )); then
    sudo -- sh -c  'cd /usr/share/python/scirius/ && . bin/activate && python bin/manage.py kibana_reset && deactivate && cd /opt/'
else
    cd /usr/share/python/scirius/ && . bin/activate && python bin/manage.py kibana_reset && deactivate && cd /opt/
fi



if [ $? -ne 0 ]; then
    echo "Dashboards loading set up job failed...Exiting..." 
    echo -e "\n### Exited with ERROR  ###\n" 
    EXIT_STATUS="FAILED"
fi

echo "FINISH of first time setup script - $(date) " 

echo -e "\nExited with ${EXIT_STATUS}"
echo -e "\nFull log located at - /opt/selks/log/selks-first-time-setup_stamus.log"
echo -e "\nPress enter to continue\n"
read
) 2>&1 | tee -a /opt/selks/log/selks-first-time-setup_stamus.log




