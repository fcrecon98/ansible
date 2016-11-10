#!/bin/sh
for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do /sbin/ethtool -K $INTERFACE tso off; done
for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do grep -q "$INTERFACE tso" /etc/rc.local || echo "/sbin/ethtool -K $INTERFACE tso off" >> /etc/rc.local; done
