FROM jevic/jdk:8u144-openssh

COPY bootstrap.sh /etc/bootstrap.sh

RUN cd /opt \
    && http://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-2.0.2/spark-2.0.2-bin-hadoop2.7.tgz \
    && tar zxf spark-2.0.2-bin-hadoop2.7.tgz \
    && mv spark-2.0.2-bin-hadoop2.7 spark \
    && cd /opt/spark/conf \
    && cp spark-env.sh.template spark-env.sh \
    && cp slaves.template slaves \
    && echo "export JAVA_HOME=/opt/jdk" >> spark-env.sh \
    && chmod +x /etc/bootstrap.sh

EXPOSE 8081 4040-4050
CMD ["/etc/bootstrap.sh"]
