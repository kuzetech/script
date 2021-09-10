SET 'execution.checkpointing.interval' = '3s';

CREATE TABLE product (
    id INT,
    name STRING,
    description STRING,
    PRIMARY KEY (id) NOT ENFORCED
 ) WITH (
    'connector' = 'upsert-kafka',
    'topic' = 'product',
    'properties.bootstrap.servers' = 'localhost:9092',
    'properties.group.id' = 'testGroup',
    'properties.auto.offset.reset' = 'latest',
    'key.format' = 'json',
    'value.format' = 'json'
 );

CREATE TABLE orders (
    order_id INT,
    order_date TIMESTAMP(3),
    product_id INT,
    proctime as PROCTIME(),
    PRIMARY KEY (order_id) NOT ENFORCED
 ) WITH (
    'connector' = 'upsert-kafka',
    'topic' = 'order',
    'properties.bootstrap.servers' = 'localhost:9092',
    'properties.group.id' = 'testGroup',
    'properties.auto.offset.reset' = 'latest',
    'key.format' = 'json',
    'value.format' = 'json'
 );