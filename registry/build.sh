#!/bin/bash
## Docker registry 构建    
## Version : 1.0                      
## author: zxf_668899

REGS="registry:latest"
DATES=`date '+%Y-%m-%d %H:%M:%S'`
## 判断是否已存在仓库运行
PORTS=`netstat -tnlp|grep 443|wc -l`
PSS=`docker ps |grep 'registry'|wc -l`

if [ $PORTS -eq 1 -a $PSS == 0 ];then
   echo -e "\033[31m <-- 443端口已经被其他程序占用 -->\033[0m" 
   exit "`echo $RANDOM|cut -c 1,2`"
elif [ $PORTS -eq 1 -a $PSS == 1 ] 
then
   echo -e "\033[31m <-- 已有仓库在运行 --> \033[0m"
   exit "`echo $RANDOM|cut -c 1,2`"
else
  echo -e "\033[35m--- Docker Registry ---\033[0m"
fi

## 运行容器
Regs () {
docker run -d \
-p 443:5000 \
--name registry \
--restart=always \
-v /var/lib/registry:/var/lib/registry \
-v `pwd`/auth:/auth \
-e REGISTRY_AUTH=htpasswd \
-e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
-v `pwd`/certs:/certs \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/ca.crt \
-e REGISTRY_HTTP_TLS_KEY=/certs/ca.key \
$REGS
}

## 设定变量
echo -e "\033[32m请输入用户名:\033[0m" && read -p '' USERS
echo -e "\033[32m请输入密码:\033[0m" && read -p '' PASSWD
echo -e "\033[32m请输入域名:\033[0m" && read -p '' DOMAIN
echo ''
echo -e "创建时间: ${DATES}\nuser: $USERS\npasswd: $PASSWD\n域名: $DOMAIN" > registry.log
## 初始化目录
## 
if [ ! -f `pwd`/auth/htpasswd -o ! -d `pwd`/certs/ca.crt ];then
	mkdir -p `pwd`/{auth,certs}
fi

## 生成密码文件
docker run --entrypoint htpasswd ${REGS} -Bbn ${USERS} ${PASSWD} > auth/htpasswd

## 配置证书文件
openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/ca.key -x509 -days 365 -out certs/ca.crt <<EOF
CN
GD
SZ
SOFT
APP
$DOMAIN
jevic@test.com
EOF

if [ $? == 0 ];then
   echo -e "\n\033[32m<-- 生成证书成功 -->\033[0m"
else
   echo -e "\n\033[31m<-- 生成证书失败 -->\033[0m"
   exit 11
fi

if [ -f /etc/docker/certs.d/${DOMAIN}/ca.crt ];then
     rm -rf /etc/docker/certs.d/${DOMAIN}
else 
   mkdir -p /etc/docker/certs.d/${DOMAIN}
   cp -a certs/ca.crt /etc/docker/certs.d/${DOMAIN}/
fi

## 重启 Docker
echo -e "\033[32m*** 重启docker ***\n....\033[0m"
systemctl daemon-reload && systemctl restart docker
## Run
echo -e "\033[32m*** 运行仓库 ***\033[0m"
Regs
if [ $? -eq 0 ];then
  echo -e "\033[32m*** 仓库构建完成 ***\033[0m"
else
  echo -e "\033[31m*** 仓库构建失败 ***\033[0m"
  exit 1
fi