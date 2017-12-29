#!/bin/sh

d=`date '+%F %T'`

thread="zabbix_agentd"

num=`ps -ef | grep "$thread" | egrep -v 'grep|moni' | wc -l`
if [ $num -lt 1 ];then
        echo "[$d] $thread is dead...restarting" >> /var/log/moni_$thread.log
	    /etc/init.d/zabbix-agent start
else
        echo "[$d] $thread is running" >> /var/log/moni_$thread.log
fi

#if log file is too large , erase it ..

fsize=`ls -l /var/log/moni_$thread.log | awk '{ print $5}'`
if [ $fsize -gt 200000000 ]; then
        echo "[$d] log file is too large..." $fsize;
        >/var/log/moni_$thread.log
fi
