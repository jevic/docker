redis-slave
=========
- redis slave 节点

## run

docker run -d --name redis-slave \
-p 6379:6379 \
-e REDIS_AUTH=xxxx \
-e MASTERIP=192.168.1.1 \
-e MASTERPORT=6379 \
jevic/redis:slave 
