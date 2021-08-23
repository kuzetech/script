
create database drm on cluster cluster3s;

CREATE TABLE drm.lineorder_local ON CLUSTER cluster3s
(
    LO_ORDERKEY             UInt32,
    LO_LINENUMBER           UInt8,
    LO_CUSTKEY              UInt32,
    LO_PARTKEY              UInt32,
    LO_SUPPKEY              UInt32,
    LO_ORDERDATE            Date,
    LO_ORDERPRIORITY        LowCardinality(String),
    LO_SHIPPRIORITY         UInt8,
    LO_QUANTITY             UInt8,
    LO_EXTENDEDPRICE        UInt32,
    LO_ORDTOTALPRICE        UInt32,
    LO_DISCOUNT             UInt8,
    LO_REVENUE              UInt32,
    LO_SUPPLYCOST           UInt32,
    LO_TAX                  UInt8,
    LO_COMMITDATE           Date,
    LO_SHIPMODE             LowCardinality(String)
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/lineorder_local', '{replica}', LO_ORDERDATE)
ORDER BY LO_ORDERKEY;

CREATE TABLE drm.lineorder_all ON CLUSTER cluster3s
(
    LO_ORDERKEY             UInt32,
    LO_LINENUMBER           UInt8,
    LO_CUSTKEY              UInt32,
    LO_PARTKEY              UInt32,
    LO_SUPPKEY              UInt32,
    LO_ORDERDATE            Date,
    LO_ORDERPRIORITY        LowCardinality(String),
    LO_SHIPPRIORITY         UInt8,
    LO_QUANTITY             UInt8,
    LO_EXTENDEDPRICE        UInt32,
    LO_ORDTOTALPRICE        UInt32,
    LO_DISCOUNT             UInt8,
    LO_REVENUE              UInt32,
    LO_SUPPLYCOST           UInt32,
    LO_TAX                  UInt8,
    LO_COMMITDATE           Date,
    LO_SHIPMODE             LowCardinality(String)
)
ENGINE = Distributed(cluster3s, drm, lineorder_local, rand());

INSERT INTO drm.lineorder_all SELECT * from dm.lineorder_all;

select count(*) from drm.lineorder_all;

SELECT table,column,
   sum(rows) AS rows,
   formatReadableSize(sum(column_data_compressed_bytes)) AS comp_bytes,
   formatReadableSize(sum(column_data_uncompressed_bytes)) AS uncomp_bytes
FROM system.parts_columns
WHERE table='lineorder_local'
GROUP BY table,column;

ALTER TABLE drm.lineorder_local ON CLUSTER cluster3s ADD COLUMN IF NOT EXISTS LO_VERSION UInt32 AFTER LO_SHIPMODE;

ALTER TABLE drm.lineorder_local ON CLUSTER cluster3s DROP COLUMN IF EXISTS LO_VERSION;

desc drm.lineorder_local;

SELECT table,column,
   sum(rows) AS rows,
   formatReadableSize(sum(column_data_compressed_bytes)) AS comp_bytes,
   formatReadableSize(sum(column_data_uncompressed_bytes)) AS uncomp_bytes
FROM system.parts_columns
WHERE table='lineorder_local'
GROUP BY table,column;

select * from drm.lineorder_local limit 10;

select count(*) from drm.lineorder_local;

OPTIMIZE TABLE drm.lineorder_local FINAL; 

ALTER TABLE drm.lineorder_local ON CLUSTER cluster3s ADD COLUMN IF NOT EXISTS LO_NOTE String DEFAULT 'lineorder_local' AFTER LO_VERSION;

desc drm.lineorder_local;

SELECT table,column,
   sum(rows) AS rows,
   formatReadableSize(sum(column_data_compressed_bytes)) AS comp_bytes,
   formatReadableSize(sum(column_data_uncompressed_bytes)) AS uncomp_bytes
FROM system.parts_columns
WHERE table='lineorder_local'
GROUP BY table,column;

OPTIMIZE TABLE drm.lineorder_local FINAL; 

SELECT table,column,
   sum(rows) AS rows,
   formatReadableSize(sum(column_data_compressed_bytes)) AS comp_bytes,
   formatReadableSize(sum(column_data_uncompressed_bytes)) AS uncomp_bytes
FROM system.parts_columns
WHERE table='lineorder_local'
GROUP BY table,column;

OPTIMIZE TABLE drm.lineorder_local FINAL; 