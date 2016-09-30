### Nginx 日志切割脚本	
	#!/bin/bash
	nginx_logs_dir="/var/log/nginx/web/"
	#nginx_pid_file="/var/log/nginx/nginx.pid"

	pid=`ps -ef|grep nginx|grep apache|awk '{print $3}'`
	nginx_log_today="$nginx_logs_dir/access_`date +%Y%m%d`.log"

	[ -f "$nginx_log_today" ] && exit 1

	mv $nginx_logs_dir/access.log $nginx_log_today
	/bin/kill -USR1 ${pid}

	#[ -f $nginx_pid_file ] && /bin/kill -USR1 $(cat $nginx_pid_file)

### 设置syslog 驱动：
### 关于rsyslog 详细使用说明查看 [鸟哥Linux私房菜文档-第十九章、认识与分析登录文件](http://cn.linux.vbird.org/linux_basic/0570syslog.php)
	[root@node1 ]# cat /etc/rsyslog.conf
	.........
	# Log anything (except mail) of level info or higher.
	# Don't log private authentication messages!
	*.info;mail.none;authpriv.none;cron.none;local1.none;local2.none     /var/log/messages  //不将日志重复输出到messages文件
	local1.* 						/var/log/nginx     // 添加此项
	& ~
	local2.*						/var/log/web2log    // 添加此项
	& ~
	.........
	[root@node1 ]# vim /etc/logrotate.d/syslog 
	/var/log/cron
	/var/log/maillog
	/var/log/messages
	/var/log/secure
	/var/log/spooler
	`/var/log/nginx`      //添加此项
    `/var/log/web2log`    // 添加此项,默认将会在/var/log 下创建对应文件并写入日志
	{
	    missingok
	    sharedscripts
	    postrotate
		/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
	    endscript
	}
	
	启动容器[`syslog-facility` --> 此项对应设置的日志]
	[root@node1 ]# docker run -d --name nginx --log-driver=syslog --log-opt syslog-facility=`local1` -p 81:80 nginx:v1
	[root@node1 ]# docker run -d --name web2 --log-driver=syslog --log-opt syslog-facility=`local2` -p 82:80 nginx:v1
	访问链接查看日志：
	[root@node1 ]# ll -h /var/log/{nginx,dp1web}
	-rw------- 1 root root  89K 9月  30 10:45 /var/log/dp1web
	-rw------- 1 root root 6.0K 9月  30 10:48 /var/log/nginx

### journald日志驱动：
	https://docs.docker.com/engine/admin/logging/journald/
	首先容器的日志设置要为stdout、stderr 
	# docker run -d --name n1 --log-driver=journald -p 90:80 nginx
	# journalctl CONTAINER_NAME=n1
	使用python脚本收集日志:
	# yum install python2-systemd -y
	# cat log.py
	#!/usr/bin/python
	import systemd.journal
	reader = systemd.journal.Reader()
	reader.add_match('CONTAINER_NAME=web')

	for msg in reader:
	  print '{CONTAINER_ID_FULL}: {MESSAGE}'.format(**msg)
	
### fluentd 日志驱动
	下载镜像：https://hub.docker.com/r/fluent/fluentd/
	https://docs.docker.com/engine/admin/logging/fluentd/
	fluentd官网文档(http://docs.fluentd.org/)
	check config file:
	$ fluentd --dry-run -c fluent.conf
