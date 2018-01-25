FROM jevic/jdk:8u144-openssh

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

COPY bootstrap.sh /etc/bootstrap.sh

RUN cd /opt \
    && wget http://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-2.0.2/spark-2.0.2-bin-hadoop2.7.tgz \
    && tar zxf spark-2.0.2-bin-hadoop2.7.tgz \
    && mv spark-2.0.2-bin-hadoop2.7 spark \
    && rm -rf spark-2.0.2-bin-hadoop2.7.tgz \
    && cd /opt/spark/conf \
    && cp spark-env.sh.template spark-env.sh \
    && cp slaves.template slaves \
    && echo "export JAVA_HOME=/opt/jdk" >> spark-env.sh \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && chmod +x /etc/bootstrap.sh \
    && chown -R root.root /opt/spark

EXPOSE 8081 4040-4050
CMD ["/etc/bootstrap.sh"]
