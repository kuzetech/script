#!/bin/bash
set -e

HOST_NAME=$1

docker run -it --rm --link ${HOST_NAME}:${HOST_NAME} --net cknet yandex/clickhouse-client --host ${HOST_NAME} --port 9000

#docker run -it --rm --network host yandex/clickhouse-client --host localhost --port 9000