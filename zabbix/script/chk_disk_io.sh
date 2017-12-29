#!/bin/bash
#block device info for disk store

case "$2" in
    rkB)
        /usr/bin/iostat -x 1 2|grep $1|awk 'NR==2{print $6}'
        ;;
    wkB)
        /usr/bin/iostat -x 1 2|grep $1|awk 'NR==2{print $7}'
        ;;
    util)
        /usr/bin/iostat -x 1 2|grep $1|awk 'NR==2{print $NF}'
        ;;
esac
