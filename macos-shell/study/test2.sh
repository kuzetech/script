#!/bin/bash

topic=$1
partition=$2

for ((i=0; i<partition; i++))
do
  offsets=$(/opt/bitnami/kafka/bin/kafka-transactions.sh --bootstrap-server localhost:9092 find-hanging --topic "$topic" --partition "$i" | awk '{print $6}' | tail -n +2)

  for offset in $offsets
  do
    /opt/bitnami/kafka/bin/kafka-transactions.sh --bootstrap-server localhost:9092 abort --topic $topic --partition $i --start-offset $offset
    echo "topic=$topic partition=$i offset=$offset"
  done
done

