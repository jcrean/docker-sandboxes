set -exu

test -d docker-cdh3-hadoop || git clone https://github.com/teco-kit/docker-cdh3-hadoop.git
cd docker-cdh3-hadoop
bash build-all.sh
