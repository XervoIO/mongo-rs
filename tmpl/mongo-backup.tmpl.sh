#!/bin/bash

#     THIS IS BY DESIGN; look at the tmpl file
#     The variable below gets evaluated when ./configure.sh is ran.
if [[ $RUN_BACKUPS != true ]]; then
    exit;
fi

MONGO_ROOT_NAME=$MONGO_HOST_ADMIN_USER
MONGO_ROOT_PASSWORD=$MONGO_HOST_ADMIN_PASS
S3_BUCKET=$S3_BUCKET_MONGO_BACKUPS
HOSTNAME=`hostname`
DB_NAME=$REPL_SET_NAME
set -x
DATE=\`date +%Y-%m-%d-%H-%M-%S\`
DIR=/data/backups
HOST=localhost:27017
MONGO_BIN=/usr/bin/
DUMP_TOOL=\$MONGO_BIN/mongodump
TAR=\$DIR/\$DATE.tar
LOG_FILE=/logs/backup.log

LOG_FILES_TO_KEEP=5

if [ -f \$LOG_FILE ]; then
    for i in \`seq \$LOG_FILES_TO_KEEP -1 1\`; do
        if [ -f \$LOG_FILE.\$i ]; then
            if [[ \$i == \$LOG_FILES_TO_KEEP ]]; then
                rm \$LOG_FILE.\$i
                continue
            fi
            mv \$LOG_FILE.\$i \$LOG_FILE.\$((i+1))
        fi
    done
    mv \$LOG_FILE \$LOG_FILE.1
fi

if [[ \$MONGO_BIN == "" ]]; then
  echo "MONGO_BIN, the location of the mongo binaries, must be set in script"
  exit 1
fi

if [[ \$MONGO_ROOT_NAME == "" ]]; then
  echo "MONGO_ROOT_NAME must be set in the script."
  exit 1
fi

if [[ \$MONGO_ROOT_PASSWORD == "" ]]; then
  echo "MONGO_ROOT_PASSWORD must be set in the script."
  exit 1
fi

# Clear out the backup directory
rm -rf \$DIR/*

# Make the directory the files will be stored in
BACKUP_DIR=\$DIR/\$DATE
mkdir \$BACKUP_DIR

# Get the list of mongo databases
DATABASES=(\`\$MONGO_BIN/mongo -u \$MONGO_ROOT_NAME -p \$MONGO_ROOT_PASSWORD --authenticationDatabase "admin" --eval "db.getMongo().setSlaveOk();printjson(db.adminCommand('listDatabases'))" | grep name | awk '{FS=":"}{print \$2}' | tr -d '[[", ]]'\`)

touch \$LOG_FILE

for db in ${DATABASES[@]}; do
  if [[ $db == "local" ]]; then
     \$DUMP_TOOL --username \$MONGO_ROOT_NAME --password \$MONGO_ROOT_PASSWORD --host \$HOST --out \$BACKUP_DIR --authenticationDatabase admin --db \$db --excludeCollection oplog.rs &>> \$LOG_FILE
  else
     \$DUMP_TOOL --username \$MONGO_ROOT_NAME --password \$MONGO_ROOT_PASSWORD --host \$HOST --out \$BACKUP_DIR --authenticationDatabase admin --db \$db &>> \$LOG_FILE
  fi
done

# Tar up the backups.
tar -czvf \$TAR \$BACKUP_DIR &>> \$LOG_FILE

SIZE=\$(stat --printf="%s" \$TAR)

# Upload to s3
/usr/bin/s3cmd  --config=/opt/modulus/conf/s3cmd.conf put \$TAR s3://\$S3_BUCKET/\$DB_NAME/\$DATE.tar &>> \$LOG_FILE
rm -rf \$BACKUP_DIR

curl -sS -X POST \
-H "Content-Type: application/json" \
-d '{
    "size": '\$SIZE'
}' \
http://backup-notifier.mod.bz/backup/$HOSTNAME