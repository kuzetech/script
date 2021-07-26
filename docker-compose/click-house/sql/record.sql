CREATE TABLE docker.partition2s2r ON CLUSTER my2s2r(
    id String,
    url String,
    time Date
) ENGINE = ReplicatedMergeTree() PARTITION BY toYYYYMM(time) ORDER BY id;

SELECT * FROM system.zookeeper where path = '/clickhouse';

INSERT INTO docker.partition2s2r VALUES
('1','1','2021-01-01'),
('2','2','2021-01-02'),
('3','3','2021-01-03'),
('4','4','2021-01-04');

INSERT INTO docker.partition2s2r VALUES
('5','5','2021-01-05'),
('6','6','2021-01-06'),
('7','7','2021-01-07'),
('8','8','2021-01-08');