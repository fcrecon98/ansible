#!/bin/sh
for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do /sbin/ethtool -K $INTERFACE gso off; done
for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do grep -q "$INTERFACE gso" /etc/rc.local || echo "/sbin/ethtool -K $INTERFACE gso off" >> /etc/rc.local; done
