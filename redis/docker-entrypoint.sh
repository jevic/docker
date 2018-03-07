#!/bin/bash
set -e


if [[ ! $REDIS_AUTH ]];then
   echo "请设置认证密码....."
   exit
else
  sed -i "s/REDIS_AUTH/${REDIS_AUTH}/g" /usr/local/etc/redis/redis.conf
fi

redis-server /usr/local/etc/redis/redis.conf

exec "$@"
