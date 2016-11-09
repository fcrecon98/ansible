#!/bin/sh
SRC_NETWORK=$(ip addr | grep 9.255 | grep -v "10.216\|10.226" | awk '{print $2}' | awk -F. '{print $1"."$2"."$3}')
DST_NETWORK=10.253.0.0

route -n | grep "${DST_NETWORK}" > /dev/null && echo "route to ${DST_NETWORK}.0/24 is already exist." && exit 2
route add -net ${DST_NETWORK}/16 gw ${SRC_NETWORK}.254
