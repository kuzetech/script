SET 'execution.checkpointing.interval' = '3s';

CREATE TABLE product (
    id INT,
    name STRING,
    description STRING,
    PRIMARY KEY (id) NOT ENFORCED
 ) WITH (
    'connector' = 'kafka',
    'topic' = 'product',
    'properties.bootstrap.servers' = 'localhost:9092',
    'properties.group.id' = 'testGroup',
    'scan.startup.mode' = 'latest-offset',
    'format' = 'json'
 );

CREATE TABLE orders (
    order_id INT,
    order_date TIMESTAMP(3),
    product_id INT,
    proctime as PROCTIME(),
    PRIMARY KEY (order_id) NOT ENFORCED
 ) WITH (
    'connector' = 'kafka',
    'topic' = 'order',
    'properties.bootstrap.servers' = 'localhost:9092',
    'properties.group.id' = 'testGroup',
    'scan.startup.mode' = 'latest-offset',
    'format' = 'json'
 );