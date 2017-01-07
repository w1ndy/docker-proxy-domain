FROM ubuntu:16.04
MAINTAINER zjuvis@gmail.com

RUN apt-get update && apt-get install -y supervisor iproute2 dnsutils socat
RUN mkdir /root/info && echo 'supervisor.com' > /root/info/domain
COPY print_ip_and_run /usr/bin/print_ip_and_run
COPY delegated /usr/bin/delegated
COPY proxy_socat /usr/bin/proxy_socat
COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/print_ip_and_run"]

