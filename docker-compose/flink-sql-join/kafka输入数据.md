
kcat -P -b localhost:9092 -t order

kcat -L -b localhost:9092 | grep order

./kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic wide

./kafka-console-producer.sh --broker-list localhost:9092 --topic order
{"order_id":1, "order_date":"2020-07-30 03:00:00", "product_id":101}
{"order_id":2, "order_date":"2020-07-30 03:00:00", "product_id":102}
{"order_id":3, "order_date":"2020-07-30 03:00:00", "product_id":103}
{"order_id":4, "order_date":"2020-07-30 04:00:00", "product_id":104}
{"order_id":5, "order_date":"2020-07-30 05:00:00", "product_id":105}
{"order_id":6, "order_date":"2020-07-30 06:00:00", "product_id":106}
{"order_id":7, "order_date":"2020-07-30 07:00:00", "product_id":107}
{"order_id":8, "order_date":"2020-07-30 08:00:00", "product_id":108}
{"order_id":9, "order_date":"2020-07-30 09:00:00", "product_id":109}

./kafka-console-producer.sh --broker-list localhost:9092 --topic product
{"id":101, "name":"1", "description":"1", "update_time":"2020-07-30 03:00:00"}
{"id":102, "name":"2", "description":"2", "update_time":"2020-07-30 03:00:00"}
{"id":103, "name":"3", "description":"3", "update_time":"2020-07-30 03:00:00"}
{"id":104, "name":"4", "description":"4", "update_time":"2020-07-30 04:00:00"}
{"id":105, "name":"5", "description":"5", "update_time":"2020-07-30 05:00:00"}
{"id":106, "name":"6", "description":"6", "update_time":"2020-07-30 06:00:00"}
{"id":107, "name":"7", "description":"7", "update_time":"2020-07-30 07:00:00"}
{"id":108, "name":"8", "description":"8", "update_time":"2020-07-30 08:00:00"}
{"id":109, "name":"9", "description":"9", "update_time":"2020-07-30 09:00:00"}