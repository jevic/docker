#!/bin/bash
set -e

if [[ ! $REDIS_AUTH ]] || [[ ! $MASTERIP ]];then
   echo "请设置认证密码.....REDIS_AUTH"
   echo "请配置Redis Master: 192.168.1.1 MASTERIP"
   echo "master 端口默认为 6379 MASTERPORT"
   exit
fi

if [[ ! $MASTERPORT ]];then
   MASTERPORT=6379
fi
echo -e "master: $MASTERIP\n认证密码: $REDIS_AUTH\n端口: $MASTERPORT"
echo ' '
sed -i "s/REDIS_AUTH/${REDIS_AUTH}/g" /usr/local/etc/redis/redis.conf
sed -i "s/MASTERIP/${MASTERIP}/g" /usr/local/etc/redis/redis.conf
sed -i "s/MASTERPORT/${MASTERPORT}/g" /usr/local/etc/redis/redis.conf

redis-server /usr/local/etc/redis/redis.conf

exec "$@"
