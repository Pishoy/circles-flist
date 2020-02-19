#!/usr/bin/env bash
set -ex

# prepare ssh
chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

# prepare postgres
chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres /var/run/postgresql
chown -R postgres.postgres /etc/postgresql
find /var/lib/postgresql -maxdepth 0 -empty -exec sh -c 'pg_dropcluster 10 main && pg_createcluster 10 main' \;

#
echo 'remove a record was added by zos that make our server slow, below is resolv.conf file contents'
cat /etc/resolv.conf
sed -i '/^nameserver 10./d' /etc/resolv.conf
locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8

# set threebot paramater from env varaibles
echo "PRIVATE_KEY=$PRIVATE_KEY" >> /etc/environment
echo "THREEBOT_URL=$THREEBOT_URL" >> /etc/environment
echo "OPEN_KYC_URL=$OPEN_KYC_URL" >> /etc/environment

# prepare rabbitmq
chown -R rabbitmq:rabbitmq /etc/rabbitmq
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
chown -R rabbitmq:rabbitmq /var/log/rabbitmq/

chown -R root:root /usr/bin/sudo
chmod 4755 /usr/bin/sudo

sed -i "s/listen 80 default_server/listen $HTTP_PORT default_server/g" /etc/nginx/conf.d/taiga.conf

sudo nginx -t
mkdir -p /var/log/{ssh,postgres,taiga-back,taiga-events,nginx,rabbitmq,cron}

# start supervisord

supervisord -c /etc/supervisor/supervisord.conf

# taiga setup script
echo starting taiga setup script
bash /.setup_taiga.sh

# add logs dir for taiga logs
[[ -d  /home/taiga/logs ]] || mkdir -p /home/taiga/logs
chown -R taiga:taiga /home/taiga

# taiga prepare script
echo  starting taiga prepare script
su taiga -c 'bash /.prepare_taiga.sh'

# Start rabbitmq-server and create user+vhost
rabbitmqctl add_user taiga $SECRET_KEY
rabbitmqctl add_vhost taiga
rabbitmqctl set_permissions -p taiga taiga '.*' '.*' '.*'

exec "$@"
