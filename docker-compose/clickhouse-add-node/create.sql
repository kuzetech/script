

CREATE TABLE test ON CLUSTER my
(
    id             UInt32,
    part           UInt32
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/test', '{replica}')
PARTITION BY part
ORDER BY id;

CREATE TABLE test_all ON CLUSTER my
(
    id             UInt32,
    part           UInt32
)
ENGINE = Distributed(my, default, test, rand());

INSERT INTO test VALUES (1, 1);
INSERT INTO test VALUES (1, 2);
INSERT INTO test VALUES (1, 3);

INSERT INTO test VALUES (2, 1);
INSERT INTO test VALUES (2, 2);
INSERT INTO test VALUES (2, 3);

select * from test_all;

SELECT * FROM system.parts WHERE table='test';

OPTIMIZE TABLE drm.add_column_test FINAL; 