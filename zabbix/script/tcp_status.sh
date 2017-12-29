#!/bin/bash
num=`/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep $1 | awk '{print $2}'`

if [ -z $num ];then
    echo 0
else
    echo $num
fi
