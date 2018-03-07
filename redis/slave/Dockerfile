FROM redis:3.2.11
COPY redis-slave.conf /usr/local/etc/redis/redis.conf
ADD docker-entrypoint.sh /
CMD [ "/docker-entrypoint.sh"]
