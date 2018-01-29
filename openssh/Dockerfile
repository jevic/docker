FROM centos:7.2.1511
MAINTAINER jieyang <admin@jevic.cn>
ENV EFRESHED_AT 2018-01-29
ENV TZ Asia/Shanghai

## 安装运行依赖
RUN yum install -y openssh-server wget openssh-clients which rsync \
    && rm -rf /tmp/* && yum clean all

## SSH
RUN set -e \
    && ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
    && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' \
    && ssh-keygen -f /root/.ssh/id_rsa -N '' \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys \
    && echo "root:P@sswd123456" | chpasswd \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime

COPY config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
