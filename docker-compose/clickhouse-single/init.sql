

CREATE TABLE test
(
    id UInt32,
    event LowCardinality(String),
    time UInt64
)
ENGINE = MergeTree()
ORDER BY (id, event)
SETTINGS index_granularity = 1;

insert into test VALUES (1,'test1', 100),(2,'test2', 200),(3,'test3', 300),(4,'test4', 400);


CREATE TABLE test_alis
(
    id Int32,
    time UInt64,
    pass_day UInt32 ALIAS dateDiff('day', toDateTime(time,'Europe/London'), now(), 'Europe/London')
)
ENGINE = MergeTree()
ORDER BY id;
