FROM python:alpine3.7
MAINTAINER jevic
ENV EFRESHED_AT 2020-04

ENV TZ Asia/Shanghai
COPY docker-entrypoint.sh /

RUN pip install -i https://pypi.doubanio.com/simple/ flask \
    && pip install -i https://pypi.doubanio.com/simple/ requests \
    && chmod +x /docker-entrypoint.sh

COPY ./alarm /alarm

ENTRYPOINT ["./docker-entrypoint.sh"]
EXPOSE 5100
CMD ["python","/alarm/alarm.py"]
