
CREATE TABLE new_device_log_local ON CLUSTER test_shard_localhost as sdk_load_log_local
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/tables/{shard}/new_device_log_local', '{replica}')
PARTITION BY toDate(time)
ORDER BY (time, log_id);

CREATE TABLE new_device_log_all ON CLUSTER test_shard_localhost as new_device_log_local
ENGINE = Distributed(test_shard_localhost, default, new_device_log_local, rand());