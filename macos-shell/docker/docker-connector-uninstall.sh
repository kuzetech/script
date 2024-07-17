#! /bin/bash

docker stop connector

docker rm -v connector

docker rmi `docker images | awk '/^wenjunxiao\/mac-docker-connector/ { print $3 }'`

sudo brew services stop docker-connector

sudo brew uninstall wenjunxiao/brew/docker-connector

rm -rf /usr/local/etc/docker-connector.conf
rm -rf /usr/local/etc/docker-connector.conf.default
