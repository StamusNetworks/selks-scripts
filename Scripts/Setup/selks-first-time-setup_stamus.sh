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
mkdir -p /opt/selks/log/
(
echo "START of first time setup script - $(date) " 

/opt/selks/Scripts/Setup/selks-setup-ids-interface.sh 

if [ $? -ne 0 ]; then
    echo "Previous job failed...Exiting..." 
    echo -e "\n### Exited with ERROR  ###\n" 
    echo -e "\nFull log located at - /opt/selks/log/selks-first-time-setup_stamus.log"
    echo -e "\nPress Enter to continue\n"
    read
    exit 1
fi

EXIT_STATUS="SUCCESS"
/opt/selks/Scripts/Setup/selks-molochdb-init-setup_stamus.sh  
if [ $? -ne 0 ]; then
    echo "Moloch set up job failed...Exiting..." 
    echo -e "\n### Exited with ERROR  ###\n" 
    EXIT_STATUS="FAILED"
fi

cd /usr/share/python/scirius/ && . bin/activate \
&& python bin/manage.py kibana_reset \
&& deactivate && cd /opt/

if [ $? -ne 0 ]; then
    echo "Dashboards loading set up job failed...Exiting..." 
    echo -e "\n### Exited with ERROR  ###\n" 
    EXIT_STATUS="FAILED"
fi

echo "FINISH of first time setup script - $(date) " 

echo -e "\nExites with ${EXIT_STATUS}"
echo -e "\nFull log located at - /opt/selks/log/selks-first-time-setup_stamus.log"
echo -e "\nPress enter to continue\n"
read
) 2>&1 | tee -a /opt/selks/log/selks-first-time-setup_stamus.log




