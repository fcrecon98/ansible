#!/bin/sh

# usage exportvaluemap.sh |  > filename

ZABBIX_DB_NAME=zabbix
ZABBIX_DB_USERID=zabbix
ZABBIX_DB_PASSWORD=zabbix

function getValueMap() {

mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
select valuemaps.name, mappings.value, mappings.newvalue from valuemaps, mappings where valuemaps.valuemapid = mappings.valuemapid;
EOF

}

getValueMap | sed -e 's/\t/,/g'
