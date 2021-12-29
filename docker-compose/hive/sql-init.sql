CREATE CATALOG MyCatalog
WITH (
    'type' = 'hive',
    'hive-conf-dir'='/Users/huangsw/script/docker-compose/hive/flink-hive-conf',
    'hive-version'='2.3.2'
); 

USE CATALOG MyCatalog;

CREATE TABLE IF NOT EXISTS mykafka (name String, age Int) WITH (
  'connector' = 'kafka',
  'topic' = 'test',
  'properties.bootstrap.servers' = 'localhost:9092',
  'properties.group.id' = 'testGroup',
  'scan.startup.mode' = 'earliest-offset',
  'format' = 'csv'
);