#!/bin/bash
set -e

docker run -it --rm --link clickhouse:clickhouse --net clickhouse-sinker_default yandex/clickhouse-client --host clickhouse --port 9000