FROM jevic/alpine:base-latest
ENV VERSION v3.2.16

RUN cd /tmp \
    && wget https://github.com/coreos/etcd/releases/download/${VERSION}/etcd-${VERSION}-linux-amd64.tar.gz \
    && tar xzvf etcd-${VERSION}-linux-amd64.tar.gz \
    && mv etcd-${VERSION}-linux-amd64/* /bin/ \
    && rm -rf /tmp/*

ADD run.sh /etc/run.sh
EXPOSE 2379 2380
CMD ["/etc/run.sh"]
