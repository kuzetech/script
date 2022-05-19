!/bin/bash
set -e

clickhouse client -n <<-EOSQL
    use default;

    CREATE TABLE event_local
    (
        log_id      UInt32,
        dt          DateTime
    )
    ENGINE = ReplacingMergeTree
    PARTITION BY (toDate(dt))
    ORDER BY (log_id)
    settings assign_part_uuids = true;

    insert into event_local values (1, '2022-05-04'), (1, '2022-05-04');
    insert into event_local values (2, '2022-05-04');
    insert into event_local values (3, '2022-05-04');

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

    insert into events values ('#account_login',1652025600414,'7617d3ee-3ae2-456f-b98b-e1521006dcab','8fb8ed76-5a1d-4f65-8832-b99fec056e1e','4.19.18','IOS','5.5.15','app store','电信','Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_9_6 rv:5.0; en-US) AppleWebKit/536.7.3 (KHTML, like Gecko) Version/4.2 Safari/536.7.3','Android','2.2.2','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_7_9 rv:7.0) Gecko/1948-19-01 Firefox/36.0','苹果',1600,900,'10.244.4.1','联通','亚洲','Åland Islands','Louisiana','Boston','wifi','4f0d5455-3839-44e5-a2e4-3c947b255b5f');
    insert into events values ('#account_login',1652025600514,'25b69859-038d-48ee-9de8-66df8399ce17','2a83e739-15db-4edf-b25d-afa92c635793','2.17.11','Golang','4.15.12','app store','电信','Mozilla/5.0 (Windows 98; en-US; rv:1.9.2.20) Gecko/1926-07-09 Firefox/37.0','IOS','5.18.19','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_5_6) AppleWebKit/5312 (KHTML, like Gecko) Chrome/37.0.803.0 Mobile Safari/5312','vivo',1600,1080,'10.244.4.1','移动','大洋洲','United States of America','South Dakota','Henderson','5g','d7974573-9c22-4b38-ad34-b63477147c34');
    insert into events values ('#account_login',1652025600664,'f3952ff8-c922-4818-b537-78d5b8d7d412','046bb6f6-f18d-419c-8ee2-fdd5408c8428','1.19.15','Golang','1.12.20','wechat','联通','Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_9_8 rv:2.0) Gecko/1987-12-10 Firefox/37.0','Android','4.2.11','Mozilla/5.0 (Windows NT 5.2) AppleWebKit/5352 (KHTML, like Gecko) Chrome/40.0.881.0 Mobile Safari/5352','苹果',1600,1080,'10.244.4.1','电信','南美洲','Anguilla','California','Stockton','wifi','b1e34bb2-c482-4bec-8c7f-c42e07e6e7fb');
    insert into events values ('#account_login',1652025600864,'95cb53e0-99ec-4de0-99e2-757023f395f1','85b09a06-1bd7-4712-913d-e797b0604025','2.18.16','Unity','2.2.16','app store','电信','Mozilla/5.0 (Macintosh; PPC Mac OS X 10_8_1) AppleWebKit/5362 (KHTML, like Gecko) Chrome/39.0.847.0 Mobile Safari/5362','Android','1.6.14','Mozilla/5.0 (Windows NT 5.2) AppleWebKit/5352 (KHTML, like Gecko) Chrome/38.0.801.0 Mobile Safari/5352','vivo',1600,1080,'10.244.4.1','电信','欧洲','New Zealand','Oregon','Aurora','wifi','2bb38384-ae7c-421c-9757-1611c4a4f190');
    insert into events values ('#account_login',1652115600015,'608247c3-d209-4faa-94c1-4e9a2f674866','b9b31c3e-cd36-4a4b-87c4-25bf27a58980','3.10.11','Android','2.10.15','app store','联通','Mozilla/5.0 (Windows NT 5.0; en-US; rv:1.9.0.20) Gecko/2000-27-05 Firefox/35.0','Android','4.3.17','Mozilla/5.0 (Windows 98) AppleWebKit/5330 (KHTML, like Gecko) Chrome/36.0.871.0 Mobile Safari/5330','华为',1600,1080,'10.244.4.1','电信','北美洲','Papua New Guinea','South Carolina','Birmingham','wifi','c4ecaf9a-dd33-46b0-b2f6-24b940625be4');
    insert into events values ('#account_login',1652115600064,'f545ff01-88db-48c3-99c3-c73f6470213d','19292474-6724-41e9-8835-27d5d7abfc7a','1.17.8','Unity','1.14.12','app store','联通','Opera/8.48 (X11; Linux i686; en-US) Presto/2.12.276 Version/12.00','IOS','4.3.5','Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_7_8) AppleWebKit/5361 (KHTML, like Gecko) Chrome/40.0.837.0 Mobile Safari/5361','三星',1600,1080,'10.244.4.1','电信','南美洲','Russian Federation','Montana','Madison','4g','b8ef652a-131c-4b06-9479-ebd73404c50a');
    insert into events values ('#account_login',1652115600114,'830cb8e0-d467-46e2-8dc0-951009738bc6','d6f6fe25-ee07-4f11-8368-9cf86d435a18','2.5.15','Unity','4.5.6','wechat','移动','Opera/10.18 (Windows NT 5.01; en-US) Presto/2.12.249 Version/13.00','Android','5.4.5','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_5_9 rv:6.0; en-US) AppleWebKit/532.14.2 (KHTML, like Gecko) Version/5.2 Safari/532.14.2','苹果',1600,900,'10.244.4.1','联通','北美洲','Turkmenistan','Colorado','Baton Rouge','5g','42a40d5f-1b5d-45ad-9fec-5c0b8a8a26f5');


EOSQL