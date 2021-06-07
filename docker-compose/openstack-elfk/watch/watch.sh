#!/bin/sh
#*/1 * * * * /es-watch/watch.sh >> /es-watch/log.txt
db_backups_conf="/es-watch/config.txt"
 
#判断文件是否存在
if [ -f "${db_backups_conf}" ];then
    
    echo $(date +'%Y-%m-%d %H:%M:%S')" 发现文件配置信息文件存在"
 
    #获取等号前内容，作为map中的Key值
    dbArrOne=($(awk -F'[=]' '{print $1}' ${db_backups_conf} ))
    
    #获取等号后内容，作为map中的value值
    dbArrTwo=($(awk -F'[=]' '{print $2}' ${db_backups_conf}))
 
    #创建一个空map
    declare -A map=()
    
    #通过循环，将db_backups_conf配置文件中的信息存储在map中
    for((i=0;i<${#dbArrOne[@]};i++))
    do
        map[${dbArrOne[i]}]=${dbArrTwo[i]}
    done    
 
    #获取要监测集群节点IP和端口号组合的字符串
    ipPortsStr=${map["ipAddressAndPorts"]}
    
    #获取收件人的邮件账号的字符串
    semdEmailTo=${map["semdEmailTo"]}
    
    #获取默认的字符串分隔符
    old_ifs="$IFS"
    
    #设置字符串分隔符为逗号
    IFS=","
 
    #将要备份的索引名称value值的字符串进行分隔，获取一个数组
    ipPortArr=($ipPortsStr)
    
    #将收件人的邮件账号value值的字符串进行分隔，获取一个数组
    semdEmailToArr=($semdEmailTo)
 
    #将字符串的分隔符重新设置为默认的分隔符
    IFS="$old_ifs"
    
    
    #定义一个是否需要发送异常提醒邮件变量
    isSendEmailStr=0
    
    #定义一个出现异常集群节点ip和端口号存储的变量
    errorIpPort=""
    
    #检查ES集群状态
    {

        for ipPort in ${ipPortArr[@]};
        do
        
            #检测es访问地址是否有效
            responseStr=$(curl -s http://${ipPort}/_cat/health)
            splitArray=($responseStr)
            esStatus=${splitArray[3]}
            if [ $esStatus == 'red' ];then
            
                echo $(date +'%Y-%m-%d %H:%M:%S')" es地址访问异常："${ipPort}
                isSendEmailStr=1
                errorIpPort=${errorIpPort}""${ipPort}","
            
            fi
            
        
        done
        
    } || {
        isSendEmailStr=1
    }
    
 
    #判断命令执行是否有异常，如果有异常就发送邮件
    if [ ${isSendEmailStr} == "0" ];then
            echo $(date +'%Y-%m-%d %H:%M:%S')" 执行es集群节点监测全部正常"
        else 
            echo $(date +'%Y-%m-%d %H:%M:%S')" 执行es集群节点监测有异常，开始发送邮件通知管理员"
            
            #遍历收件人的邮箱地址，逐个发送邮件
            for email in ${semdEmailToArr[@]};
            do
                echo $(date +'%Y-%m-%d %H:%M:%S')" 开始发送邮件："${email}
 
                echo ""${map["sendEmailContent"]}",异常节点信息如下："${errorIpPort} | mail -s ""${map["sendEmailTitle"]} ${email}
            done
            
            echo $(date +'%Y-%m-%d %H:%M:%S')" 执行es集群节点监测有异常，成功发送邮件通知管理员"
    fi
    
    echo $(date +'%Y-%m-%d %H:%M:%S')" 脚本执行完毕"
 
 
else
    echo "文件不存在"
fi