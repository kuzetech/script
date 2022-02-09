#!/bin/bash

set +x

are_brokers_available() {
    expected_num_brokers=1 # replace this with a proper value
    brokers_str="$(zookeeper-shell.sh zookeeper:2181 ls /brokers/ids 2>/dev/null | grep "\[")"
    echo $brokers_str
    array=(${brokers_str//,/ })
    num_brokers=${#array[*]}
    echo $num_brokers
    if [ $num_brokers -ge $expected_num_brokers ]
    then
        return 1
    else
        return 0
    fi
}

while are_brokers_available 
do
    echo "brokers not available yet"
    sleep 1
done

echo "Kafka custom init"

/opt/bitnami/kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --create  --replication-factor 1 --partitions 3 --topic test123
/opt/bitnami/kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --list

echo "Kafka custom init done"