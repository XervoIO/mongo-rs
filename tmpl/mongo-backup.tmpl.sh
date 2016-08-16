#!/bin/bash

#     THIS IS BY DESIGN; look at the tmpl file
if [[ $RUN_BACKUPS != true ]]; then
    exit;
fi

DATE=\`date +%Y-%m-%d-%H-%M-%S\`
DIR=/data/backups
HOST=localhost:27017
DUMP_TOOL=mongodump
ZIP=\$DIR/\$DATE.tar.gz
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

touch \$LOG_FILE
touch \$DIR/file
rm \$DIR/*
\$DUMP_TOOL --username ${MONGO_HOST_ADMIN_USER} --password ${MONGO_HOST_ADMIN_PASS} --host \$HOST --oplog -o \$DIR/\$DATE > \$LOG_FILE
tar -czvf \$ZIP \$DIR/\$DATE
rm -rf \$DIR/\$DATE
/usr/bin/env s3cmd --config=/opt/modulus/conf/s3cmd.conf put \$ZIP s3://${S3_BUCKET_MONGO_BACKUPS}/${REPL_SET_NAME}/\$DATE.tar.gz