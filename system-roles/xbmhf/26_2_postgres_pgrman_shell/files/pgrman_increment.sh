#!/bin/bash
######################################################
# 名称：MHF用postgresのpg_rmanバックアップ取得シェル
# 仕様：postgres,pg_rman,pacemakerの状態を確認してから
#       pg_rmanバックアップを実行する
# 引数：なし
# ---------------------
# 2016/03/06 新規作成 by 林 如弥
#####################################################

SHELL_NAME=`basename $0`
ZBX_SENDER="/usr/bin/zabbix_sender"
ZBX_AGENT_CONF="/etc/zabbix/zabbix_agentd.conf"
ZBX_NAME=${HOSTNAME}
ZBX_KEY="custom.operation.pitr_archivebackup"
#ZBX_KEY="custom.operation.pitr_basebackup"

# rootユーザ変数設定
. /root/.bash_profile


# ログ出力関数
log ()
{
    echo "#[`date +'%Y-%m-%d %T'`]: $1"
}

# postgresが起動していなければ処理終了
log "Check running postgres"
su - postgres -c '. ~/.bash_profile;psql -l'
RET=$?
if [ ${RET} = 0 ];then
  log "OK. postgres is running."
else
  log "Oops. postgres is not running. Exit."
  exit 1
fi

# pg_rman 実行中である場合は処理を行わない
log "Check running pg_rman"
ps aux | grep "[/]usr/local/postgres/bin/pg_rman backup"
RET=$?
if [ ${RET} = 1 ];then
  log "OK. pg_rman is not running."
else
  log "Oops. pg_rman is running. Exit."
  exit 1
fi


# 自分がSLAVEであるかの確認
log "Check postgres slave"
SLAVEHOST=`/usr/sbin/crm_mon -1 | awk '/Slaves/{print $3}'`

if [ "${HOSTNAME}" = "${SLAVEHOST}" ];then
  log "OK. I am slave."
else
  log "I'm not slave."

  #シングル構成であるかの確認
  log "Check postgres replication status"
  RETSTR=`su - postgres -c '. ~/.bash_profile ;  psql -x -c "SELECT * FROM pg_stat_replication"'`
  if [ "${RETSTR}" = "(No rows)" ];then
    log "OK. postgres is single master"
  else
    log "OK. I'm master."
    log "Notification to zabbix"
    ${ZBX_SENDER} -c ${ZBX_AGENT_CONF} -s ${ZBX_NAME} -k ${ZBX_KEY} -o "${SHELL_NAME} | OK" 
    exit 0
  fi
fi


# 開始前に、念のためstopbackupを実行する
log "Exec pg_stop_backup"
su - postgres -c '. ~/.bash_profile ; psql -c "SELECT pg_stop_backup()"'


# vip用のホスト名を取得する
DBNAME=`echo $HOSTNAME | sed -e 's/[0-9]$/0/'`

# バックアップを取得する
log "Start postgres backup"
#su - postgres -c ". ~/.bash_profile ; /usr/local/postgres/bin/pg_rman backup -v --host=$DBNAME.master --standby-host=$DBNAME.slave --standby-port=5432 > /var/pgsql/pg_rman/log/full_`date +\%Y\%m\%d-\%H\%M`.log 2>&1 ; /usr/local/postgres/bin/pg_rman validate"
su - postgres -c ". ~/.bash_profile ; /usr/local/postgres/bin/pg_rman backup -b incremental -v --host=$DBNAME.master --standby-host=$DBNAME.slave --standby-port=5432 > /var/pgsql/pg_rman/log/incremental_`date +\%Y\%m\%d-\%H\%M`.log  2>&1 ; /usr/local/postgres/bin/pg_rman validate"
RET=$?
if [ ${RET} = 0 ];then
  log "OK. pg_rman is completed."
else
  log "Oops. pg_rman is error. Exit."
  exit 1
fi

# Zabbixに完了を通知する
log "Notification to zabbix"
${ZBX_SENDER} -c ${ZBX_AGENT_CONF} -s ${ZBX_NAME} -k ${ZBX_KEY} -o "${SHELL_NAME} | OK" 
RET=$?
if [ ${RET} = 0 ];then
  log "OK. Notification is completed."
else
  log "Oops. Notification is error. Exit."
  exit 1
fi

exit 0

