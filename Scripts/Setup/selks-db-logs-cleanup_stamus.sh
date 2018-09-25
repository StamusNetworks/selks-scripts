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

cleanup_routine() {
    if  ( curl -X GET "localhost:9200/_cluster/health?wait_for_status=yellow&timeout=240s" )
    then
        if [ ! -e $MOLOCH ]
            then
                echo "Moloch is not installed or in the expected location"
                echo "/data/moloch/db/db.pl"
                exit 1
        fi
        echo "Deleting Elasticsearch SELKS data"
        curl -XDELETE 'http://localhost:9200/logstash*'
        
        echo "Deleting Moloch DB data (users stay untouched)"
        printf 'WIPE\n' | /data/moloch/db/db.pl http://localhost:9200 wipe
        
        echo "Stopping Suricata & Logstash and cleaning up logs"
        /bin/systemctl stop suricata
        /bin/systemctl stop logstash
        rm -rf /var/run/suricata.pid
        rm -f /var/log/suricata/*
        /bin/systemctl start suricata
        /bin/systemctl start logstash
    else
        
        echo "Elasticsearch is in RED state or not up"
        echo "Nothing will be erased/cleaned up."
        
    fi

}

cleanup_routine
