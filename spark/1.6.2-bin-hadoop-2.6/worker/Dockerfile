FROM jevic/jdk:8u144-openssh

ENV SPARK_TGZ spark-1.6.2-bin-hadoop2.6

COPY bootstrap.sh /etc/bootstrap.sh

RUN cd /opt/ \
    && https://archive.apache.org/dist/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz
    && tar zxf ${SPARK_TGZ}.tgz \
    && mv ${SPARK_TGZ} spark \
    && cd /opt/spark/conf \
    && cp spark-env.sh.template spark-env.sh \
    && cp slaves.template slaves \
    && echo "export JAVA_HOME=/opt/jdk" >> spark-env.sh \
    && chmod +x /etc/bootstrap.sh

EXPOSE 8081 4040-4050
CMD ["/etc/bootstrap.sh"]
