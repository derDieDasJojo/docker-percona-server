FROM ubuntu:14.04

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A && \
    echo "deb http://repo.percona.com/apt "$(lsb_release -sc)" main" | tee /etc/apt/sources.list.d/percona.list && \
    apt-get update && \
    apt-get install -y --force-yes pwgen percona-server-mongodb fuse sshfs 

RUN adduser root fuse

VOLUME /data/db
VOLUME /backup

ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh

EXPOSE 27017 28017

ENV STORAGE_ENGINE rocksdb
ENV AUTH yes
ENV JOURNALING no

CMD ["/run.sh"]
