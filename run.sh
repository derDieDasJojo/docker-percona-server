#!/bin/bash
set -m

mongodb_cmd="mongod --storageEngine $STORAGE_ENGINE"
cmd="$mongodb_cmd --httpinterface --rest --master"
if [ "$AUTH" == "yes" ]; then
    cmd="$cmd --auth"
fi

if [ "$JOURNALING" == "no" ]; then
    cmd="$cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ]; then
    cmd="$cmd --oplogSize $OPLOG_SIZE"
fi

$cmd &

if [ ! -f /data/db/.mongodb_password_set ]; then
    /set_mongodb_password.sh
fi

if [ -z "$REMOTE_HOST"]; then
    echo "adding remote folder.."
    sshfs -o nonempty $REMOTE_USER@$REMOTE_HOST:/$REMOTE_PATH /backup
fi

fg
#kill $!
#cmd="$cmd"
#$cmd
