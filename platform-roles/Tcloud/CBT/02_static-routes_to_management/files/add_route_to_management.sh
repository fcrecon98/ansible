#!/bin/sh
SRC_NETWORK=$(ip addr | grep 9.255 | grep -v "10.216\|10.226" | awk '{print $2}' | awk -F. '{print $1"."$2"."$3}')
DST_NETWORK=$(ip addr | grep 9.255 | grep -v "10.216\|10.226" | awk '{print $2}' | awk -F. '{print $1".99."$3}')

test "_${SRC_NETWORK}" = "_${DST_NETWORK}" && echo "Source network [${SRC_NETWORK}.0/24] is same dest network [${DST_NETWORK}.0/24]" && exit 2
route -n | grep "${DST_NETWORK}" > /dev/null && echo "route to ${DST_NETWORK}.0/24 is already exist." && exit 2

route add -net ${DST_NETWORK}.0/24 gw ${SRC_NETWORK}.254
