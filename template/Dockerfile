FROM supervisord
MAINTAINER zjuvis@gmial.com

COPY supervisord.conf /tmp/config
RUN cat /tmp/config >> /etc/supervisord.conf

RUN echo "__DOMAIN_NAME__" > /root/info/domain

