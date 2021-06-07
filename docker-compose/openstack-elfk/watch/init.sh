#!/bin/bash

sudo apt-get upgrade -y
sudo apt-get install mailutils

echo 'set from=370415788@qq.com' > /etc/s-nail.rc
echo 'set smtp=smtps://smtp.qq.com:465' >> /etc/s-nail.rc
echo 'set smtp-auth-user=370415788@qq.com' >> /etc/s-nail.rc
echo 'set smtp-auth-password=fehqnmixuggfcadh' >> /etc/s-nail.rc
echo 'set smtp-auth=login' >> /etc/s-nail.rc

#echo "测试邮件" | mail -s "测试2223" 370415788@qq.com

mkdir -p /es-watch

echo 'ipAddressAndPorts=localhost:9200' > /es-watch/config.txt
echo 'curlPath=/usr/bin/curl' >> /es-watch/config.txt
echo 'semdEmailTo=370415788@qq.com' >> /es-watch/config.txt
echo 'sendEmailTitle=检测到内网ES集群状态异常' >> /es-watch/config.txt
echo 'sendEmailContent=检测到内网ES集群状态异常' >> /es-watch/config.txt

echo '配置初始化完成'