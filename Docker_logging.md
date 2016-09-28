### 设置syslog 驱动：
	[root@node1 logrotate.d]# pwd
	/etc/logrotate.d
	[root@node1 logrotate.d]# ls
	chrony  mariadb  ppp  syslog  wpa_supplicant  yum
	[root@node1 logrotate.d]# cat syslog 
	/var/log/cron
	/var/log/maillog
	/var/log/messages
	/var/log/secure
	/var/log/spooler
	/var/log/local1
	{
	    missingok
	    sharedscripts
	    postrotate
		/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
	    endscript
	}
	[root@node1 logrotate.d]# cat ../rsyslog.conf |grep nginx
	local1.* 						/var/log/nginx.log
	[root@node1 ]# docker run -d --name n8 --log-driver=syslog --log-opt syslog-facility=local1 -p 88:80 nginx:v1
	[root@node1 ]# ls /var/log/nginx.log
	待解决问题： message 和nginx.log 都有输出？？？？

### journald日志驱动：
	https://docs.docker.com/engine/admin/logging/journald/
	# docker run -d --name n1 --log-driver=journald -p 90:80 nginx
	# journalctl CONTAINER_NAME=n1
	
### fluentd 日志驱动
	下载镜像：https://hub.docker.com/r/fluent/fluentd/
	https://docs.docker.com/engine/admin/logging/fluentd/



