#!/bin/bash
#
if [[ ! $HOST ]];then
    HOST="0.0.0.0"
fi

if [[ ! $SERVERS_HOSTS ]] || [[ ! $ETCD_ID ]];then
   echo -e "\033[31m配置错误,检查环境变量配置\033[0m"
   echo -e "\033[32m
变量参数说明:\033[0m
ETCD_ID          指定id(必须):
HOST             指定监听IP地址(默认 0.0.0.0)
SERVERS_HOSTS    指定集群主机IP列表(必须)-空格分割 
      -- 示例:   192.168.1.2 192.168.1.3 192.168.1.4"
    exit 
else
    NODE_01=`echo $SERVERS_HOSTS|awk '{print $1}'`
    NODE_02=`echo $SERVERS_HOSTS|awk '{print $2}'`
    NODE_03=`echo $SERVERS_HOSTS|awk '{print $NF}'`
echo -e "\033[33m/bin/etcd --name etcd${ETCD_ID} \
--data-dir /var/lib/etcd \
--initial-advertise-peer-urls http://${HOST}:2380 \
--listen-peer-urls http://${HOST}:2380 \
--listen-client-urls http://${HOST}:2379 \
--advertise-client-urls http://${HOST}:2379 \
--initial-cluster-token etcd-cluster-dt \
--initial-cluster etcd1=http://${NODE_01}:2380,etcd2=http://${NODE_02}:2380,etcd3=http://${NODE_03}:2380 \
--initial-cluster-state new\033[0m"
echo -e "\033[33m------------------------------------------------------\033[0m"
sleep 5

/bin/etcd --name etcd${ETCD_ID} \
--data-dir /var/lib/etcd \
--initial-advertise-peer-urls http://${HOST}:2380 \
--listen-peer-urls http://${HOST}:2380 \
--listen-client-urls http://${HOST}:2379,http://127.0.0.1:2379 \
--advertise-client-urls http://${HOST}:2379,http://127.0.0.1:2379 \
--initial-cluster-token etcd-cluster-dt \
--initial-cluster etcd1=http://${NODE_01}:2380,etcd2=http://${NODE_02}:2380,etcd3=http://${NODE_03}:2380 \
--initial-cluster-state new
fi

exec "$@"
