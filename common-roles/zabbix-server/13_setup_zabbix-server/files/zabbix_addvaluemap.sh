#!/bin/sh

LIST_FILE=$1
#ZABBIX_WEB_USERID=admin
#ZABBIX_WEB_PASSWORD=zabbix

ZABBIX_DB_NAME=zabbix
ZABBIX_DB_USERID=zabbix
ZABBIX_DB_PASSWORD=zabbix

IFS='
'

# アクセストークンの取得
#ZABBIX_POSTDATA="{\"jsonrpc\":\"2.0\",\"method\":\"user.authenticate\",\"params\":{\"user\":\"${ZABBIX_WEB_USERID}\",\"password\":\"${ZABBIX_WEB_PASSWORD}\"},\"auth\":null,\"id\":1}"
#ZABBIX_ACCESSTOKEN=$(curl -sX POST -H "Content-Type:application/json-rpc" -d ${ZABBIX_POSTDATA} http://localhost/zabbix/api_jsonrpc.php | awk -F ',' '{print $2}' | awk -F ":" '{print $2}')

# リストファイルからデータを取得しアイテムを追加
for VALUEMAP_PROP in $(grep -v \# ${LIST_FILE})
do
IFS=','
set -- ${VALUEMAP_PROP}
VALUEMAP_NAME=$1
VALUE=$2
NEWVALUE=$3
IFS='
'

# VALUEMAP IDの取得
VALUEMAP_ID=$(mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
select valuemapid from valuemaps where name="${VALUEMAP_NAME}";
EOF
)

echo $VALUEMAP_ID

# VALUEMAPが存在しない場合は作成
if [ "" == "${VALUEMAP_ID}" ]
then

echo "Create value map [${VALUEMAP_NAME}]"

VALUEMAP_ID=$(mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
select max(valuemapid)+1 from valuemaps;
EOF
)

mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
insert into valuemaps(valuemapid,name) values (${VALUEMAP_ID},"${VALUEMAP_NAME}");
EOF

# ID管理テーブルとの整合性を確保
mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
update ids SET nextid=${VALUEMAP_ID} where table_name='valuemaps';
EOF

fi

# MAPPING IDの取得
MAPPING_ID=$(mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
select max(mappingid)+1 from mappings;
EOF
)

# 既存MAPPINGの削除
mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
delete from mappings where valuemapid=${VALUEMAP_ID} and value=${VALUE};
EOF

# MAPPINGの追加
mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
insert into mappings(mappingid,valuemapid,value,newvalue) values (${MAPPING_ID},${VALUEMAP_ID},${VALUE},"${NEWVALUE}")
on duplicate key update newvalue="${NEWVALUE}";
EOF

# ID管理テーブルとの整合性を確保
mysql -N -u${ZABBIX_DB_USERID} -p${ZABBIX_DB_PASSWORD} ${ZABBIX_DB_NAME} <<EOF
update ids SET nextid=${MAPPING_ID} where table_name='mappings';
EOF

done
