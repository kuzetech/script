

表名                                数据量          备注
sausage.lineorder_all               59986052    订单表
sausage.customer_all                30000000    用户表
sausage.part_all                    2000000     商品表
sausage.supplier_all                2000000     供应商表
sausage.date_all                    2556        时间维度表

sausage.lineorder_flat_all          19682       inner join宽表
sausage.lineorder_flat_left_all     59986052    left join宽表

clickhouse-client --send_logs_level=trace <<< " \
set join_algorithm='partial_merge';
SELECT toYear(LO_ORDERDATE) AS year, sum(LO_REVENUE - LO_SUPPLYCOST) AS profit \
FROM sausage.lineorder_all l \
GLOBAL ANY left JOIN sausage.customer_all c ON (c.C_CUSTKEY = l.LO_CUSTKEY) \
GLOBAL ANY left JOIN sausage.supplier_all s ON (s.S_SUPPKEY = l.LO_SUPPKEY) \
GLOBAL ANY left JOIN sausage.part_all p ON  (p.P_PARTKEY = l.LO_PARTKEY) \
WHERE C_REGION = 'AMERICA' \
GROUP BY year \
ORDER BY year; \
" > /dev/null


