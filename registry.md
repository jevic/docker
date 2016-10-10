#### <span id = "1">启用TLS</span>
	[root@registry ]# openssl genrsa -out server.key 2048
	Generating RSA private key, 2048 bit long modulus
	.....................................................................+++
	............................+++
	e is 65537 (0x10001)
	[root@registry ]# openssl req -new -key server.key -out server.csr
	You are about to be asked to enter information that will be incorporated
	into your certificate request.
	What you are about to enter is what is called a Distinguished Name or a DN.
	There are quite a few fields but you can leave some blank
	For some fields there will be a default value,
	If you enter '.', the field will be left blank.
	-----
	Country Name (2 letter code) [XX]:CN
	State or Province Name (full name) []:gd   
	Locality Name (eg, city) [Default City]:sz
	Organization Name (eg, company) [Default Company Ltd]:af
	Organizational Unit Name (eg, section) []:soft
	Common Name (eg, your name or your server's hostname) []:myregistry.com
	Email Address []:
	
	Please enter the following 'extra' attributes
	to be sent with your certificate request
	A challenge password []:
	An optional company name []:
	[root@registry ]# openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
	Signature ok
	subject=/C=CN/ST=gd/L=sz/O=af/OU=soft/CN=myregistry.com
	Getting Private key
	[root@registry ]# vim /etc/hosts
	10.2.229.70 myregistry.com
	
	[root@registry ]# ls
	server.crt  server.csr  server.key
	[root@registry ]# cp server.crt /etc/pki/ca-trust/source/anchors/
	[root@registry ]# update-ca-trust enable
	[root@registry ]# update-ca-trust extract
	[root@registry ]# systemctl daemon-reload
	[root@registry ]# systemctl restart docker
	
	[root@registry ]# docker run -d \
	-p 5000:5000 \
	--name registry \
	-v /opt/registry:/certs \
	-v /opt/registry/data:/var/lib/registry \
	-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/server.crt \
	-e REGISTRY_HTTP_TLS_KEY=/certs/server.key \
	registry:2
	
	[root@registry ]# docker tag nginx:1.10-alpine myregistry.com:5000/nginx:10
	[root@registry ]# docker push myregistry.com:5000/nginx:10
	The push refers to a repository [myregistry.com:5000/nginx]
	9ed2bcea985f: Pushed 
	2afb9fbab89e: Pushed 
	2d7992446f1c: Pushed 
	4fe15f8d0ae6: Pushed 
	10: digest: sha256:d76a8cfb65f5f431916dde1eed84e72d37df26366564aa613219ddc1d8daa6d6 size: 1154

#### <span id = "2">配置用户名密码认证</span>
	yum install httpd-tools
	mkdir -p /opt/registry/auth
	htpasswd -c /opt/registry/auth/htpasswd testuser
#### <span id="3">Composefile:</span>
	registry:
	  restart: always
	  image: registry:2
	  ports:
	    - 5000:5000
	  environment:
	    REGISTRY_HTTP_TLS_CERTIFICATE: /certs/domain.crt
	    REGISTRY_HTTP_TLS_KEY: /certs/domain.key
	    REGISTRY_AUTH: htpasswd
	    REGISTRY_AUTH_HTPASSWD_PATH: /auth/htpasswd
	    REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
	  volumes:
	    - /path/data:/var/lib/registry
	    - /path/certs:/certs
	    - /path/auth:/auth
##### 参考链接
	[nginx代理认证](https://docs.docker.com/registry/recipes/nginx/)
	[deploying](https://docs.docker.com/registry/deploying/)
