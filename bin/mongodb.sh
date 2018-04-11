#!/bin/bash

set -e
msg() { echo -e "INFO ------> $1"; }
err() { echo -e "ERR ------> $1" ; exit 1; }

MONGODB_HOST=${MONGODB_PORT_27017_TCP_ADDR:-${MONGODB_HOST}}
MONGODB_PORT=${MONGODB_PORT_27017_TCP_PORT:-${MONGODB_PORT}}
MONGODB_USER=${MONGODB_USER:-${MONGODB_ENV_MONGODB_USER}}
MONGODB_PASS=${MONGODB_PASS:-${MONGODB_ENV_MONGODB_PASS}}

# Check required env
required_vars="OSS_ENDPOINT OSS_BUCKET OSS_ACCESS_KEY_ID OSS_ACCESS_KEY_SECRET DB_NAME"
for var in $required_vars; do
  if [ -z ${!var} ]; then
    err "$var environment variable is required"
  fi
done

date=$(date $DATE_FORMAT)
tmp_dir="/backup"

cmd="mongodump  --host ${MONGODB_HOST} --port ${MONGODB_PORT} --username ${MONGODB_USER} --password ${MONGODB_PASS} ${EXTRA_OPTS}"

oss_opts="-r -u -f --endpoint $OSS_ENDPOINT --access-key-id $OSS_ACCESS_KEY_ID --access-key-secret $OSS_ACCESS_KEY_SECRET"

if [ -n "$authenticationDatabase" ]; then
  cmd="$cmd --authenticationDatabase $authenticationDatabase"
fi

msg "================== Start backup [$date]"
for db in $(echo $DB_NAME | tr "," "\n")
do
  msg "$db: begin to dump"
  db_tmp_dir="$tmp_dir/$db/$date"
  dump_cmd="$cmd --db $db --out $db_tmp_dir"
  msg "Running: $dump_cmd"
  eval "$dump_cmd"

  msg "$db: begin to push to OSS"
  oss_cmd="/opt/oss cp $db_tmp_dir/$db oss://${OSS_BUCKET}${OSS_FOLDER}/$db/$date $oss_opts"
  msg "Running: $oss_cmd"
  eval "$oss_cmd"
  rm -rf $db_tmp_dir
  msg "$db: backup finished **********************"
done
msg "================== Backup finished [$date]"