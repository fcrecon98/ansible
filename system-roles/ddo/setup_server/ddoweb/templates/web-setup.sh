#!/bin/sh

##-------------------------------------------------------------------------------
## webserver setup Script
##-------------------------------------------------------------------------------

if [ ${HOSTNAME:3:5} = "webif" ] ; then
	FQDN="webif-server.dd-on.jp"
elif [ ${HOSTNAME:3:3} = "web" ] ; then
	FQDN="startup-server.dd-on.jp"
elif [ ${HOSTNAME:3:4} = "tool" ] ; then
	FQDN="tool.ddo.capcomcld.jp"
else
	FQDN=${HOSTNAME}
fi

# dw_server作成
/usr/sbin/groupadd -g 1003 dw_server
/usr//sbin/useradd -g 1003 -u 1003 dw_server
echo "dw_server        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/dw_server

# Apache,PHPログディレクトリ作成
mkdir -p /var/log/httpd/default
mkdir -p /var/log/httpd/${FQDN}
chmod 755 /var/log/httpd

mkdir -p /var/log/php/php-error
chown -R apache. /var/log/php


# ドキュメントルートディレクトリ作成
mkdir -p /var/www/default/htdocs
mkdir -p /var/www/${FQDN}
touch /var/www/default/htdocs/index.html
chmod 755 /var/www
chown -R dw_server. /var/www/*


# コンテンツ設定
mkdir -p /var/lib/ddo
mkdir -p /var/app_contents/${FQDN}
chown -R dw_server. /var/app_contents/*
mkdir -p /var/log/app
chown -R apache. /var/log/app


# sceライブラリディレクトリ作成
mkdir -p /var/lib/sce/tcm
chown -R dw_server. /var/lib/sce


# Apache再起動
/sbin/service httpd start
sleep 3
ps auxf | grep httpd | grep -v grep 
netstat -ant | grep LISTEN


exit
