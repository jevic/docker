Redis
====
- 默认数据目录: /data

docker run --name redis-master -d -p 6379:6379 -e REDIS_AUTH=xxxxx jevic/redis:master
