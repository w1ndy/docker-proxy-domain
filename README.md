# docker-proxy-domain
A set of tools to help users proxy requests in docker based on domains.

Some Docker images require to access various blocked or slow services (e.g. GitHub in China), however users are difficult to proxy network requests inside Docker without rebuilding images. This set of tools aims to provide a fast way to create small 'proxy' containers serving as proxies to specified domains and replace DNS entries for transparent access.

## Prerequisites

1. SOCKS5 server

  Configure SOCKS5 server to listen on docker interface ``172.17.0.1``, e.g., add ``-b 172.17.0.1`` option to ``ss-local`` if you are using Shadowsocks. Port ``1080`` is used by default, however you may also edit ``image/supervisord.conf`` according to your preferences.
  
2. Unbound:

  Install unbound DNS server:
  
  ```bash
  sudo yum install unbound
  ```
  
  and use custom configurations:
  
  ```bash
  sudo cp unbound.conf /etc/unbound/unbound.conf
  ```

3. Add DNS option to Docker daemon

  ```bash
  sudo systemctl edit docker
  ```
  
  and add ``--dns=172.17.0.1`` option. The file should look like this:
  
  ```
  [Service]
  ExecStart=
  ExecStart=/usr/bin/dockerd \
            --dns=172.17.0.1 \
            $OPTIONS \
            $DOCKER_STORAGE_OPTIONS \
            $DOCKER_NETWORK_OPTIONS \
            $ADD_REGISTRY \
  ```
  
  Restart dockerd for changes to take effect:
  
  ```
  sudo systemctl restart docker
  ```

4. docker-compose

## Installation

1. Build base image:

  ```
  docker build -t supervisord image/
  ```

2. Add domains:

  ```
  ./create.sh [-s|--ssh] [-h|--http] [-t|--https] DOMAIN_NAME
  ```
  
  For example:
  
  ```
  ./create -s -h -t github.com
  ```
  
  The script will automatically build and run a new docker image.

3. Update unbound configuration:

  ```
  sudo ./mkconfig.sh
  ```
  
  The script will query containers' IP address and generate unbound configuration.
  
  NOTE: You should run this script everytime docker restarts in case of any IP changes.

  
