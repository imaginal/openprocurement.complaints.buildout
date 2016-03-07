#!/bin/bash

BASEDIR=${buildout:directory}
ANGELSH=$BASEDIR/bin/complaints_angel.sh
PIDFILE=$BASEDIR/var/complaints_angel.pid
INIFILE=$BASEDIR/etc/complaints_queue.ini

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
  cd $BASEDIR/var
  nohup $ANGELSH &
  sleep 1
}

angel_stop()
{
  PIDCHLD=`grep pidfile $INIFILE | cut -d= -f2`
  test -s $PIDCHLD && kill `cat $PIDCHLD`
  test -s $PIDFILE && kill `cat $PIDFILE`
}

angel_restart()
{
  angel_stop
  sleep 2
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
	restart) angel_restart ;;
	status) angel_status ;;
    *) echo "Usage: $0 {start|stop|restart|status}" 1>&2 ;;
esac

