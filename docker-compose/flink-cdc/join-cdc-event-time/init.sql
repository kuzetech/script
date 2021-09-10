SET 'execution.checkpointing.interval' = '3s';
SET 'pipeline.time-characteristic' = 'EventTime';
SET 'pipeline.auto-watermark-interval' = '0ms';

CREATE TABLE products (
   id INT,
   name STRING,
   description STRING,
   update_time TIMESTAMP(3),
   WATERMARK FOR update_time AS update_time - INTERVAL '1' HOUR,
   PRIMARY KEY (id) NOT ENFORCED
 ) WITH (
   'connector' = 'mysql-cdc',
   'hostname' = 'localhost',
   'port' = '3306',
   'username' = 'root',
   'password' = '123456',
   'database-name' = 'mydb',
   'table-name' = 'products'
 );

CREATE TABLE orders (
   order_id INT,
   order_date TIMESTAMP(3),
   product_id INT,
   WATERMARK FOR order_date AS order_date - INTERVAL '1' HOUR
 ) WITH (
  'connector' = 'kafka',
  'topic' = 'order',
  'properties.bootstrap.servers' = 'localhost:9092',
  'properties.group.id' = 'testGroup',
  'scan.startup.mode' = 'latest-offset',
  'format' = 'json'
 );