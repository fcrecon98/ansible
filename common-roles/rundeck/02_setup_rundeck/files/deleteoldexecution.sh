#!/bin/sh

AUTH_TOKEN=$1
API_BASE=http://localhost/api
WORK_DIR=/opt/capcom/rundeck/work/
TTL_DAYS=$2

# Functions #
listprojectname() {
  curl -s -H 'Accept:application/json' -XGET "${API_BASE}/11/projects?authtoken=${AUTH_TOKEN}" | grep name | jq .[].name | xargs
}

listjobid() {
  PROJECT_NAME=$1
  curl -s -XGET "${API_BASE}/2/project/${PROJECT_NAME}/jobs?authtoken=${AUTH_TOKEN}" | grep "job id=" | sed -e "s/<job id='\(.*\)'>/\1/g" | xargs
}

getjobname() {
  JOB_ID=$1
  curl -s -XGET "${API_BASE}/1/job/${JOB_ID}?authtoken=${AUTH_TOKEN}" | grep "<name>" | sed -e "s@<name>\(.*\)</name>@\1@g" | xargs
}

getexecutions() {
  JOB_ID=$1
  curl -s -XGET "${API_BASE}/1/job/${JOB_ID}/executions?authtoken=${AUTH_TOKEN}"
}

getoldexecutionid() {
  JOB_ID=$1
  TTL_EXPIRED=$2
  grep -e "execution id\|date-ended" ${WORK_DIR}/${JOB_ID}.xml | awk -F= '{print $2}' | awk -F\' '{print $2}' | xargs -n 2 | awk -v TTL_EXPIRED=${TTL_EXPIRED} '{if($2<TTL_EXPIRED) print $1}'
}

deleteexecution() {
  curl -XDELETE ${API_BASE}/12/execution/${EXECUTION_ID}?authtoken=${AUTH_TOKEN}
}

### main ###

TTL_EXPIRED="$(expr $(date +%s) - 86400 \* ${TTL_DAYS})000"

for PROJECT in $(listprojectname)
do
  for JOB_ID in $(listjobid ${PROJECT})
  do
    JOB_NAME=$(getjobname ${JOB_ID})
    echo "Delete Old Executions [ ${PROJECT}/${JOB_NAME} : ${JOB_ID}]"
    getexecutions ${JOB_ID} > ${WORK_DIR}/${JOB_ID}.xml
    for EXECUTION_ID in $(getoldexecutionid ${JOB_ID} ${TTL_EXPIRED})
    do
      echo "delete job[${JOB_NAME}] execution[id:${EXECUTION_ID}]"
      deleteexecution ${EXECUTION_ID} 
    done
  done
done
