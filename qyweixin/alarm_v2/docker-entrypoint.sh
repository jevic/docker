#!/bin/sh
set -e
Files=/alarm/weixin.py

if [ -z $token ];then
   echo -e "\033[31m请配置token\033[m" 
   exit
else
   echo "token: $token"
   sed -i "s/TOKEN/$token/g" $Files
fi

exec "$@"
