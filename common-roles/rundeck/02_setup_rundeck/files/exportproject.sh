#!/bin/sh

AUTH_TOKEN=$1
API_BASE=http://localhost/api
BACKUP_DIR=$2

# Functions #
listprojectname() {
  curl -s -H 'Accept:application/json' -XGET "${API_BASE}/11/projects?authtoken=${AUTH_TOKEN}" | grep name | jq .[].name | xargs
}


### main ###

for PROJECT in $(listprojectname)
do
  echo begin backup project [${PROJECT}]
  curl -s -XGET ${API_BASE}/11/project/${PROJECT}/export?authtoken=${AUTH_TOKEN} > ${BACKUP_DIR}/${PROJECT}_$(date +%Y%m%d-%H%M%S).zip
  echo end backup project [${PROJECT}]
done
