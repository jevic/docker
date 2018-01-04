#!/bin/bash
: ${SPARK_HOME:=/opt/spark}

$SPARK_HOME/conf/spark-env.sh

if [[ $1 == "master" ]]; then
## master
  /usr/sbin/sshd
  $SPARK_HOME/sbin/start-master.sh
  #/usr/sbin/crond
  while true; do sleep 1000; done
elif [[ $1 == "all" ]];then
## all
  /usr/sbin/sshd
  $SPARK_HOME/sbin/start-all.sh
  #/usr/sbin/crond
  while true; do sleep 1000; done
else
  /usr/sbin/sshd -D
fi

exec "$@"
