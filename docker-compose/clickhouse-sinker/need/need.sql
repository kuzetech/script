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

clickhouse-client --send_logs_level=trace <<< "
WITH ( SELECT count(distinct C_CUSTKEY) FROM sausage.customer_all ) AS total
SELECT 
    sum(LO_REVENUE) as sum,
    total,
    divide(sum, total) as avrg
FROM sausage.lineorder_all
"
217912388156921 30000000        7263746.271897366

[clickhouse] 2021.08.19 03:57:07.041276 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> executeQuery: (from [::1]:48830, using production parser)  WITH ( SELECT count(distinct C_CUSTKEY) FROM sausage.customer_all ) AS total SELECT sum(LO_REVENUE) as sum, total, divide(sum, total) as avrg FROM sausage.lineorder_all 
[clickhouse] 2021.08.19 03:57:07.041662 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_all
[clickhouse] 2021.08.19 03:57:07.041749 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_all
[clickhouse] 2021.08.19 03:57:08.653470 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_all
[clickhouse] 2021.08.19 03:57:08.653689 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_all

[clickhouse] 2021.08.19 03:57:07.043416 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> executeQuery: (from 192.168.0.38:32880, initial_query_id: f779db89-1e6f-4f10-9787-dbb49ea46cb3, using production parser) SELECT uniqExact(C_CUSTKEY) FROM sausage.customer_local
[clickhouse] 2021.08.19 03:57:07.043723 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_local
[clickhouse] 2021.08.19 03:57:07.043758 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 03:57:07.043825 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 03:57:07.043998 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Selected 2/2 parts by partition key, 2 parts by primary key, 1222/1222 marks by primary key, 1222 marks to read from 2 ranges
[clickhouse] 2021.08.19 03:57:07.044048 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Reading approx. 9999123 rows with 4 streams
[clickhouse] 2021.08.19 03:57:07.044895 [ 225 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.044904 [ 225 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.044957 [ 195 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.044973 [ 195 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.045340 [ 190 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.045352 [ 190 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.045410 [ 189 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.045443 [ 189 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.196467 [ 190 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> AggregatingTransform: Aggregated. 2358831 to 1 rows (from 9.00 MiB) in 0.152319902 sec. (15486032.810 rows/sec., 59.07 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.196606 [ 195 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> AggregatingTransform: Aggregated. 2375742 to 1 rows (from 9.06 MiB) in 0.152453354 sec. (15583402.645 rows/sec., 59.45 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.196984 [ 189 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> AggregatingTransform: Aggregated. 2435541 to 1 rows (from 9.29 MiB) in 0.15283872 sec. (15935366.378 rows/sec., 60.79 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.197238 [ 225 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> AggregatingTransform: Aggregated. 2829009 to 1 rows (from 10.79 MiB) in 0.153085578 sec. (18479918.468 rows/sec., 70.50 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.197251 [ 225 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 03:57:07.720720 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Information> executeQuery: Read 9999123 rows, 38.14 MiB in 0.677272145 sec., 14763818 rows/sec., 56.32 MiB/sec.
[clickhouse] 2021.08.19 03:57:07.720761 [ 216 ] {3c5b331a-3c1b-47dd-8273-7f8d9b626b97} <Debug> MemoryTracker: Peak memory usage (for query): 325.80 MiB.

[clickhouse] 2021.08.19 03:57:07.043527 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> executeQuery: (from 192.168.0.38:51540, initial_query_id: f779db89-1e6f-4f10-9787-dbb49ea46cb3, using production parser) SELECT uniqExact(C_CUSTKEY) FROM sausage.customer_local
[clickhouse] 2021.08.19 03:57:07.043819 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_local
[clickhouse] 2021.08.19 03:57:07.043872 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 03:57:07.043942 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 03:57:07.044114 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Selected 2/2 parts by partition key, 2 parts by primary key, 1221/1221 marks by primary key, 1221 marks to read from 2 ranges
[clickhouse] 2021.08.19 03:57:07.044191 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Reading approx. 10000049 rows with 4 streams
[clickhouse] 2021.08.19 03:57:07.045377 [ 198 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.045393 [ 198 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.045434 [ 187 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.045447 [ 187 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.045460 [ 206 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.045475 [ 206 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.045585 [ 205 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.045611 [ 205 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.195866 [ 205 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> AggregatingTransform: Aggregated. 2375928 to 1 rows (from 9.06 MiB) in 0.151567557 sec. (15675702.947 rows/sec., 59.80 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.195990 [ 187 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> AggregatingTransform: Aggregated. 2792251 to 1 rows (from 10.65 MiB) in 0.151701017 sec. (18406277.395 rows/sec., 70.21 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.196161 [ 198 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> AggregatingTransform: Aggregated. 2406790 to 1 rows (from 9.18 MiB) in 0.151878649 sec. (15846796.214 rows/sec., 60.45 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.196879 [ 206 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> AggregatingTransform: Aggregated. 2425080 to 1 rows (from 9.25 MiB) in 0.152582211 sec. (15893595.879 rows/sec., 60.63 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.196891 [ 206 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 03:57:07.696764 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Information> executeQuery: Read 10000049 rows, 38.15 MiB in 0.653204922 sec., 15309206 rows/sec., 58.40 MiB/sec.
[clickhouse] 2021.08.19 03:57:07.696807 [ 226 ] {8aaa6171-0cc9-497b-b726-2c33a6fb4e4b} <Debug> MemoryTracker: Peak memory usage (for query): 326.05 MiB.

[clickhouse] 2021.08.19 03:57:07.041872 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_local
[clickhouse] 2021.08.19 03:57:07.041903 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 03:57:07.041945 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> InterpreterSelectQuery: WithMergeableState -> Complete
[clickhouse] 2021.08.19 03:57:07.042038 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 03:57:07.042221 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Selected 2/2 parts by partition key, 2 parts by primary key, 1222/1222 marks by primary key, 1222 marks to read from 2 ranges
[clickhouse] 2021.08.19 03:57:07.042278 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Reading approx. 10000828 rows with 4 streams
[clickhouse] 2021.08.19 03:57:07.043317 [ 213 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.043331 [ 213 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.043784 [ 214 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.043822 [ 214 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.043865 [ 234 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.043882 [ 234 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.044028 [ 233 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:07.044036 [ 233 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:07.202846 [ 214 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 2635830 to 1 rows (from 10.05 MiB) in 0.160469186 sec. (16425770.366 rows/sec., 62.66 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.203308 [ 213 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 3040552 to 1 rows (from 11.60 MiB) in 0.160920232 sec. (18894777.631 rows/sec., 72.08 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.220880 [ 234 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 2162130 to 1 rows (from 8.25 MiB) in 0.178497776 sec. (12112924.029 rows/sec., 46.21 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.231902 [ 233 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 2162316 to 1 rows (from 8.25 MiB) in 0.189512825 sec. (11409866.324 rows/sec., 43.53 MiB/sec.)
[clickhouse] 2021.08.19 03:57:07.231918 [ 233 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 03:57:07.726165 [ 191 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Merging partially aggregated blocks (bucket = -1).
[clickhouse] 2021.08.19 03:57:08.652718 [ 191 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> Aggregator: Merged partially aggregated blocks. 1 rows, 8.00 B. in 0.926514942 sec. (1.079 rows/sec., 8.63 B/sec.)

[clickhouse] 2021.08.19 03:57:08.652743 [ 191 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 03:57:08.653142 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 03:57:08.653152 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 03:57:08.653163 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 03:57:08.653179 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Destroying aggregate states

[clickhouse] 2021.08.19 03:57:08.655475 [ 188 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> Connection (ecs-sausage-test-0012:9000): Sent data for 1 scalars, total 1 rows in 3.2374e-05 sec., 29568 rows/sec., 46.00 B (1.29 MiB/sec.), compressed 0.39655172413793105 times to 116.00 B (3.22 MiB/sec.)
[clickhouse] 2021.08.19 03:57:08.655519 [ 187 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> Connection (ecs-sausage-test-0013:9000): Sent data for 1 scalars, total 1 rows in 3.3622e-05 sec., 28621 rows/sec., 46.00 B (1.25 MiB/sec.), compressed 0.39655172413793105 times to 116.00 B (3.12 MiB/sec.)

[clickhouse] 2021.08.19 03:57:08.655854 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> executeQuery: (from 192.168.0.38:51540, initial_query_id: f779db89-1e6f-4f10-9787-dbb49ea46cb3, using production parser) WITH CAST(30000000, 'UInt64') AS total SELECT sum(LO_REVENUE) AS sum, total, sum / total AS avrg FROM sausage.lineorder_local
[clickhouse] 2021.08.19 03:57:08.656338 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_local
[clickhouse] 2021.08.19 03:57:08.656379 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 03:57:08.656503 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 03:57:08.656609 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): MinMax index condition: unknown
[clickhouse] 2021.08.19 03:57:08.656868 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Selected 7/7 parts by partition key, 7 parts by primary key, 2445/2445 marks by primary key, 2445 marks to read from 7 ranges
[clickhouse] 2021.08.19 03:57:08.657012 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Reading approx. 19992678 rows with 4 streams
[clickhouse] 2021.08.19 03:57:08.657776 [ 206 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.657785 [ 206 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.657832 [ 205 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.657856 [ 205 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.657896 [ 187 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.657916 [ 187 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.658309 [ 189 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.658328 [ 189 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.666535 [ 206 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> AggregatingTransform: Aggregated. 5167506 to 1 rows (from 19.71 MiB) in 0.009411919 sec. (549038511.700 rows/sec., 2.05 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.666591 [ 187 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> AggregatingTransform: Aggregated. 4789734 to 1 rows (from 18.27 MiB) in 0.009458724 sec. (506382679.101 rows/sec., 1.89 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.666712 [ 205 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> AggregatingTransform: Aggregated. 5230652 to 1 rows (from 19.95 MiB) in 0.009585855 sec. (545663584.521 rows/sec., 2.03 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.666942 [ 189 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> AggregatingTransform: Aggregated. 4804786 to 1 rows (from 18.33 MiB) in 0.009820305 sec. (489270547.096 rows/sec., 1.82 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.666950 [ 189 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 03:57:08.667461 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Information> executeQuery: Read 19992678 rows, 76.27 MiB in 0.011581419 sec., 1726271884 rows/sec., 6.43 GiB/sec.
[clickhouse] 2021.08.19 03:57:08.667494 [ 226 ] {c010c8ac-a773-4fe7-ae36-63502ccc1e5f} <Debug> MemoryTracker: Peak memory usage (for query): 0.00 B.

[clickhouse] 2021.08.19 03:57:08.655849 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> executeQuery: (from 192.168.0.38:32880, initial_query_id: f779db89-1e6f-4f10-9787-dbb49ea46cb3, using production parser) WITH CAST(30000000, 'UInt64') AS total SELECT sum(LO_REVENUE) AS sum, total, sum / total AS avrg FROM sausage.lineorder_local
[clickhouse] 2021.08.19 03:57:08.656327 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_local
[clickhouse] 2021.08.19 03:57:08.656363 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 03:57:08.656467 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 03:57:08.656584 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): MinMax index condition: unknown
[clickhouse] 2021.08.19 03:57:08.656870 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Selected 7/7 parts by partition key, 7 parts by primary key, 2444/2444 marks by primary key, 2444 marks to read from 7 ranges
[clickhouse] 2021.08.19 03:57:08.657002 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Reading approx. 20000556 rows with 4 streams
[clickhouse] 2021.08.19 03:57:08.657830 [ 225 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.657834 [ 195 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.657840 [ 225 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.657845 [ 195 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.657855 [ 190 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.657869 [ 190 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.658201 [ 201 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.658215 [ 201 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.667089 [ 201 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> AggregatingTransform: Aggregated. 4661929 to 1 rows (from 17.78 MiB) in 0.009978802 sec. (467183235.022 rows/sec., 1.74 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667167 [ 225 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> AggregatingTransform: Aggregated. 5395034 to 1 rows (from 20.58 MiB) in 0.010053528 sec. (536630922.001 rows/sec., 2.00 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667294 [ 195 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> AggregatingTransform: Aggregated. 5275710 to 1 rows (from 20.13 MiB) in 0.010178551 sec. (518316408.691 rows/sec., 1.93 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667485 [ 190 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> AggregatingTransform: Aggregated. 4667883 to 1 rows (from 17.81 MiB) in 0.010365825 sec. (450314663.811 rows/sec., 1.68 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667492 [ 190 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 03:57:08.667985 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Information> executeQuery: Read 20000556 rows, 76.30 MiB in 0.012108942 sec., 1651717879 rows/sec., 6.15 GiB/sec.
[clickhouse] 2021.08.19 03:57:08.668019 [ 216 ] {59ec5830-94e2-4a3d-9305-54438ccaba4f} <Debug> MemoryTracker: Peak memory usage (for query): 0.00 B.

[clickhouse] 2021.08.19 03:57:08.653920 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_local
[clickhouse] 2021.08.19 03:57:08.653945 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 03:57:08.654010 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> InterpreterSelectQuery: WithMergeableState -> Complete
[clickhouse] 2021.08.19 03:57:08.654146 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 03:57:08.654238 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): MinMax index condition: unknown
[clickhouse] 2021.08.19 03:57:08.654481 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Selected 7/7 parts by partition key, 7 parts by primary key, 2446/2446 marks by primary key, 2446 marks to read from 7 ranges
[clickhouse] 2021.08.19 03:57:08.654566 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Reading approx. 19992818 rows with 4 streams
[clickhouse] 2021.08.19 03:57:08.655468 [ 227 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.655483 [ 227 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.655524 [ 199 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.655541 [ 199 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.655543 [ 194 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.655556 [ 194 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.656114 [ 232 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 03:57:08.656137 [ 232 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 03:57:08.667008 [ 194 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 4871426 to 1 rows (from 18.58 MiB) in 0.012333054 sec. (394989432.463 rows/sec., 1.47 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667060 [ 232 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 5071759 to 1 rows (from 19.35 MiB) in 0.01239548 sec. (409161968.718 rows/sec., 1.52 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667128 [ 227 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 4245344 to 1 rows (from 16.19 MiB) in 0.012472975 sec. (340363385.640 rows/sec., 1.27 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667414 [ 199 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> AggregatingTransform: Aggregated. 5804289 to 1 rows (from 22.14 MiB) in 0.012749688 sec. (455249493.164 rows/sec., 1.70 GiB/sec.)
[clickhouse] 2021.08.19 03:57:08.667424 [ 199 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Merging aggregated data

[clickhouse] 2021.08.19 03:57:08.668297 [ 187 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Trace> Aggregator: Merging partially aggregated blocks (bucket = -1).
[clickhouse] 2021.08.19 03:57:08.668325 [ 187 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> Aggregator: Merged partially aggregated blocks. 1 rows, 8.00 B. in 8.906e-06 sec. (112283.854 rows/sec., 877.22 KiB/sec.)
[clickhouse] 2021.08.19 03:57:08.669061 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Information> executeQuery: Read 59986052 rows, 228.83 MiB in 1.627758581 sec., 36851934 rows/sec., 140.58 MiB/sec.
[clickhouse] 2021.08.19 03:57:08.669097 [ 51 ] {f779db89-1e6f-4f10-9787-dbb49ea46cb3} <Debug> MemoryTracker: Peak memory usage (for query): 524.20 MiB.


clickhouse-client --send_logs_level=trace <<< "
WITH ( SELECT count(distinct C_CUSTKEY) FROM sausage.customer_all ) AS num
SELECT
    divide(total, num) as avrg
FROM (
    SELECT sum(LO_REVENUE) as total
    FROM sausage.lineorder_all
)
"

7263746.271897366

[clickhouse] 2021.08.19 05:42:46.005906 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> executeQuery: (from [::1]:50186, using production parser)  WITH ( SELECT count(distinct C_CUSTKEY) FROM sausage.customer_all ) AS num SELECT divide(total, num) as avrg FROM ( SELECT sum(LO_REVENUE) as total FROM sausage.lineorder_all ) 
[clickhouse] 2021.08.19 05:42:46.006359 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_all
[clickhouse] 2021.08.19 05:42:46.006466 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_all
[clickhouse] 2021.08.19 05:42:46.006640 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_all
[clickhouse] 2021.08.19 05:42:46.006781 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_all

[clickhouse] 2021.08.19 05:42:46.008139 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> executeQuery: (from 192.168.0.38:53292, initial_query_id: 4b789af4-6b8c-4e3a-b884-783f567cd88f, using production parser) SELECT uniqExact(C_CUSTKEY) FROM sausage.customer_local
[clickhouse] 2021.08.19 05:42:46.008434 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_local
[clickhouse] 2021.08.19 05:42:46.008465 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 05:42:46.008528 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 05:42:46.008679 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Selected 2/2 parts by partition key, 2 parts by primary key, 1221/1221 marks by primary key, 1221 marks to read from 2 ranges
[clickhouse] 2021.08.19 05:42:46.008743 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Reading approx. 10000049 rows with 4 streams
[clickhouse] 2021.08.19 05:42:46.009749 [ 189 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.009766 [ 189 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.009791 [ 188 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.009803 [ 188 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.009961 [ 206 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.009968 [ 206 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.011814 [ 198 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.011821 [ 198 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.161950 [ 198 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> AggregatingTransform: Aggregated. 2506380 to 1 rows (from 9.56 MiB) in 0.153108029 sec. (16370010.223 rows/sec., 62.45 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.162464 [ 206 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> AggregatingTransform: Aggregated. 2455744 to 1 rows (from 9.37 MiB) in 0.153603432 sec. (15987559.445 rows/sec., 60.99 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.162723 [ 189 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> AggregatingTransform: Aggregated. 2875795 to 1 rows (from 10.97 MiB) in 0.153881097 sec. (18688422.789 rows/sec., 71.29 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.166693 [ 188 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> AggregatingTransform: Aggregated. 2162130 to 1 rows (from 8.25 MiB) in 0.157861931 sec. (13696335.692 rows/sec., 52.25 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.166706 [ 188 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 05:42:46.709880 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Information> executeQuery: Read 10000049 rows, 38.15 MiB in 0.701707554 sec., 14251020 rows/sec., 54.36 MiB/sec.
[clickhouse] 2021.08.19 05:42:46.709920 [ 226 ] {2b7c425a-41d6-4433-9d6d-c90386effe50} <Debug> MemoryTracker: Peak memory usage (for query): 326.05 MiB.

[clickhouse] 2021.08.19 05:42:46.008585 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> executeQuery: (from 192.168.0.38:34632, initial_query_id: 4b789af4-6b8c-4e3a-b884-783f567cd88f, using production parser) SELECT uniqExact(C_CUSTKEY) FROM sausage.customer_local
[clickhouse] 2021.08.19 05:42:46.008942 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_local
[clickhouse] 2021.08.19 05:42:46.008982 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 05:42:46.009118 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 05:42:46.009285 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Selected 2/2 parts by partition key, 2 parts by primary key, 1222/1222 marks by primary key, 1222 marks to read from 2 ranges
[clickhouse] 2021.08.19 05:42:46.009372 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Reading approx. 9999123 rows with 4 streams
[clickhouse] 2021.08.19 05:42:46.010323 [ 198 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.010332 [ 198 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.010699 [ 195 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.010710 [ 195 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.010820 [ 188 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.010834 [ 188 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.010867 [ 203 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.010878 [ 203 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.161706 [ 203 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> AggregatingTransform: Aggregated. 2351104 to 1 rows (from 8.97 MiB) in 0.152202736 sec. (15447186.179 rows/sec., 58.93 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.162302 [ 198 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> AggregatingTransform: Aggregated. 2424708 to 1 rows (from 9.25 MiB) in 0.152792939 sec. (15869241.183 rows/sec., 60.54 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.162410 [ 195 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> AggregatingTransform: Aggregated. 2811633 to 1 rows (from 10.73 MiB) in 0.152918139 sec. (18386523.786 rows/sec., 70.14 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.162523 [ 188 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> AggregatingTransform: Aggregated. 2411678 to 1 rows (from 9.20 MiB) in 0.153012117 sec. (15761353.070 rows/sec., 60.12 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.162548 [ 188 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 05:42:46.691289 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Information> executeQuery: Read 9999123 rows, 38.14 MiB in 0.682667312 sec., 14647138 rows/sec., 55.87 MiB/sec.
[clickhouse] 2021.08.19 05:42:46.691330 [ 216 ] {0321c7d0-fec7-49bc-96bb-efc8c2e29a1c} <Debug> MemoryTracker: Peak memory usage (for query): 326.05 MiB.


[clickhouse] 2021.08.19 05:42:46.006927 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(C_CUSTKEY) ON sausage.customer_local
[clickhouse] 2021.08.19 05:42:46.006967 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 05:42:46.007021 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> InterpreterSelectQuery: WithMergeableState -> Complete
[clickhouse] 2021.08.19 05:42:46.007103 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 05:42:46.007258 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Selected 2/2 parts by partition key, 2 parts by primary key, 1222/1222 marks by primary key, 1222 marks to read from 2 ranges
[clickhouse] 2021.08.19 05:42:46.007324 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> sausage.customer_local (3dd3808e-694d-4a82-bdd3-808e694dca82) (SelectExecutor): Reading approx. 10000828 rows with 4 streams
[clickhouse] 2021.08.19 05:42:46.008253 [ 234 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.008266 [ 234 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.008330 [ 230 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.008346 [ 230 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.008590 [ 191 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.008610 [ 191 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.009087 [ 194 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:46.009126 [ 194 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:46.168373 [ 234 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 3064601 to 1 rows (from 11.69 MiB) in 0.160920204 sec. (19044227.660 rows/sec., 72.65 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.168546 [ 230 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 2611595 to 1 rows (from 9.96 MiB) in 0.161079045 sec. (16213126.915 rows/sec., 61.85 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.183151 [ 191 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 2162130 to 1 rows (from 8.25 MiB) in 0.175712526 sec. (12304928.107 rows/sec., 46.94 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.192274 [ 194 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 2162502 to 1 rows (from 8.25 MiB) in 0.184830765 sec. (11699902.881 rows/sec., 44.63 MiB/sec.)
[clickhouse] 2021.08.19 05:42:46.192286 [ 194 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 05:42:46.715401 [ 187 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Merging partially aggregated blocks (bucket = -1).
[clickhouse] 2021.08.19 05:42:47.635351 [ 187 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> Aggregator: Merged partially aggregated blocks. 1 rows, 8.00 B. in 0.919918147 sec. (1.087 rows/sec., 8.70 B/sec.)
[clickhouse] 2021.08.19 05:42:47.635374 [ 187 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 05:42:47.635818 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 05:42:47.635828 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 05:42:47.635838 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Destroying aggregate states
[clickhouse] 2021.08.19 05:42:47.635849 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Destroying aggregate states

[clickhouse] 2021.08.19 05:42:47.636036 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_all
[clickhouse] 2021.08.19 05:42:47.636321 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_all
[clickhouse] 2021.08.19 05:42:47.637987 [ 233 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> Connection (ecs-sausage-test-0012:9000): Sent data for 1 scalars, total 1 rows in 2.1765e-05 sec., 43187 rows/sec., 46.00 B (1.84 MiB/sec.), compressed 0.39655172413793105 times to 116.00 B (4.60 MiB/sec.)
[clickhouse] 2021.08.19 05:42:47.637993 [ 228 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> Connection (ecs-sausage-test-0013:9000): Sent data for 1 scalars, total 1 rows in 3.5397e-05 sec., 27229 rows/sec., 46.00 B (1.19 MiB/sec.), compressed 0.39655172413793105 times to 116.00 B (2.97 MiB/sec.)

[clickhouse] 2021.08.19 05:42:47.638383 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> executeQuery: (from 192.168.0.38:34632, initial_query_id: 4b789af4-6b8c-4e3a-b884-783f567cd88f, using production parser) WITH CAST(30000000, 'UInt64') AS num SELECT sum(LO_REVENUE) AS total FROM sausage.lineorder_local
[clickhouse] 2021.08.19 05:42:47.638750 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_local
[clickhouse] 2021.08.19 05:42:47.638785 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 05:42:47.638895 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 05:42:47.638970 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): MinMax index condition: unknown
[clickhouse] 2021.08.19 05:42:47.639245 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Selected 7/7 parts by partition key, 7 parts by primary key, 2444/2444 marks by primary key, 2444 marks to read from 7 ranges
[clickhouse] 2021.08.19 05:42:47.639331 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Reading approx. 20000556 rows with 4 streams
[clickhouse] 2021.08.19 05:42:47.640143 [ 189 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.640156 [ 189 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.640157 [ 195 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.640159 [ 198 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.640168 [ 195 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.640175 [ 198 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.640661 [ 225 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.640672 [ 225 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.648929 [ 198 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> AggregatingTransform: Aggregated. 4642798 to 1 rows (from 17.71 MiB) in 0.009484358 sec. (489521589.126 rows/sec., 1.82 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.649030 [ 225 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> AggregatingTransform: Aggregated. 4717779 to 1 rows (from 18.00 MiB) in 0.009581542 sec. (492382019.512 rows/sec., 1.83 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.649439 [ 189 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> AggregatingTransform: Aggregated. 5591469 to 1 rows (from 21.33 MiB) in 0.010004114 sec. (558916961.562 rows/sec., 2.08 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.649594 [ 195 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> AggregatingTransform: Aggregated. 5048510 to 1 rows (from 19.26 MiB) in 0.010151881 sec. (497297988.422 rows/sec., 1.85 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.649601 [ 195 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 05:42:47.652831 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Information> executeQuery: Read 20000556 rows, 76.30 MiB in 0.014422392 sec., 1386771070 rows/sec., 5.17 GiB/sec.
[clickhouse] 2021.08.19 05:42:47.652871 [ 216 ] {bc8192b5-5114-4637-ba67-6f416223f48b} <Debug> MemoryTracker: Peak memory usage (for query): 0.00 B.

[clickhouse] 2021.08.19 05:42:47.638093 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> executeQuery: (from 192.168.0.38:53292, initial_query_id: 4b789af4-6b8c-4e3a-b884-783f567cd88f, using production parser) WITH CAST(30000000, 'UInt64') AS num SELECT sum(LO_REVENUE) AS total FROM sausage.lineorder_local
[clickhouse] 2021.08.19 05:42:47.639289 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_local
[clickhouse] 2021.08.19 05:42:47.639334 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 05:42:47.639463 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 05:42:47.639542 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): MinMax index condition: unknown
[clickhouse] 2021.08.19 05:42:47.639774 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Selected 7/7 parts by partition key, 7 parts by primary key, 2445/2445 marks by primary key, 2445 marks to read from 7 ranges
[clickhouse] 2021.08.19 05:42:47.639866 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Reading approx. 19992678 rows with 4 streams
[clickhouse] 2021.08.19 05:42:47.640641 [ 198 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.640659 [ 206 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.640659 [ 198 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.640671 [ 206 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.640698 [ 227 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.640712 [ 227 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.641035 [ 189 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.641047 [ 189 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.649772 [ 189 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> AggregatingTransform: Aggregated. 4997797 to 1 rows (from 19.07 MiB) in 0.009811148 sec. (509399817.432 rows/sec., 1.90 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.650003 [ 227 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> AggregatingTransform: Aggregated. 5197723 to 1 rows (from 19.83 MiB) in 0.010017493 sec. (518864650.068 rows/sec., 1.93 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.650068 [ 206 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> AggregatingTransform: Aggregated. 5492918 to 1 rows (from 20.95 MiB) in 0.010088551 sec. (544470459.633 rows/sec., 2.03 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.650091 [ 198 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> AggregatingTransform: Aggregated. 4304240 to 1 rows (from 16.42 MiB) in 0.010117551 sec. (425423108.814 rows/sec., 1.58 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.650102 [ 198 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Trace> Aggregator: Merging aggregated data
[clickhouse] 2021.08.19 05:42:47.650582 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Information> executeQuery: Read 19992678 rows, 76.27 MiB in 0.012461761 sec., 1604322053 rows/sec., 5.98 GiB/sec.
[clickhouse] 2021.08.19 05:42:47.650614 [ 226 ] {cab9b776-f03f-439a-b82f-482959fc1598} <Debug> MemoryTracker: Peak memory usage (for query): 0.00 B.

[clickhouse] 2021.08.19 05:42:47.636501 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> ContextAccess (default): Access granted: SELECT(LO_REVENUE) ON sausage.lineorder_local
[clickhouse] 2021.08.19 05:42:47.636536 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> InterpreterSelectQuery: FetchColumns -> WithMergeableState
[clickhouse] 2021.08.19 05:42:47.636578 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> InterpreterSelectQuery: WithMergeableState -> Complete
[clickhouse] 2021.08.19 05:42:47.636603 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> InterpreterSelectQuery: FetchColumns -> Complete
[clickhouse] 2021.08.19 05:42:47.636719 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Key condition: unknown
[clickhouse] 2021.08.19 05:42:47.636803 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): MinMax index condition: unknown
[clickhouse] 2021.08.19 05:42:47.637019 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Selected 7/7 parts by partition key, 7 parts by primary key, 2446/2446 marks by primary key, 2446 marks to read from 7 ranges
[clickhouse] 2021.08.19 05:42:47.637105 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> sausage.lineorder_local (725778aa-2686-44e2-b257-78aa268644e2) (SelectExecutor): Reading approx. 19992818 rows with 4 streams
[clickhouse] 2021.08.19 05:42:47.638017 [ 227 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.638030 [ 227 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.638213 [ 213 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.638225 [ 213 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.638497 [ 232 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.638510 [ 232 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.638603 [ 214 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> AggregatingTransform: Aggregating
[clickhouse] 2021.08.19 05:42:47.638627 [ 214 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Aggregation method: without_key
[clickhouse] 2021.08.19 05:42:47.647690 [ 232 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 4941577 to 1 rows (from 18.85 MiB) in 0.010488473 sec. (471143606.891 rows/sec., 1.76 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.647725 [ 213 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 5083249 to 1 rows (from 19.39 MiB) in 0.010521145 sec. (483145988.388 rows/sec., 1.80 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.647725 [ 227 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 5280871 to 1 rows (from 20.14 MiB) in 0.010521126 sec. (501930211.652 rows/sec., 1.87 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.647955 [ 214 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> AggregatingTransform: Aggregated. 4687121 to 1 rows (from 17.88 MiB) in 0.010764105 sec. (435439918.135 rows/sec., 1.62 GiB/sec.)
[clickhouse] 2021.08.19 05:42:47.647971 [ 214 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Merging aggregated data

[clickhouse] 2021.08.19 05:42:47.653063 [ 228 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Trace> Aggregator: Merging partially aggregated blocks (bucket = -1).
[clickhouse] 2021.08.19 05:42:47.653085 [ 228 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> Aggregator: Merged partially aggregated blocks. 1 rows, 8.00 B. in 9.038e-06 sec. (110643.948 rows/sec., 864.41 KiB/sec.)
[clickhouse] 2021.08.19 05:42:47.655239 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Information> executeQuery: Read 59986052 rows, 228.83 MiB in 1.6493049 sec., 36370504 rows/sec., 138.74 MiB/sec.
[clickhouse] 2021.08.19 05:42:47.655276 [ 51 ] {4b789af4-6b8c-4e3a-b884-783f567cd88f} <Debug> MemoryTracker: Peak memory usage (for query): 526.21 MiB.