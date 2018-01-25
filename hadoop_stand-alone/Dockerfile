FROM centos:7.2.1511
MAINTAINER jieyang <admin@jevic.cn>
ENV EFRESHED_AT 2017-12-18
ENV Version 8.0
ENV JDK jdk-8u144-linux-x64.tar.gz
ENV TZ Asia/Shanghai
ENV JAVA_HOME /opt/jdk
ENV HADOOP_HOME /opt/hadoop

## 安装运行依赖
RUN yum install -y wget openssh-server openssh-clients which rsync \
    && rm -rf /tmp/* && yum clean all

## Java    
RUN cd /opt && wget http://ftp.kernel.yunfan.com/docker/java/$JDK \
    && tar zxf $JDK && mv jdk1.8.0_144 jdk \
    && chown root.root -R /opt/jdk && rm -rf *.gz 
    
## SSH
RUN set -e \
    && ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
    && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' \
    && ssh-keygen -f /root/.ssh/id_rsa -N '' \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys \
    && cd /root/.ssh && wget http://ftp.kernel.yunfan.com/docker/hadoop/config \
    && chmod 600 /root/.ssh/config \
    && echo "root:P@sswd123456" | chpasswd

## PATH环境变量
ENV CLASSPATH .:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/jre/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH ${JAVA_HOME}/bin:${HADOOP_HOME}/bin:$PATH

## Hadoop&清理依赖组件
RUN cd /opt \
    && wget http://ftp.kernel.yunfan.com/docker/hadoop/hadoop-2.7.5_stand-alone.tar.gz \
    && tar zxf hadoop-2.7.5_stand-alone.tar.gz && mv hadoop-2.7.5 hadoop \
    && chown root.root -R $HADOOP_HOME \
    && chmod +x $HADOOP_HOME/etc/hadoop/*-env.sh \
    && rm -rf *.gz

ADD bootstrap.sh /etc/bootstrap.sh

## HDFS
EXPOSE 50070 9000
## SSH
EXPOSE 22

CMD ["/etc/bootstrap.sh", "-d"]
