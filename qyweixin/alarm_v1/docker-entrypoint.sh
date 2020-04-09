#!/bin/sh
set -e
Files=/alarm/alarm.py

if [ -z "$Token" ];then
   echo -e "\033[31m请配置机器人Token:   \033[m\n\
Example: -e Token=xxxx\n"
else
    sed -i "s/TOKEN=.*/Token = '$Token'/g" $Files
    echo "Token = $Token"
fi

exec "$@"
