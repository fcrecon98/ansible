#!/bin/sh
SRC_NETWORK=$(ip addr | grep 9.255 | grep -v "10.216\|10.226" | awk '{print $2}' | awk -F. '{print $1"."$2"."$3}')
DST_NETWORK=10.253.0.0/16

grep ${DST_NETWORK} /etc/sysconfig/static-routes | grep -q "${SRC_NETWORK}.254"  && echo "route to ${DST_NETWORK}.0/24 is already exists in /etc/sysconfig/static-routes" && exit 2
grep ${DST_NETWORK} /etc/sysconfig/static-routes | grep -qv "${SRC_NETWORK}.254" && sed -e "s@.*${DST_NETWORK}.0/24.*@any net ${DST_NETWORK}.0/24 gw ${SRC_NETWORK}.254@" /etc/sysconfig/static-routes -i && exit $?
echo "any net ${DST_NETWORK} gw ${SRC_NETWORK}.254" >> /etc/sysconfig/static-routes
