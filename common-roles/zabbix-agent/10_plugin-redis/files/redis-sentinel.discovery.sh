#!/bin/sh

SENTINEL_PASSWORD=changeit

echo "{"
echo "  \"data\":["

for SENTINEL_SERVER in $(/sbin/chkconfig --list | grep redis-sentinel | grep 3:on | awk '{print $1}' )
do
SENTINEL_PORT=$(awk -F= '{if($1=="REDIS_CONFIG") print $2}' /etc/init.d/${SENTINEL_SERVER} | sed -e 's/"//g' | grep port $(cat) | awk '{print $2}')
echo "    ${COMMA}{ \"{#SENTINELSERVER}\":\"$(echo ${SENTINEL_SERVER} | sed -e 's/redis-//g')\", \"{#SENTINELPORT}\":\"${SENTINEL_PORT}\", \"{#SENTINELPASSWORD}\":\"${SENTINEL_PASSWORD}\" }"
COMMA=,
done

echo "  ]"
echo "}"
