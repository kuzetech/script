#! /bin/bash
name=big
echo $(echo $name
name=sd
echo $name)

docker rmi `docker images | awk '/^<none>/ { print $3 }'`