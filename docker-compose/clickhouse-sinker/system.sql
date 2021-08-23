
SELECT name, total_rows, intDiv(total_bytes, 1048576) as total_size_MB FROM system.tables WHERE database='sausage'

clickhouse-client -q 'show tables in system'

clickhouse-client -q 'desc system.settings'

clickhouse-client -q "select name, value from system.settings where name='join_algorithm'"
