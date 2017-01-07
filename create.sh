#!/bin/sh

ENABLE_SSH=false
ENABLE_HTTP=false
ENABLE_HTTPS=false
DOMAIN_NAME=""

while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -s|--ssh)
            ENABLE_SSH=true
            ;;
        -h|--http)
            ENABLE_HTTP=true
            ;;
        -t|--https)
            ENABLE_HTTPS=true
            ;;
        *)
            DOMAIN_NAME=$key
            ;;
    esac
    shift
done

if [ -z "$DOMAIN_NAME" ]; then
    echo 'Usage: create.sh [-s|--ssh] [-h|--http] [-t|--https] DOMAIN_NAME'
    exit
fi

rm -rf _$DOMAIN_NAME >/dev/null 2>&1 || true
mkdir _$DOMAIN_NAME
sed "s%__DOMAIN_NAME__%$DOMAIN_NAME%g" template/Dockerfile > _$DOMAIN_NAME/Dockerfile
touch _$DOMAIN_NAME/supervisord.conf

if [ "$ENABLE_SSH" = true ]; then
    sed "s%__DOMAIN_NAME__%$DOMAIN_NAME%g" template/supervisord.conf.ssh >> _$DOMAIN_NAME/supervisord.conf
fi
if [ "$ENABLE_HTTP" = true ]; then
    sed "s%__DOMAIN_NAME__%$DOMAIN_NAME%g" template/supervisord.conf.http >> _$DOMAIN_NAME/supervisord.conf
fi
if [ "$ENABLE_HTTPS" = true ]; then
    sed "s%__DOMAIN_NAME__%$DOMAIN_NAME%g" template/supervisord.conf.https >> _$DOMAIN_NAME/supervisord.conf
fi

if ! grep -q "$DOMAIN_NAME:" docker-compose.yml ; then
    echo "Adding docker-compose.yml entry..."
    sed "s%__DOMAIN_NAME__%$DOMAIN_NAME%g" template/docker-compose.yml >> docker-compose.yml
fi

echo "Building..."
sudo docker-compose build $DOMAIN_NAME

echo "Starting..."
sudo docker-compose up -d $DOMAIN_NAME

