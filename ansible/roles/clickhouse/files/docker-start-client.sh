#!/bin/bash
set -e

docker run -it --rm --network host yandex/clickhouse-client --host localhost --port 9000