set -eu

has_docker_apt_key () {
  sudo apt-key finger | grep -q "36A1 D786 9245 C895 0F96  6E92 D857 6A8B A88D 21E9"
}

has_docker_apt_repo () {
  test -f /etc/apt/sources.list.d/docker.list
}

docker_package_installed () {
  dpkg -l  | grep -q lxc-docker
}

if has_docker_apt_key; then
  echo "OK: Docker apt-key"
else
  echo "installing Docker apt key"
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
fi

if has_docker_apt_repo; then
  echo "OK: /etc/apt/sources.list.d/docker.list"
else
  sudo sh -c "echo deb https://get.docker.io/ubuntu docker main\
  > /etc/apt/sources.list.d/docker.list"
fi

if docker_package_installed; then
  echo "OK: package lxc-docker is installed"
else
  echo "Installing lxc-docker..."
  sudo apt-get update
  # echo "deb http://mirror.anl.gov/pub/ubuntu precise main universe" > /etc/apt/sources.d/docker.list
  sudo apt-get install -y lxc-docker build-essential mercurial bzr git-core subversion curl vim emacs wget
fi


docker pull ubuntu
# echo "now try: sudo docker run -i -t ubuntu /bin/bash"

docker build -t go-service - < Dockerfile-go-service

