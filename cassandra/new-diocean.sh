set -exu

SSH_KEY_ID=$(diocean ssh-keys ls | head -n2 | tail -n1 | cut -f1)
IMAGE=ubuntu-13-10-x64
DROPLET_NAME=cassandra-1x4

function droplet_exists () {
  diocean droplets ls | cut -f2 | grep -q "$1"
}

function droplet_ip () {
  diocean droplets ls | grep "	$1	" | cut -f7
}

if droplet_exists $DROPLET_NAME; then
  echo "already exists: $DROPLET_NAME"
else
  diocean -w droplets new $DROPLET_NAME 1gb $IMAGE nyc2 $SSH_KEY_ID false false
fi

scp bootstrap-docker.sh root@$(droplet_ip $DROPLET_NAME):
ssh root@$(droplet_ip $DROPLET_NAME) "bash bootstrap-docker.sh"

scp bootstrap-cassandra.sh root@$(droplet_ip $DROPLET_NAME):
ssh root@$(droplet_ip $DROPLET_NAME) "bash bootstrap-cassandra.sh"
