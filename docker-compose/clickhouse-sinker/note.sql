CREATE TABLE default.user_local ON CLUSTER cluster3s(
    id Int32,
    name String,
    time DateTime
)ENGINE = MergeTree() ORDER BY id PARTITION BY toYYYYMMDD(time);