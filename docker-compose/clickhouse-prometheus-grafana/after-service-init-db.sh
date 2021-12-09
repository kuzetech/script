#!/bin/bash
set -ex

clickhouse-client -n <<-EOSQL
    CREATE TABLE IF NOT EXISTS system.query_log_all ON CLUSTER c1s1r as system.query_log
    ENGINE = Distributed(c1s1r, system, query_log);
EOSQL

# docker exec clickhouse clickhouse-client -q 'CREATE TABLE IF NOT EXISTS system.query_log_all ON CLUSTER c1s1r as system.query_log ENGINE = Distributed(c1s1r, system, query_log);'