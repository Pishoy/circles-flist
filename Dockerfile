FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev; \
    apt-get install -y libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev ; \
    apt-get install -y automake libtool curl git tmux gettext ; \
    apt-get install -y nginx; \
    apt-get install -y rabbitmq-server redis-server ; \
    apt-get install -y postgresql; \
    apt-get install -y python3 python3-pip python3-dev virtualenvwrapper; \
    apt-get install -y libxml2-dev libxslt-dev; \
    apt-get install -y libssl-dev libffi-dev; \
    apt-get install -y sudo openssh-server virtualenv python-pip vim golang-go zip nodejs npm

# install supervisor
RUN pip3 install supervisor

# install latest restic
RUN set -ex ; \
    git clone https://github.com/restic/restic; \
    cd restic; \
    go run build.go; \
    cp -p restic /usr/bin/restic; \
    rm -rf restic

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# configure nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx_conf  /etc/nginx/conf.d/taiga.conf
COPY start_circles.sh /.start_circles.sh
COPY setup_taiga.sh /.setup_taiga.sh
COPY prepare_taiga.sh /.prepare_taiga.sh
COPY supervisor.conf /etc/supervisor/supervisor.conf

RUN chmod +x /.start_discourse.sh
ENTRYPOINT ["/.start_discourse.sh"]
