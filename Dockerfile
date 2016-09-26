FROM ubuntu:14.04

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
    echo "deb http://repo.percona.com/apt "$(lsb_release -sc)" main" | tee /etc/apt/sources.list.d/percona.list && \
    apt-get update && \
    apt-get install -y --force-yes pwgen percona-server-mongodb 

VOLUME /data/db

ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh
ADD backup.sh /backup.sh
EXPOSE 27017 28017

CMD ["/run.sh"]

ENV MAX_BACKUPS=10
ENV INIT_BACKUP=yes
ENV MONGODB_HOST=localhost
ENV MONGODB_PORT=27017
ENV SUBFOLDER=openparse
ENV CRON_TIME="0 0 * * *"

