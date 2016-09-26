FROM ubuntu:14.04

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
    echo "deb http://repo.percona.com/apt "$(lsb_release -sc)" main" | tee /etc/apt/sources.list.d/percona.list && \
    apt-get update && \
    apt-get install -y --force-yes pwgen percona-server-mongodb fuse sshfs 

RUN adduser root fuse

VOLUME /data/db
VOLUME /backup

ENV STORAGE_ENGINE rocksdb
ENV AUTH yes
ENV JOURNALING no
ENV REMOTE_HOST "" 
ENV MAX_BACKUPS=10
ENV INIT_BACKUP=yes
ENV MONGODB_HOST=localhost
ENV MONGODB_PORT=27017
ENV MONGODB_DATABASE=admin
ENV MONGODB_USER=admin
ENV MONGODB_PASS=""
ENV SUBFOLDER=openparse
ENV BACKUPS=yes
ENV CRON_TIME="0 0 * * *"

EXPOSE 27017 28017
CMD ["/run.sh"]

ADD run.sh /run.sh
ADD backup.sh /backup.sh
