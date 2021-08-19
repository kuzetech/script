"

clickhouse-client --send_logs_level=trace <<< "
SELECT 
    toYear(o.LO_ORDERDATE) AS year, 
    sum(o.LO_REVENUE - o.LO_SUPPLYCOST) AS profit
FROM (
    SELECT LO_ORDERDATE, LO_REVENUE, LO_SUPPLYCOST, LO_CUSTKEY
    FROM sausage.lineorder_all
) o
GLOBAL ANY left JOIN (
    SELECT C_CUSTKEY
    FROM sausage.customer_all
    WHERE C_REGION = 'AMERICA'
) c
ON c.C_CUSTKEY = o.LO_CUSTKEY
WHERE c.C_CUSTKEY != 0
GROUP BY year
ORDER BY year ASC
"

clickhouse-client --send_logs_level=trace <<< "
SELECT count(distinct C_CUSTKEY) FROM sausage.customer_all 
"
30000000

clickhouse-client --send_logs_level=trace <<< "
SELECT sum(LO_REVENUE) FROM sausage.lineorder_all 
"
217912388156921

