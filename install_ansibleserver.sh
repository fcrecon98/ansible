#!/bin/bash

set -uex

LOGFILE="/tmp/install_ansibleserver.log"
SOURCEDIR="/usr/local/src/ansible"

(

echo "`date` $0 started. log output to  ${LOGFILE}"

yum install -y --enablerepo=epel \
 python-yaml \
 python-jinja2 \
 python-paramiko \
 git \
 python-setuptools \
 python-devel \
 asciidoc \
 rpm-build

if [ -e ${SOURCEDIR} ]
  then 
    cd ${SOURCEDIR} && git pull
  else 
    cd `dirname ${SOURCEDIR}`
    git clone git://github.com/ansible/ansible.git `basename ${SOURCEDIR}` --recursive
fi

cd /usr/local/src/ansible/
make rpm
yum localinstall -y /usr/local/src/ansible/rpm-build/ansible-*.noarch.rpm

echo "`date` $0 ended."

) | tee -a ${LOGFILE} 2>&1
