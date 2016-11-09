#!/bin/bash
######################################################
# 名称：zabbix_agentから実行するedgescapeの動作確認シェル
# 仕様：AkaData_Demo.plでJPと判定されるIPを問合せし、JP以外の場合エラーを返す
# 引数：なし
# ---------------------
# 2016/05/10 新規作成 by 林 如弥
#####################################################

LISTFILE=/opt/capcom/zabbix/dat/akamai.edgescape.status.list

# リストファイルの件数取得
LISTCNT=`grep -c . ${LISTFILE}`

# 環境変数ファイルを読むため移動が必要
cd /usr/local/edgescape/api/

# 検証用APIでedgescapeに対し、ホワイトリストのIPを問合せし、JPの件数取得
RTCNT=`./AkaData_Demo.pl ${LISTFILE} | grep -c country_code=JP`
if [ $LISTCNT -eq $RTCNT ];then
  echo "0"
else
  echo "1"
fi

exit 0

