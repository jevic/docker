FROM python:alpine3.7
MAINTAINER jieyang <yangjie@yfcloud.com>
ENV EFRESHED_AT 2018-08-22

ENV TZ Asia/Shanghai
COPY docker-entrypoint.sh /

RUN pip install flask urllib3 \
    && chmod +x /docker-entrypoint.sh

COPY ./alarm /alarm

ENTRYPOINT ["./docker-entrypoint.sh"]
EXPOSE 51000
CMD ["python","/alarm/alarm.py"]
