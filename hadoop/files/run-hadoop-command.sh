#!/bin/bash

set -exu

MASTER_CID=$(docker ps | grep hadoop-master | cut -f1 -d ' ')
JOBTRACKER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MASTER_CID)

sudo docker run --privileged teco/cdh3-hadoop-command --ip=$JOBTRACKER_IP "$@"
