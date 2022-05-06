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

EOSQL