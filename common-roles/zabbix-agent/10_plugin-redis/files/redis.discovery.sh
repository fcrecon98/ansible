#!/bin/sh

REDIS_PASSWORD=changeit

echo "{"
echo "  \"data\":["

for REDIS_SERVER in $(/sbin/chkconfig --list | grep redis | grep -v sentinel | grep 3:on | awk '{print $1}')
do
REDIS_PORT=$(awk -F= '{if($1=="REDISPORT") print $2}' /etc/init.d/${REDIS_SERVER})
echo "    ${COMMA}{ \"{#REDISSERVER}\":\"${REDIS_SERVER}\", \"{#REDISPORT}\":\"${REDIS_PORT}\", \"{#REDISPASSWORD}\":\"${REDIS_PASSWORD}\" }"
COMMA=,
done

echo "  ]"
echo "}"
