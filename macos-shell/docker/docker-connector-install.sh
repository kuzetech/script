#! /bin/bash

# 使用brew安装docker-connector
brew install wenjunxiao/brew/docker-connector

# 使用sudo启动docker-connector服务
sudo brew services start docker-connector

# 使用下面命令创建wenjunxiao/mac-docker-connector容器，要求使用 host 网络并且允许 NET_ADMIN
docker pull wenjunxiao/mac-docker-connector
docker run -it -d --restart always --net host --cap-add NET_ADMIN --name connector wenjunxiao/mac-docker-connector

# 获取所有容器的 IP
docker inspect --format='{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) 