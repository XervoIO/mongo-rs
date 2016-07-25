#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $DIR/../variables


# supervisor.conf
eval "cat <<EOF
$(<$DIR/../tmpl/supervisor.conf.tmpl)
EOF
" > $DIR/../conf/supervisor.conf

# mongo.conf
eval "cat <<EOF
$(<$DIR/../tmpl/mongo.conf.tmpl)
EOF
" > $DIR/../conf/mongo.conf

# docker-compose.yml
eval "cat <<EOF
$(<$DIR/../tmpl/docker-compose.yml.tmpl)
EOF
" > $DIR/../conf/docker-compose.yml

# mongo-backup.sh
eval "cat <<EOF
$(<$DIR/../tmpl/mongo-backup.sh.tmpl)
EOF
" > $DIR/../conf/mongo-backup.sh

# s3cmd.conf
eval "cat <<EOF
$(<$DIR/../tmpl/s3cmd.conf.tmpl)
EOF
" > $DIR/../conf/s3cmd.conf

# create_admin_user.js
eval "cat <<EOF
$(<$DIR/../tmpl/create_admin_user.js.tmpl)
EOF
" > $DIR/../conf/create_admin_user.js