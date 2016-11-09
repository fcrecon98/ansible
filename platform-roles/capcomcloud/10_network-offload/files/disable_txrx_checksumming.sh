#!/bin/sh
for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do /sbin/ethtool -K $INTERFACE tx off; done
for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do grep -q "$INTERFACE tx" /etc/rc.local || echo "/sbin/ethtool -K $INTERFACE tx off" >> /etc/rc.local; done
