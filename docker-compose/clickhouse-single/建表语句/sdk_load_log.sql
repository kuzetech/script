
clickhouse-client -q " \
CREATE TABLE sdk_load_log_local ON CLUSTER test_shard_localhost \
( \
    app_id          LowCardinality(String)      COMMENT '游戏ID', \
    log_sdk_version LowCardinality(String)      COMMENT '客户端SDK版本', \
    log_id          LowCardinality(String)      COMMENT '日志ID', \
    time            UInt64                      COMMENT '事件时间戳', \
    event           LowCardinality(String)      COMMENT '事件名称', \
    user_id         UInt32                      COMMENT 'SDK-ID', \
    pid             UInt32                      COMMENT '游戏用户ID', \
    step_name       LowCardinality(String)      COMMENT 'SDK步骤名称', \
    android_id      String                      COMMENT '安卓ID', \
    advertising_id  String                      COMMENT '安卓广告ID', \
    oaid            String                      COMMENT '安卓oaid', \
    ios_idfa        String                      COMMENT 'IOS idfa', \
    device_id       String                      COMMENT '自定义设备ID', \
    device_platform LowCardinality(String)      COMMENT '设备平台', \
    model           LowCardinality(String)      COMMENT '手机型号', \
    os              LowCardinality(String)      COMMENT '操作系统', \
    os_version      LowCardinality(String)      COMMENT '操作系统版本', \
    client_version  LowCardinality(String)      COMMENT '客户端版本', \
    ip              String                      COMMENT '登陆IP', \
    carrier         LowCardinality(String)      COMMENT '网络运营商', \
    network_type    LowCardinality(String)      COMMENT '网络类型', \
    channel         LowCardinality(String)      COMMENT '渠道名称', \
    longitude       Float32                     COMMENT '经度', \
    latitude        Float32                     COMMENT '纬度', \
    country         LowCardinality(String)      COMMENT '国家', \
    area            LowCardinality(String)      COMMENT '地区', \
    subcontinents   LowCardinality(String)      COMMENT '次大洲', \
    resolution      LowCardinality(String)      COMMENT '分辨率', \
    age             UInt8                       COMMENT '年龄段', \
    gender          UInt8                       COMMENT '性别', \
    source          UInt8                       COMMENT '来源', \
    create_time     UInt64                      COMMENT '关联用户创建时间' \
)  \
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/sdk_load_log_local', '{replica}') \
PARTITION BY toDate(time) \
ORDER BY (time, log_id); \
"

CREATE TABLE sdk_load_log_all ON CLUSTER test_shard_localhost as sdk_load_log_local
ENGINE = Distributed(test_shard_localhost, default, sdk_load_log_local, rand());