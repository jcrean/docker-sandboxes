#!/bin/bash

set -exu

if [ ! -d docker-cassandra ]; then
  git clone https://github.com/nicolasff/docker-cassandra.git
fi

cd docker-cassandra

sudo apt-get install -y build-essential make
sudo cp install/bin/pipework /usr/bin/

make image VERSION=2.0.7
