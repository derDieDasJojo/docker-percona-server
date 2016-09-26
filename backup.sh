#!/bin/bash
echo "startin backup .."

BACKUP_NAME=$(date +\%Y.\%m.\%d.\%H\%M\%S)

if [ "$SUBFOLDER" != "" ]; then
  BACKUP_PATH="/backup/$SUBFOLDER/$BACKUP_NAME"
  mkdir -p /backup/$SUBFOLDER
else
  BACKUP_PATH="/backup/$BACKUP_NAME"
fi

if [ "$MONGODB_USER" != "" ]; then
    OPS="$OPS -u $MONGODB_USER"
fi

if [ "$MONGODB_PASS" != "" ]; then
    OPS="$OPS -p $MONGODB_PASS"
fi

MONGODB_DATABASE=${MONGODB_DATABASE:-"admin"}
echo mongo $MONGODB_DATABASE $OPS --host $MONGODB_HOST --port $MONGODB_PORT --eval "printjson(db.adminCommand({setParameter:1, rocksdbBackup:\"$BACKUP_PATH\"}))"
mongo $MONGODB_DATABASE $OPS --host $MONGODB_HOST --port $MONGODB_PORT --eval "printjson(db.adminCommand({setParameter:1, rocksdbBackup:\"$BACKUP_PATH\"}))"

echo "done!"

sleep 30000
