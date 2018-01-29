#!/bin/bash

Conf=/opt/dcmp/config/config.yml

if [ $ETCD_HOST ];then
   sed -i "s/127.0.0.1/$ETCD_HOST/g" $Conf
fi

if [ $ROOT ];then
   sed -i "s/config/$ROOT/g" $Conf
fi


exec "$@"
