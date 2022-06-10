#!/bin/bash
set -e

clickhouse client -n <<-EOSQL
    use default;

    create table test (
        uid         String      COMMENT '用户',
        eventId     String      COMMENT '事件名称',
        eventTime   Date        COMMENT '事件时间'
    ) engine = Memory;

    insert into test values ('小明', '登录', '2020-01-01'), ('小明', '升级', '2020-01-01'), ('小明', '充值', '2020-01-01');
    insert into test values ('小明', '登录', '2020-01-02'); 
    insert into test values ('小明', '升级', '2020-01-03'); 
    insert into test values ('小明', '充值', '2020-01-04');

EOSQL