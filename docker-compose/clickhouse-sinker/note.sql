CREATE TABLE default.user_local (
    id Int32,
    name String,
    time DateTime
)ENGINE = MergeTree() ORDER BY id PARTITION BY toYYYYMMDD(time);