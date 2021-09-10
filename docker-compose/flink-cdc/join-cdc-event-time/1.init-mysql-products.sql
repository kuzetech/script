

-- MySQL
CREATE DATABASE mydb;
USE mydb;
CREATE TABLE products (
  id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(512),
  update_time DATETIME NOT NULL
);
ALTER TABLE products AUTO_INCREMENT = 101;

INSERT INTO products
VALUES (default,"scooter","Small 2-wheel scooter", '2020-07-30 01:00:00'),
       (default,"car battery","12V car battery", '2020-07-30 02:00:00'),
       (default,"12-pack drill bits","12-pack of drill bits with sizes ranging from #40 to #3", '2020-07-30 03:00:00'),
       (default,"hammer","12oz carpenter's hammer", '2020-07-30 04:00:00'),
       (default,"hammer","14oz carpenter's hammer", '2020-07-30 05:00:00'),
       (default,"hammer","16oz carpenter's hammer", '2020-07-30 06:00:00'),
       (default,"rocks","box of assorted rocks", '2020-07-30 07:00:00'),
       (default,"jacket","water resistent black wind breaker", '2020-07-30 08:00:00'),
       (default,"spare tire","24 inch spare tire", '2020-07-30 09:00:00');