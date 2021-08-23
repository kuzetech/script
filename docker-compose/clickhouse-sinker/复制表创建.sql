
create database drm on cluster cluster3s;

CREATE TABLE drm.customer_local ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_VERSION       UInt32
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/customer_local', '{replica}', C_VERSION)
ORDER BY (C_CUSTKEY);

CREATE TABLE drm.customer_all ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_VERSION       UInt32
)
ENGINE = Distributed(cluster3s, drm, customer_local, rand());

INSERT INTO customer_local VALUES (
    1, 
    'Customer#000000001', 
    'g1s,pzDenUEBW3O,1 pxu', 
    'SAUDI ARA4', 
    'SAUDI ARABIA', 
    'MIDDLE EAST', 
    '30-859-162-5365-1', 
    'AUTOMOBILE'
);

select * from customer_local;

OPTIMIZE TABLE customer_local FINAL;