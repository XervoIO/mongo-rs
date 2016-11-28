#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ "$(whoami)" != "root" ]
then
  echo "script must be executed as root!"
  exit 1
fi

if [ -f ~/.mongo_rs_init ]; then
  echo "Init.sh already ran. Delete ~/.mongo_rs_init "
  exit 0
fi

echo "Creating key file at ./conf/keyfile"
openssl rand -base64 741 > $DIR/../conf/keyfile
chmod 600 $DIR/../conf/keyfile

echo "Creating Directories"
mkdir -p /mnt/data/mongo
mkdir -p /mnt/data/backups
mkdir -p /mnt/logs

echo "Configuring Network"
bash $DIR/network.sh
echo "Making sure things start on reboot"
bash $DIR/restart.sh

echo "To create swap on this machine, run bash swap.sh"
HOSTNAME=`hostname`
curl -sS -X POST \
-H "Content-Type: application/json" \
-d "{
    \"hostname\": \"$HOSTNAME\",
    \"company_name\": \"staging\",
    \"type\": \"mongo\"
}" \
http://backup-notifier.mod.bz/register

echo "Machine registered to track backups"

touch ~/.mongo_rs_init
echo "Done!"
