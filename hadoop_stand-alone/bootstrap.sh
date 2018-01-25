#!/bin/bash

: ${HADOOP_HOME:=/opt/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh


if [[ $1 == "-d" ]]; then
## 格式化并启动
  $HADOOP_HOME/bin/hdfs namenode -format
  /usr/sbin/sshd
  $HADOOP_HOME/sbin/start-dfs.sh
  while true; do sleep 1000; done
elif [[ $1 == "-s" ]];then
## 无格式化启动
  /usr/sbin/sshd
  $HADOOP_HOME/sbin/start-dfs.sh
  while true; do sleep 1000; done
else
  /usr/sbin/sshd -D
fi

exec "$@"
