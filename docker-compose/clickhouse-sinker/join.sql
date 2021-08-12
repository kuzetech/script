
sausage.lineorder_all               59986052
sausage.customer_all                30000000
sausage.part_all                    2000000
sausage.supplier_all                2000000
sausage.date_all                    2556

sausage.lineorder_flat_all          19682
sausage.lineorder_flat_left_all     59986052


SELECT toYear(LO_ORDERDATE) AS year, sum(LO_REVENUE - LO_SUPPLYCOST) AS profit
FROM sausage.lineorder_all l
GLOBAL ANY left JOIN sausage.customer_all c ON (c.C_CUSTKEY = l.LO_CUSTKEY)
GLOBAL ANY left JOIN sausage.supplier_all s ON (s.S_SUPPKEY = l.LO_SUPPKEY)
GLOBAL ANY left JOIN sausage.part_all p ON  (p.P_PARTKEY = l.LO_PARTKEY)
WHERE C_REGION = 'AMERICA' 
GROUP BY year 
ORDER BY year;

