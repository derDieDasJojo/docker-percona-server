#!/bin/bash
echo "startin backup .."

BACKUP_NAME=$(date +\%Y.\%m.\%d.\%H\%M\%S)
BACKUP_PATH="/backup/$SUBFOLDER/$BACKUP_NAME"
#mkdir -p "$BACKUP_PATH.tmp"
mkdir -p /backup/$SUBFOLDER
#BACKUP_PATH="/backup/$BACKUP_NAME"

echo mongo $MONGODB_DATABASE -u $MONGODB_USER -p $MONGODB_PASS --host $MONGODB_HOST --port $MONGODB_PORT --eval "db.adminCommand({setParameter:1, rocksdbBackup:\"$BACKUP_PATH\"})"
mongo $MONGODB_DATABASE -u $MONGODB_USER -p $MONGODB_PASS --host $MONGODB_HOST --port $MONGODB_PORT --eval "printjson(db.adminCommand({setParameter:1, rocksdbBackup:\"$BACKUP_PATH\"}))"
echo "done!"

sleep 30000
