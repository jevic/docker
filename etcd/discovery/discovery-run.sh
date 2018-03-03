#!/bin/bash
#
discovery_url="$1"

if [[ ! $discovery_url ]] || [[ ! $ETCD_ID ]];then
   echo "请输入id 和 discovery_url..."
   exit
fi

echo -e "\033[33metcd --name etcd${ETCD_ID} \
--data-dir /var/lib/etcd \
--initial-advertise-peer-urls http://0.0.0.0:2380 \
--listen-peer-urls http://0.0.0.0:2380 \
--listen-client-urls http://0.0.0.0:2379 \
--advertise-client-urls http://0.0.0.0:2379 \
--discovery ${discovery_url}\033[0m"

etcd --name etcd${ETCD_ID} \
--data-dir /var/lib/etcd \
--initial-advertise-peer-urls http://0.0.0.0:2380 \
--listen-peer-urls http://0.0.0.0:2380 \
--listen-client-urls http://0.0.0.0:2379 \
--advertise-client-urls http://0.0.0.0:2379 \
--discovery ${discovery_url}
