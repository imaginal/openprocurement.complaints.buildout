#!/bin/bash

### BEGIN INIT INFO
# Provides:          complaints-queue
# Required-Start:    $network $remote_fs $syslog $all
# Required-Stop:     $network $remote_fs $syslog  
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

BASEDIR=/srv/complaints.queue
ANGELSH=$BASEDIR/bin/complaints_angel.sh
PIDFILE=/run/complaints_angel.pid
INIFILE=/etc/complaints.queue/complaints_queue.ini

angel_alive()
{
  if [ -s $PIDFILE ] ; then
    if ps ax | grep `cat $PIDFILE` | grep complaints ; then
      return 0
    fi
  fi
  return 1
}

angel_start()
{
  if angel_alive ; then
    echo Pidfile $PIDFILE exists and service is runnning
    exit 1
  fi
  cd $BASEDIR
  nohup $ANGELSH >/dev/null 2>&1 &
  sleep 1
}

angel_stop()
{
  PIDCHLD=`grep pidfile $INIFILE | cut -d= -f2`
  test -s $PIDCHLD && kill `cat $PIDCHLD`
  test -s $PIDFILE && kill `cat $PIDFILE`
  test -f $BASEDIR/nohup.out && rm -f $BASEDIR/nohup.out
}

angel_reload()
{
  PIDCHLD=`grep pidfile $INIFILE | cut -d= -f2`
  test -s $PIDCHLD && kill `cat $PIDCHLD`
}

angel_restart()
{
  angel_stop
  sleep 3
  angel_start
}

angel_status()
{
  if angel_alive ; then
    echo "alive"
  else
    echo "dead"
  fi
}

case "$1" in
  start) angel_start ;;
  stop) angel_stop ;;
  reload) angel_reload ;;
  restart) angel_restart ;;
  status) angel_status ;;
  *) echo "Usage: $0 {start|stop|restart|reload|status}" 1>&2 ;;
esac

