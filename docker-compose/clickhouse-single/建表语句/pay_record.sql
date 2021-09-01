
CREATE TABLE pay_record_local ON CLUSTER test_shard_localhost
(
    app_id          LowCardinality(String)      COMMENT '游戏ID',
    sdk_version     LowCardinality(String)      COMMENT '服务端SDK版本',
    log_id          LowCardinality(String)      COMMENT '日志ID',
    time            UInt64                      COMMENT '事件时间戳',
    event           LowCardinality(String)      COMMENT '事件名称',
    user_id         UInt32                      COMMENT 'SDK-ID',
    pid             UInt32                      COMMENT '游戏用户ID',
    amount          UInt64                      COMMENT '充值金额',
    currency        LowCardinality(String)      COMMENT '货币类型',
    model           LowCardinality(String)      COMMENT '手机型号',
    client_version  LowCardinality(String)      COMMENT '客户端版本',
    network_type    LowCardinality(String)      COMMENT '网络类型',
    channel         LowCardinality(String)      COMMENT '渠道名称',
    resolution      LowCardinality(String)      COMMENT '分辨率',
    age             UInt8                       COMMENT '年龄段',
    gender          UInt8                       COMMENT '性别',
    source          UInt8                       COMMENT '来源',
    os_version      LowCardinality(String)      COMMENT '操作系统版本',
    device_platform LowCardinality(String)      COMMENT '设备平台',
    carrier         LowCardinality(String)      COMMENT '网络运营商',
    country         LowCardinality(String)      COMMENT '国家',
    area            LowCardinality(String)      COMMENT '地区',
    subcontinents   LowCardinality(String)      COMMENT '次大洲'
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/pay_record_local', '{replica}')
PARTITION BY toDate(time)
ORDER BY (time, log_id);

CREATE TABLE pay_record_all ON CLUSTER test_shard_localhost as pay_record_local
ENGINE = Distributed(test_shard_localhost, default, pay_record_local, rand());