#!/bin/bash
set -e

docker run -it --rm --link clickhouse:clickhouse-server --net cknet yandex/clickhouse-client --host clickhouse-server