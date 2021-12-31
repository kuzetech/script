CREATE TABLE test_local on CLUSTER cluster3s
(
    name        String                      COMMENT '用户ID',
    time        DateTime                    COMMENT '事件时间戳'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/test_local', '{replica}')
PARTITION BY toYYYYMMDD(time)
ORDER BY (name);

CREATE TABLE test on CLUSTER cluster3s as test_local 
ENGINE = Distributed(cluster3s, default, test_local, rand());

INSERT INTO test VALUES ('1', '2021-10-01');

select * from test;
select * from test_local;