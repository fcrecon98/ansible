#!/bin/sh

NETWORK_SCRIPT_DIR=/etc/sysconfig/network-scripts

for INTERFACE in $(awk -F:  '{if ($1~"eth[0-9]") print $1 }' /proc/net/dev)
do
test -e ${NETWORK_SCRIPT_DIR}/ifcfg-${INTERFACE} && cp -pf ${NETWORK_SCRIPT_DIR}/ifcfg-${INTERFACE} ${NETWORK_SCRIPT_DIR}/_ifcfg-${INTERFACE}.$(date +%Y%m%d-%H%M%S)
cp -pf ${NETWORK_SCRIPT_DIR}/_ifcfg-ethx ${NETWORK_SCRIPT_DIR}/ifcfg-${INTERFACE} && sed -i -e "s/ethx/${INTERFACE}/" /etc/sysconfig/network-scripts/ifcfg-${INTERFACE}
ethtool ${INTERFACE} | grep -q yes || ifup ${INTERFACE}
done

