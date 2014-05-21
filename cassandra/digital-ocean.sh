set -eu

DROPLET_NAME=cassandra-1x4
REGION=nyc2
DROPLET_SIZE=2gb
IMAGE_NAME=ubuntu-13-10-x64
SSH_KEY_ID=$(diocean ssh-keys ls  | cut -f1 | head -n 2 | tail -n 1)
PRIVATE_NETWORKING=false
BACKUPS_ENABLED=false

droplet_exists () {
  diocean droplets ls | grep -q "	$1	"
}

droplet_ip_address () {
  diocean droplets ls | grep "	$1	" | cut -f 7
}

if droplet_exists $DROPLET_NAME; then
  echo "Droplet already exists: $DROPLET_NAME"
else
  echo "creating: $DROPLET_NAME"
  diocean -w droplets new $DROPLET_NAME $DROPLET_SIZE $IMAGE_NAME $REGION $SSH_KEY_ID $PRIVATE_NETWORKING $BACKUPS_ENABLED
fi


DROPLET_IP_ADDRESS=$(droplet_ip_address $DROPLET_NAME)

rsync -avz . root@$DROPLET_IP_ADDRESS:docker-init/

ssh root@$DROPLET_IP_ADDRESS "cd docker-init; bash local-install-docker.sh"
ssh root@$DROPLET_IP_ADDRESS "cd docker-init; bash bootstrap-cassandra.sh"

