#!/bin/bash

# toStartOfFiveMinute process_time
SQL_STATEMENT="SELECT toStartOfMinute(toTimezone(toDateTime64(JSONExtractUInt(message, '#time') / 1000, 3), 'Asia/Shanghai')) AS time_window, COUNT(*) AS event_count FROM events_receive_log WHERE (event = '__device__' or event = '__user__') and time_window >= '2025-03-05 18:10:00' and time_window <= '2025-03-05 18:20:00' GROUP BY time_window ORDER BY time_window;"

# 获取所有数据库名称
DATABASES=$(clickhouse-client --query="SHOW DATABASES" --format=TabSeparated | grep -Ev '_global$|_local$')

# 遍历每个数据库并执行 SQL 语句
for DB in $DATABASES; do
    echo "Executing SQL on database: $DB"
    RESULT=$(clickhouse-client --database=$DB --query="$SQL_STATEMENT")
    echo "Result for $DB: $RESULT"
done