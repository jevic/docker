#!/bin/bash
#
discovery_url="$1"

if [[ ! $discovery_url ]];then
   echo "请输入discovery_url..."
   exit
fi

echo "\033[33metcd --name etcd1 \
--data-dir /var/lib/etcd \
--initial-advertise-peer-urls http://0.0.0.0:2380 \
--listen-peer-urls http://0.0.0.0:2380 \
--listen-client-urls http://0.0.0.0:2379 \
--advertise-client-urls http://0.0.0.0:2379 \
--discovery ${discovery_url}\033[0m"

etcd --name etcd1 \
--data-dir /var/lib/etcd \
--initial-advertise-peer-urls http://0.0.0.0:2380 \
--listen-peer-urls http://0.0.0.0:2380 \
--listen-client-urls http://0.0.0.0:2379 \
--advertise-client-urls http://0.0.0.0:2379 \
--discovery ${discovery_url}
