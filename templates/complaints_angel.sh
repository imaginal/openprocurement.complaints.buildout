#!/bin/bash

BASEDIR=/srv/complaints.queue
PIDFILE=/run/complaints_angel.pid
INIFILE=/etc/complaints.queue/complaints_queue.ini
LOGFILE=/var/log/complaints.queue/complaints_queue.log
PIDCHLD=`grep pidfile $INIFILE | cut -d= -f2`

on_exit()
{
  test -s $PIDCHLD && kill `cat $PIDCHLD`
  test -f $PIDFILE && rm -f $PIDFILE
  test -f nohup.out && rm nohup.out
  exit
}

echo $$ >$PIDFILE
trap on_exit SIGINT SIGTERM

while true
do
  $BASEDIR/bin/complaints_queue $INIFILE >>$LOGFILE 2>&1
  EXITCODE=$?
  echo `date +"%Y-%m-%d %H:%M:%S"` Exit with code $EXITCODE >>$LOGFILE
  sleep 5
done

