#https://www.haoyizebo.com/posts/fd0b9bd8/

brew install wenjunxiao/brew/docker-connector

docker network ls --filter driver=bridge --format "{{.ID}}" | xargs docker network inspect --format "route {{range .IPAM.Config}}{{.Subnet}}{{end}}" >> /usr/local/etc/docker-connector.conf

sudo brew services start docker-connector

docker run -it -d --restart always --net host --cap-add NET_ADMIN --name connector wenjunxiao/mac-docker-connector