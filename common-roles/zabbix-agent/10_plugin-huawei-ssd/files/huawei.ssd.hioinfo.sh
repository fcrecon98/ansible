#!/bin/sh
################################
# Huawei ssd hioinfo output for Zabbix 2.4
################################

for DEV in `ls /dev | egrep "^hio"`
do 
  /usr/sbin/hio_info -d ${DEV} | tr -d '\t' | tr -d '\%' | sed -e 's!^hio.!!g' -e 's!\s\+!!g' > /opt/capcom/zabbix/dat/huawei_ssdstatus.${DEV}.dat
  /usr/sbin/hio_temperature -d ${DEV} > /opt/capcom/zabbix/dat/huawei_ssdtemp.${DEV}.dat
done

