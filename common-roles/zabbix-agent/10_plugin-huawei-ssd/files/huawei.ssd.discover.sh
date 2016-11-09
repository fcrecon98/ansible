#!/bin/sh
################################
# Huawei ssd device discovery for Zabbix 2.4
################################

SSDS=`ls /dev | egrep "^hio"`
JSON_H="{\"data\":["    #JSON Header
JSON_F="]}"             #JSON Footer

INDEX=0 #array index

# create json
for LINE in ${SSDS}
do
        array+=`echo "{\"{#SSDNAME}\":\"${LINE}\"}"` # add json for array
        array+=","                                   # add delimiter
done

RESULT="${JSON_H}`echo ${array}|sed -e s/,$//g`${JSON_F}"

echo "${RESULT}"
