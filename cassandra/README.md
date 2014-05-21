Cassandra Sandbox
====================

[Digital Ocean](https://www.digitalocean.com/) Ubuntu/Docker Sandbox for running a single server (1x4) Cassandra cluster.


To provision a Single DigitalOcean node and run a 4 node Cassandra cluster, run:

    bash digital-ocean.sh

To start a cluster:

    cd docker-init/docker-cassandra
    ./start-cluster.sh 2.0.7 3
    ./stop-cluster.sh 2.0.7

To get the list of IP addresses for the docker instances:

    docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(docker ps | cut -f1 -d' ' | tail -n +2)

To run cqlsh:

    bash client.sh 2.0.7 bash
    CQLSH_HOST=172.17.0.2 cqlsh

GOALS
=======

* Test Clustering

push data into cluster

take nodes out, add nodes in

confirm data integrity

* Learn how to model data effectively

modeling

indexing and retrieval

* Multi-data center replication
