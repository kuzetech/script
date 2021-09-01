CREATE TABLE real_online_users_local ON CLUSTER test_shard_localhost
(
    app_id          LowCardinality(String)      COMMENT '游戏ID',
    sdk_version     LowCardinality(String)      COMMENT '服务端SDK版本',
    log_id          LowCardinality(String)      COMMENT '日志ID',
    time            UInt64                      COMMENT '事件时间戳',
    event           LowCardinality(String)      COMMENT '事件名称',
    online_num      UInt32                      COMMENT '在线玩家数'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/real_online_users_local', '{replica}')
PARTITION BY toDate(time)
ORDER BY (time, log_id);

CREATE TABLE real_online_users_all ON CLUSTER test_shard_localhost as real_online_users_local
ENGINE = Distributed(test_shard_localhost, default, real_online_users_local, rand());