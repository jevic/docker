#!/bin/bash
config2=$2

case $1 in 
        qps)
           curl -s "http://localhost:8099" -H "host:nginx_monitor"|python -m json.tool|grep "finish_requests_per_sec"|awk '{print $2}'|sed 's/,//g';;

        billing)
           curl -s "http://localhost:8099" -H "host:nginx_monitor"|python -m json.tool|grep "cache_last_billing_report_time"|awk '{print $2}'|sed 's/,//g';;

        count)
           curl -s "http://localhost:8099" -H "host:nginx_monitor"|python -m json.tool|grep -w "\"$config2\":"|head -1|awk '{print $2}'|sed 's/,//g';;

        per)
           curl -s "http://localhost:8099" -H "host:nginx_monitor"|python -m json.tool|grep -w "\"$config2\":"|tail -1|awk -F\" '{print $4}'|sed 's/%//g';;

        *)
           echo "Usage: $0 { qps | billing | count | per }" ;;
esac
