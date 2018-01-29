FROM ubuntu:16.04
ADD dcmp.tar.gz /opt
COPY start.sh /
WORKDIR /opt/dcmp
ENTRYPOINT ["/start.sh"]
EXPOSE 8000
CMD ["/opt/dcmp/service.sh"]
