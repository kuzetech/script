
create database drm on cluster cluster3s;

CREATE TABLE drm.customer_local ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_VERSION       UInt32
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/customer_local', '{replica}', C_VERSION)
ORDER BY (C_CUSTKEY);

SELECT * FROM system.zookeeper where path = '/clickhouse/tables';

CREATE TABLE drm.customer_all ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_VERSION       UInt32
)
ENGINE = Distributed(cluster3s, drm, customer_local, rand());

INSERT INTO customer_local VALUES (1, 'Customer#001', 3);

select * from customer_local;

OPTIMIZE TABLE customer_local FINAL;

drop table drm.customer_local on cluster cluster3s;
drop table drm.customer_all on cluster cluster3s;


CREATE TABLE drm.customer_local ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_ADDRESS       String,
        C_CITY          LowCardinality(String),
        C_NATION        LowCardinality(String),
        C_REGION        LowCardinality(String),
        C_PHONE         String,
        C_MKTSEGMENT    LowCardinality(String)
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/customer_local', '{replica}')
ORDER BY C_CUSTKEY;

SELECT * FROM system.zookeeper where path = '/clickhouse/tables';

CREATE TABLE drm.customer_all ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_ADDRESS       String,
        C_CITY          LowCardinality(String),
        C_NATION        LowCardinality(String),
        C_REGION        LowCardinality(String),
        C_PHONE         String,
        C_MKTSEGMENT    LowCardinality(String)
)
ENGINE = Distributed(cluster3s, drm, customer_local, rand());

INSERT INTO drm.customer_all SELECT * from dm.customer_all;

select count(*) from drm.customer_all;

SELECT table,column,
   sum(rows) AS rows,
   formatReadableSize(sum(column_data_compressed_bytes)) AS comp_bytes,
   formatReadableSize(sum(column_data_uncompressed_bytes)) AS uncomp_bytes
FROM system.parts_columns
WHERE table='customer_local'
GROUP BY table,column;

ALTER TABLE drm.customer_local ON CLUSTER cluster3s ADD COLUMN IF NOT EXISTS C_VERSION UInt32 AFTER C_MKTSEGMENT;

ALTER TABLE drm.customer_local ON CLUSTER cluster3s DROP COLUMN IF EXISTS C_VERSION;

desc drm.customer_local;

select * from drm.customer_local limit 10;

OPTIMIZE TABLE drm.customer_local FINAL;