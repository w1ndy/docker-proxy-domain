#!/bin/sh

rm -rf /etc/unbound/docker-autoconf >/dev/null 2>&1 || true
mkdir -p /etc/unbound/docker-autoconf
docker-compose ps -q | while read -r line ; do
    docker_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $line)
    domain=$(curl -s http://$docker_ip:8080/domain)
    echo "Processing $domain"
    echo "local-data: \"$domain A $docker_ip\"" > /etc/unbound/docker-autoconf/$domain.conf
done
systemctl restart unbound

