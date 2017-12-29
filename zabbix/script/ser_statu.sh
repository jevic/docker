#!/bin/bash
dname="$1"  #监测域名
dt=`date +%H -d '-10 minute'`   #监测nginx日志时
mie=`date +%M -d '-10 minute' |cut -c 1`	#监测nginx日志分

#取监测时间段内首包时间超过0.3秒的访问数
m=`grep "2016:$dt:$mie[0-9]:" /data/log/nginx/access.log |grep $dname |awk '$(NF-1)>0.3{print}'|wc -l` 

#取监测时间段内访问总数
al=`grep "2016:$dt:$mie[0-9]:" /data/log/nginx/access.log |grep $dname |awk '{print}'|wc -l`

#访问总数必须大于0
if [ $al -gt 0 ];then
	res0=`echo "scale=5;$m/$al"|bc |awk '{printf "%.2f%%\n", $0*100}'`	#nginx首包超时比（百分数）
	res=`echo "scale=5;$m/$al"|bc`						#nginx首包超时比（小数）
	res1=`echo "scale=5;$m/$al"|bc |cut -c 3`				#小数点后第二位（百分数个位）
	res2=`echo "scale=5;$m/$al"|bc |cut -c 2`				#小数点后第一位（百分数十位）
else
	echo "no records"		#无访问记录
	exit 1
fi

function Err50X()
{
	err50x=`grep "2016:$dt:$mie[0-9]:" /data/log/nginx/access.log |grep $dname |awk '$8>499{print}'|wc -l`
	if [ $err50x -gt 2 ];then
		echo "$dt:$mie"0" 50X ERROR:$err50x"
	else
		return 2
	fi
}

function NgxTMOUT()
{
	if [[ "$res1" =~ [1-9] ]] || [[ "$res2" =~ [1-9] ]];then
		echo "$dt:$mie"0" NGX TimeOut ERROR: $res0"
	else
		echo "NGX TimeOut: $res0"
		return 3
	fi
}

function OctTMOUT()
{
	ymd=`date +"%Y-%m-%d" -d '-10 minute'`
        #取监测时间段内首包时间超过0.3秒的访问数
        m=`egrep "$ymd $dt:$mie[0-9]:" /data/log/octopus/access.log |grep $dname |awk '$(NF-1)>300{print}'|wc -l`

        #取监测时间段内访问总数
        al=`egrep "$ymd $dt:$mie[0-9]:" /data/log/octopus/access.log |grep $dname |awk '{print}'|wc -l`

        #访问总数必须大于0
        if [ $al -gt 0 ];then
                res0=`echo "scale=5;$m/$al"|bc |awk '{printf "%.2f%%\n", $0*100}'`      #nginx首包超时比（百分数）
                res=`echo "scale=5;$m/$al"|bc`                                          #nginx首包超时比（小数）
                res1=`echo "scale=5;$m/$al"|bc |cut -c 3`                               #小数点后第二位（百分数个位）
                res2=`echo "scale=5;$m/$al"|bc |cut -c 2`                               #小数点后第一位（百分数十位）
        fi
	
        if [[ "$res1" =~ [1-9] ]] || [[ "$res2" =~ [1-9] ]];then
                echo "$dt:$mie"0" OCT TimeOut ERROR: $res0"
        else
		echo "OCT TimeOut: $res0"
                return 4
        fi
	
}

Err50X
h1=$?
NgxTMOUT
h2=$?
OctTMOUT
h3=$?

if  [ $h1 -gt 0 ] && [ $h2 -gt 0 ] && [ $h3 -gt 0 ];then
	echo ok
fi
