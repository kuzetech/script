#!/bin/bash
set -e

clickhouse client -n <<-EOSQL
    use default;

    CREATE TABLE event_local
    (
        id          UInt32,
        event        String,
        time        Int64,
        dt          Date
    )
    ENGINE = MergeTree
    PARTITION BY (dt, event)
    ORDER BY (time, id);

    insert into event_local values (1, 'a', 1,'2022-05-03'), (2, 'b', 2, '2022-05-04');

EOSQL