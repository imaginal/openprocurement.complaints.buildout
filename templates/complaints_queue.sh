#!/bin/sh

while true
do
  ${buildout:directory}/bin/complaints_queue \
    ${buildout:directory}/etc/complaints_queue.ini \
    1>>${buildout:directory}/var/log/queue.stdout.log \
    2>>${buildout:directory}/var/log/queue.stderr.log
  sleep 10
done
