#! /bin/bash

# 执行下面命令将docker所有 bridge 网络都添加到docker-connector路由
docker network ls --filter driver=bridge --format "{{.ID}}" | xargs docker network inspect --format "route {{range .IPAM.Config}}{{.Subnet}}{{end}}" >> /usr/local/etc/docker-connector.conf
