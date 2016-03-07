#!/bin/bash

BASEDIR=${buildout:directory}
PIDFILE=$BASEDIR/var/complaints_angel.pid
INIFILE=$BASEDIR/etc/complaints_queue.ini
PIDCHLD=`grep pidfile $INIFILE | cut -d= -f2`

on_exit()
{
  test -s $PIDCHLD && kill `cat $PIDCHLD`
  test -f $PIDFILE && rm -f $PIDFILE
  exit
}

echo $$ >$PIDFILE
trap on_exit SIGINT SIGTERM

while true
do
  $BASEDIR/bin/complaints_queue $INIFILE \
    >>$BASEDIR/var/log/complaints_queue.log 2>&1
  sleep 10
done
