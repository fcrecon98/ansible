#!/bin/sh

for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do /sbin/ifconfig $INTERFACE txqueuelen 10000; done
for INTERFACE in $(cat /proc/net/dev | grep \: | grep -v bond | grep -v lo | awk -F: '{print $1}');do grep -q "$INTERFACE txqueuelen" /etc/rc.local || echo "/sbin/ifconfig $INTERFACE txqueuelen 10000" >> /etc/rc.local; done
