#!/bin/bash
: ${SPARK_HOME:=/opt/spark}

$SPARK_HOME/conf/spark-env.sh

if [[ $SPARK_MASTER ]];then
   /usr/sbin/sshd
   $SPARK_HOME/sbin/start-slave.sh spark://$SPARK_MASTER:7077
   while true; do sleep 1000; done
else
  echo "请指定 SPARK_MASTER  地址 ........"
  /usr/sbin/sshd -D
fi

exec "$@"
