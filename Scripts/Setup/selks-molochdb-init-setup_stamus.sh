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

MOLOCH=/data/moloch/db/db.pl

firstboot_routine() {
    if  ( curl -X GET "localhost:9200/_cluster/health?wait_for_status=yellow&timeout=240s" )
    then
        echo -e "\n### Setting up Moloch ###\n"
        /data/moloch/db/db.pl http://localhost:9200 init
        # get some default answers so we generate all needed configs for Moloch
        printf '\n\n\nno\n' | /data/moloch/bin/Configure
        /data/moloch/bin/moloch_add_user.sh selks-user "SELKS Admin User" selks-user --admin

        if [ ! -e /data/moloch/etc/config.ini ]
        then
            echo "The currently installed Moloch config.ini is not installed or in the expected location"
            exit 1
        fi
        if [ ! -e /opt/selks/Scripts/Configs/SELKS5/data/moloch/etc/molochpcapread-selks-config.ini ]
        then
            echo "Moloch molochpcapread-selks.service is not installed or in the expected location:"
            echo "/opt/selks/Scripts/Configs/SELKS5/data/moloch/etc/molochpcapread-selks-config.ini"
            exit 1
        fi
        if [ ! -e /opt/selks/Scripts/Configs/SELKS5/etc/systemd/system/molochpcapread-selks.service ]
        then
            echo "Moloch molochpcapread-selks.service is not installed or in the expected location:"
            echo "/opt/selks/Scripts/Configs/SELKS5/etc/systemd/system/molochpcapread-selks.service"
            exit 1
        fi
        if [ ! -e /opt/selks/Scripts/Configs/SELKS5/etc/systemd/system/molochviewer-selks.service ]
        then
            echo "Moloch molochpcapread-selks.service is not installed or in the expected location:"
            echo "/opt/selks/Scripts/Configs/SELKS5/etc/systemd/system/molochviewer-selks.service"
            exit 1
        fi
        echo -e "\n### Setting up Moloch configs and services ###\n"
        cp -f /data/moloch/etc/config.ini /data/moloch/etc/config.ini.orig-$(date +"%Y%m%d_%H%M%S")
        cp -f /opt/selks/Scripts/Configs/SELKS5/data/moloch/etc/molochpcapread-selks-config.ini /data/moloch/etc/config.ini
        cp -f /opt/selks/Scripts/Configs/SELKS5/etc/systemd/system/molochviewer-selks.service /etc/systemd/system/molochviewer-selks.service
        cp -f /opt/selks/Scripts/Configs/SELKS5/etc/systemd/system/molochpcapread-selks.service /etc/systemd/system/molochpcapread-selks.service

        echo -e "\n### Setting up and restarting services ###\n"
        /bin/systemctl disable molochcapture.service
        /bin/systemctl disable molochviewer.service
        /bin/systemctl enable molochpcapread-selks.service
        /bin/systemctl enable molochviewer-selks.service
        /bin/systemctl daemon-reload
        /bin/systemctl restart molochpcapread-selks.service
        /bin/systemctl restart molochviewer-selks.service
        
    fi

}


echo -e "\n### Starting Moloch DB set up ###\n"

if [ ! -e $MOLOCH ]
    then
        echo "Moloch is not installed or in the expected location"
        echo "/data/moloch/db/db.pl"
        exit 1
fi
    
firstboot_routine
