#!/bin/bash

# Get the directiory of this script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

$DIR/configure.sh

source $DIR/../versions

docker-compose \
  --file $DIR/../conf/docker-compose.yml \
  up -d --no-build