#!/bin/bash
set -e

clickhouse client -n <<-EOSQL
    use default;

    CREATE TABLE event_local
    (
        log_id      UInt32,
        dt          DateTime
    )
    ENGINE = MergeTree
    PARTITION BY (toDate(dt))
    ORDER BY (log_id)
    settings assign_part_uuids = true;

    insert into event_local values (1, '2022-05-04');
    insert into event_local values (2, '2022-05-04');

    CREATE TABLE event_all as event_local ENGINE = Distributed(my, default, event_local, rand());

    CREATE TABLE events_local
    (
        event String COMMENT '事件名称',
        time Int64 COMMENT '事件发生时间',
        dt Date MATERIALIZED toDate(time / 1000, 'Etc/GMT-8') COMMENT '事件日期',
        store_time UInt64 MATERIALIZED toUnixTimestamp64Milli(now64()) COMMENT '入库存储时间戳,毫秒级',
        log_id String COMMENT '日志唯一ID',
        device_id String COMMENT '用户设备ID',
        sdk_version String COMMENT 'SDK版本',
        sdk_type String COMMENT 'SDK类型',
        app_version String COMMENT 'APP版本',
        channel String COMMENT '分包渠道来源',
        carrier String COMMENT 'SIM卡运营商',
        os String COMMENT '操作系统串',
        os_platform String COMMENT '操作系统平台',
        os_version String COMMENT '操作系统版本',
        device_model String COMMENT '设备型号',
        manufacturer String COMMENT '设备制造商',
        screen_height Int64 COMMENT '屏幕高度',
        screen_width Int64 COMMENT '屏幕宽度',
        ip String COMMENT '客户端IP地址',
        isp String COMMENT '网络运营商',
        continent String COMMENT '大洲',
        country String COMMENT '国家',
        province String COMMENT '省份',
        city String COMMENT '城市',
        network String COMMENT '网络类型',
        account_id String COMMENT 'SDK账号ID'
    )
    ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{database}/{table}/{shard}', '{replica}', time)
    PARTITION BY (dt, event)
    ORDER BY (time, log_id);

    CREATE TABLE IF NOT EXISTS events as events_local ENGINE = Distributed(my, default, events_local, rand());

    insert into events values ('#account_login',1652025600264,'c7c7d65d-1e22-4d71-9bee-78e7233f96f1','18f889a6-f0a9-421f-bfbc-15c54237998a','1.15.7','Golang','5.10.14','wechat','联通','Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/1904-21-06 Firefox/37.0','IOS','1.12.6','Mozilla/5.0 (X11; Linux i686) AppleWebKit/5311 (KHTML, like Gecko) Chrome/36.0.837.0 Mobile Safari/5311','vivo',2400,1080,'10.244.4.1','电信','亚洲','Benin','Washington','Plano','wifi','6d7f6488-0942-4ae2-92fe-a8e2ecb0a586');
    insert into events values ('#account_login',1652025600314,'6a3c4a32-9396-4b9b-a627-b9b14ceb96c1','e950996e-55e8-491a-b7e7-5dd97b5ebc4d','5.18.19','Unity','3.15.20','wechat','移动','Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/5330 (KHTML, like Gecko) Chrome/36.0.879.0 Mobile Safari/5330','IOS','3.14.6','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_6) AppleWebKit/5351 (KHTML, like Gecko) Chrome/36.0.845.0 Mobile Safari/5351','华为',1600,900,'10.244.4.1','电信','亚洲','Niger','Kansas','Raleigh','4g','988bb1ec-412f-4f5f-a7d1-e1ede11e1486');
    insert into events values ('#account_login',1652025600365,'ab273464-9a72-4f39-8255-c90d568725ea','52c49180-bcc2-413c-a712-6a4c305c4964','3.17.18','Golang','2.20.16','wechat','电信','Mozilla/5.0 (Windows 98; Win 9x 4.90) AppleWebKit/5332 (KHTML, like Gecko) Chrome/40.0.845.0 Mobile Safari/5332','IOS','3.10.20','Mozilla/5.0 (Windows NT 5.01; en-US; rv:1.9.0.20) Gecko/1964-08-03 Firefox/35.0','华为',1600,900,'10.244.4.1','电信','非洲','Solomon Islands','Vermont','Glendale','5g','16e8bd59-5f97-4f34-b747-c8199da5621f');


EOSQL