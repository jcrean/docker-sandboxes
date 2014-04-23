set -exu

sudo docker run -d --privileged teco/cdh3-hadoop-master

MASTER_CID=$(docker ps | grep hadoop-master | cut -f1 -d ' ')
JOBTRACKER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $MASTER_CID)

echo "JobTracker IP: $JOBTRACKER_IP"

sudo docker run -d --privileged teco/cdh3-hadoop-slave --ip=$JOBTRACKER_IP

echo "Slave datanode starting.."
