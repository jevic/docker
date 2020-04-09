FROM python:3.7.7-alpine
MAINTAINER jieyang <jevic9596@gmail.com>
ENV EFRESHED_AT 2020-03-11
ENV TZ Asia/Shanghai
RUN pip install flask werkzeug requests

COPY ./alarm /alarm
COPY docker-entrypoint.sh /

ENTRYPOINT ["./docker-entrypoint.sh"]
EXPOSE 51000
CMD ["python","/alarm/alarm.py"]
