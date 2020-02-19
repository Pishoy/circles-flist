#!/bin/bash
set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev
apt-get install -y libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev
apt-get install -y automake libtool curl git tmux gettext
apt-get install -y nginx
apt-get install -y rabbitmq-server redis-server
apt-get install -y postgresql
apt-get install -y python3 python3-pip python3-dev virtualenvwrapper
apt-get install -y libxml2-dev libxslt-dev
apt-get install -y libssl-dev libffi-dev
apt-get install -y sudo openssh-server virtualenv python-pip vim golang-go zip nodejs npm
# install latest restic
git clone https://github.com/restic/restic
cd restic
go run build.go
cp -p restic /usr/bin/restic
rm -rf restic

# install nodejs and npm
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# configure nginx and startup toml

rm /etc/nginx/sites-enabled/default
nginx_file='/etc/nginx/conf.d/taiga.conf'
wget https://raw.githubusercontent.com/threefoldtech/Threefold-Circles-Flist/master/nginx_conf -O ${nginx_file}
wget https://raw.githubusercontent.com/threefoldtech/Threefold-Circles-Flist/master/startup.toml -O /.startup.toml

tar -cpzf "/root/archives/circles.tar.gz" --exclude dev --exclude sys --exclude proc --exclude /root/archives/ /

