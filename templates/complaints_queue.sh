#!/bin/sh

BASEDIR=${buildout:directory}
PIDFILE=$BASEDIR/var/complaints_angel.pid

echo $$ >$PIDFILE
trap "{ rm -f $PIDFILE; exit; }" SIGTERM

while true
do
  $BASEDIR/bin/complaints_queue \
    $BASEDIR/etc/complaints_queue.ini \
    1>>$BASEDIR/var/log/queue.stdout.log \
    2>>$BASEDIR/var/log/queue.stderr.log
  sleep 10
done
