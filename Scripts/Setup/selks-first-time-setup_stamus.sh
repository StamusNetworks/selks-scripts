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
echo "START of first time setup script - $(date) " 2>&1 | tee -a /opt/selks/log/selks-first-time-setup_stamus.log

/opt/selks/Scripts/Setup/setup-selks-ids-interface.sh 2>&1 | tee -a /opt/selks/log/selks-first-time-setup_stamus.log
/opt/selks/Scripts/Setup/selks-molochdb-init-setup_stamus.sh 2>&1 | tee -a /opt/selks/log/selks-first-time-setup_stamus.log 
( cd /usr/share/python/scirius/ && . bin/activate && python bin/manage.py kibana_reset && deactivate ) 2>&1 | tee -a /opt/selks/log/selks-first-time-setup_stamus.log
echo "FINISH of first time setup script - $(date) " 2>&1 | tee -a /opt/selks/log/selks-first-time-setup_stamus.log




