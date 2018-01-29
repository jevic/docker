# [DCMP](https://github.com/silenceper/dcmp)

Distributed Configuration Management Platform

提供了一个etcd的管理界面，可通过界面修改配置信息，借助confd可实现配置文件的同步。

# 运行
### 变量
- ETCD_HOST etcd服务地址,默认为 127.0.0.1
- ROOT  配置根目录,默认为 /config 需要在etcd手动创建


``` sh
docker run -d --name dcmp -p 8000:8000 \
-e ETCD_HOST=x.x.x.x \
-e ROOT=root
jevic/etcd:dcmp
```

