FROM python:alpine3.7
MAINTAINER jieyang <yangjie@yfcloud.com>
ENV EFRESHED_AT 2018-08-21 

RUN set -e && mkdir /ipip \
    && cd /ipip/ \
    && pip install flask ipip-datx \
    && wget http://p1awgv97o.bkt.clouddn.com/ipip.datx

COPY ipip.py /ipip
EXPOSE 51000
CMD ["python","/ipip/ipip.py"]
