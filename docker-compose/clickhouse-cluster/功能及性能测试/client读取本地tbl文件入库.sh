#!/bin/bash
set -e

BEGIN=$(date +%s)
echo "开始时间是" $(date "+%D %T")

clickhouse-client --query "INSERT INTO lineorder FORMAT CSV" < lineorder.tbl

END=`date +%s`
echo "结束时间是" $(date "+%D %T")

echo "一共用时" $(expr $END - $BEGIN) "秒"
