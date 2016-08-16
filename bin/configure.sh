#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $DIR/../variables


# supervisor.conf
eval "cat <<EOF
$(<$DIR/../tmpl/supervisor.tmpl.conf)
EOF
" > $DIR/../conf/supervisor.conf

# mongo.conf
eval "cat <<EOF
$(<$DIR/../tmpl/mongo.tmpl.conf)
EOF
" > $DIR/../conf/mongo.conf

# docker-compose.yml
eval "cat <<EOF
$(<$DIR/../tmpl/docker-compose.tmpl.yml)
EOF
" > $DIR/../conf/docker-compose.yml

# mongo-backup.sh
eval "cat <<EOF
$(<$DIR/../tmpl/mongo-backup.tmpl.sh)
EOF
" > $DIR/../conf/mongo-backup.sh

# s3cmd.conf
eval "cat <<EOF
$(<$DIR/../tmpl/s3cmd.tmpl.conf)
EOF
" > $DIR/../conf/s3cmd.conf

# create_admin_user.js
eval "cat <<EOF
$(<$DIR/../tmpl/create_admin_user.tmpl.js)
EOF
" > $DIR/../conf/create_admin_user.js

chmod +x $DIR/../conf/mongo-backup.sh