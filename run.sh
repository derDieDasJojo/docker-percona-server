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

#start chronjobs
if [ "$BACKUPS" != "no" ]; then
    crontab  /crontab.conf &
fi

#start mongodb
$cmd &

if [ "$MONGODB_PASS" != "" ]; then
    echo "=> Creating an ${USER} user with a password in MongoDB"
    mongo admin --eval "db.createUser({user: '$USER', pwd: '$MONGODB_PASS', roles:[{role:'root',db:'admin'}]});"
    mongo admin --eval "db.createUser({user: '$USER', pwd: '$MONGODB_PASS', roles: [ "dbOwner" ]});"
    mongo admin --eval "db.createUser({user: '$USER', pwd: '$MONGODB_PASS', roles: [{ role: "root", db: "admin" }] }); "

    if [ "$DATABASE" != "admin" ]; then
        echo "=> Creating an ${USER} user with a password in MongoDB"
        mongo admin -u $USER -p $MONGODB_PASS << EOF
use $DATABASE
db.createUser({user: '$USER', pwd: '$MONGODB_PASS', roles:[{role:'dbOwner',db:'$DATABASE'}]})
EOF
    fi
    touch /data/db/.mongodb_password_set

    echo "========================================================================"
    echo "You can now connect to this MongoDB server using:"
    echo "    mongo $DATABASE -u $USER -p $MONGODB_PASS --host <host> --port <port>"
    echo "========================================================================"
fi

if [ -z "$REMOTE_HOST"]; then
    echo "adding remote folder.."
    sshfs -o nonempty $REMOTE_USER@$REMOTE_HOST:/$REMOTE_PATH /backup
fi

if [ -n "${INIT_BACKUP}" ]; then
    echo "=> Create a backup on the startup"
    /backup.sh $PASS
elif [ -n "${INIT_RESTORE_LATEST}" ]; then
    echo "=> Restore lates backup"
    #until nc -z $MONGODB_HOST $MONGODB_PORT
    #do
    #    echo "waiting database container..."
    #    sleep 1
    #done
    #ls -d -1 /backup/* | tail -1 | xargs /restore.sh
fi


fg
#kill $!
#cmd="$cmd"
#$cmd
