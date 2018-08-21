FROM python:alpine3.7
MAINTAINER jieyang <yangjie@yfcloud.com>
ENV EFRESHED_AT 2018-08-20 

ENV TZ Asia/Shanghai
RUN pip install flask urllib3

COPY ./alarm /alarm
COPY docker-entrypoint.sh /

ENTRYPOINT ["./docker-entrypoint.sh"]
EXPOSE 51000
CMD ["python","/alarm/alarm.py"]
