are_brokers_available() {
    expected_num_brokers=2 # replace this with a proper value
    num_brokers=1
    return [ $num_brokers -gt $expected_num_brokers ]
}

while ! are_brokers_available; do
    echo $are_brokers_available
    echo "brokers not available yet"
    sleep 1
done

echo "Kafka custom init"

/opt/bitnami/kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --create  --replication-factor 1 --partitions 1 --topic testovic
/opt/bitnami/kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --list

echo "Kafka custom init done"