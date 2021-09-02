create database dm on cluster cluster3s;

CREATE TABLE default.user_local ON CLUSTER cluster3s(
    id Int32,
    name String,
    time DateTime
)ENGINE = MergeTree() ORDER BY id PARTITION BY toYYYYMMDD(time);

CREATE TABLE dm.customer_local ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_ADDRESS       String,
        C_CITY          LowCardinality(String),
        C_NATION        LowCardinality(String),
        C_REGION        LowCardinality(String),
        C_PHONE         String,
        C_MKTSEGMENT    LowCardinality(String)
)
ENGINE = MergeTree ORDER BY (C_CUSTKEY);

CREATE TABLE dm.customer_all ON CLUSTER cluster3s
(
        C_CUSTKEY       UInt32,
        C_NAME          String,
        C_ADDRESS       String,
        C_CITY          LowCardinality(String),
        C_NATION        LowCardinality(String),
        C_REGION        LowCardinality(String),
        C_PHONE         String,
        C_MKTSEGMENT    LowCardinality(String)
)
ENGINE = Distributed(cluster3s, dm, customer_local, rand());

docker exec -i clickhouse clickhouse-client --query "INSERT INTO dm.customer_all FORMAT CSV" < customer.tbl

CREATE TABLE dm.lineorder_local ON CLUSTER cluster3s
(
    LO_ORDERKEY             UInt32,
    LO_LINENUMBER           UInt8,
    LO_CUSTKEY              UInt32,
    LO_PARTKEY              UInt32,
    LO_SUPPKEY              UInt32,
    LO_ORDERDATE            Date,
    LO_ORDERPRIORITY        LowCardinality(String),
    LO_SHIPPRIORITY         UInt8,
    LO_QUANTITY             UInt8,
    LO_EXTENDEDPRICE        UInt32,
    LO_ORDTOTALPRICE        UInt32,
    LO_DISCOUNT             UInt8,
    LO_REVENUE              UInt32,
    LO_SUPPLYCOST           UInt32,
    LO_TAX                  UInt8,
    LO_COMMITDATE           Date,
    LO_SHIPMODE             LowCardinality(String)
)
ENGINE = MergeTree PARTITION BY toYear(LO_ORDERDATE) ORDER BY (LO_ORDERDATE, LO_ORDERKEY);

CREATE TABLE dm.lineorder_all ON CLUSTER cluster3s
(
    LO_ORDERKEY             UInt32,
    LO_LINENUMBER           UInt8,
    LO_CUSTKEY              UInt32,
    LO_PARTKEY              UInt32,
    LO_SUPPKEY              UInt32,
    LO_ORDERDATE            Date,
    LO_ORDERPRIORITY        LowCardinality(String),
    LO_SHIPPRIORITY         UInt8,
    LO_QUANTITY             UInt8,
    LO_EXTENDEDPRICE        UInt32,
    LO_ORDTOTALPRICE        UInt32,
    LO_DISCOUNT             UInt8,
    LO_REVENUE              UInt32,
    LO_SUPPLYCOST           UInt32,
    LO_TAX                  UInt8,
    LO_COMMITDATE           Date,
    LO_SHIPMODE             LowCardinality(String)
)
ENGINE = Distributed(cluster3s, dm, lineorder_local,rand());

clickhouse-client --query "INSERT INTO dm.lineorder_all FORMAT CSV" < lineorder.tbl


CREATE TABLE dm.part_local ON CLUSTER cluster3s
(
        P_PARTKEY       UInt32,
        P_NAME          String,
        P_MFGR          LowCardinality(String),
        P_CATEGORY      LowCardinality(String),
        P_BRAND         LowCardinality(String),
        P_COLOR         LowCardinality(String),
        P_TYPE          LowCardinality(String),
        P_SIZE          UInt8,
        P_CONTAINER     LowCardinality(String)
)
ENGINE = MergeTree ORDER BY P_PARTKEY;

CREATE TABLE dm.part_all ON CLUSTER cluster3s
(
        P_PARTKEY       UInt32,
        P_NAME          String,
        P_MFGR          LowCardinality(String),
        P_CATEGORY      LowCardinality(String),
        P_BRAND         LowCardinality(String),
        P_COLOR         LowCardinality(String),
        P_TYPE          LowCardinality(String),
        P_SIZE          UInt8,
        P_CONTAINER     LowCardinality(String)
)
ENGINE = Distributed(cluster3s, dm, part_local,rand());

clickhouse-client --query "INSERT INTO dm.part_all FORMAT CSV" < part.tbl

CREATE TABLE dm.supplier_local ON CLUSTER cluster3s
(
        S_SUPPKEY       UInt32,
        S_NAME          String,
        S_ADDRESS       String,
        S_CITY          LowCardinality(String),
        S_NATION        LowCardinality(String),
        S_REGION        LowCardinality(String),
        S_PHONE         String
)
ENGINE = MergeTree ORDER BY S_SUPPKEY;

CREATE TABLE dm.supplier_all ON CLUSTER cluster3s
(
        S_SUPPKEY       UInt32,
        S_NAME          String,
        S_ADDRESS       String,
        S_CITY          LowCardinality(String),
        S_NATION        LowCardinality(String),
        S_REGION        LowCardinality(String),
        S_PHONE         String
)
ENGINE = Distributed(cluster3s, dm, supplier_local, rand());

clickhouse-client --query "INSERT INTO dm.supplier_all FORMAT CSV" < supplier.tbl

CREATE TABLE dm.date_local ON CLUSTER cluster3s
(
        D_DATEKEY           UInt32,
        D_DATE              String,
        D_DAYOFWEEK         LowCardinality(String),
        D_MONTH             LowCardinality(String),
        D_YEAR              UInt16,
        D_YEARMONTHNUM      UInt32,
        D_YEARMONTH         LowCardinality(String),
        D_DAYNUMINWEEK      UInt8,
        D_DAYNUMINMONTH     UInt8,
        D_DAYNUMINYEAR      UInt16,
        D_MONTHNUMINYEAR    UInt8,
        D_WEEKNUMINYEAR     UInt8,
        D_SELLINGSEASON     LowCardinality(String),
        D_HOLIDAYFL         String,
        D_NOTLASTDAYINMONTH String,
        D_UNKNOWN           String,
        D_WEEKDAYFL         String
)
ENGINE = MergeTree ORDER BY D_DATEKEY;

CREATE TABLE dm.date_all ON CLUSTER cluster3s
(
        D_DATEKEY           UInt32,
        D_DATE              String,
        D_DAYOFWEEK         LowCardinality(String),
        D_MONTH             LowCardinality(String),
        D_YEAR              UInt16,
        D_YEARMONTHNUM      UInt32,
        D_YEARMONTH         LowCardinality(String),
        D_DAYNUMINWEEK      UInt8,
        D_DAYNUMINMONTH     UInt8,
        D_DAYNUMINYEAR      UInt16,
        D_MONTHNUMINYEAR    UInt8,
        D_WEEKNUMINYEAR     UInt8,
        D_SELLINGSEASON     LowCardinality(String),
        D_HOLIDAYFL         String,
        D_NOTLASTDAYINMONTH String,
        D_UNKNOWN           String,
        D_WEEKDAYFL         String
)
ENGINE = Distributed(cluster3s, dm, date_local,rand());

clickhouse-client --query "INSERT INTO dm.date_all FORMAT CSV" < date.tbl

CREATE TABLE dm.lineorder_flat_local ON CLUSTER cluster3s
ENGINE = MergeTree
PARTITION BY toYear(l.LO_ORDERDATE)
ORDER BY (l.LO_ORDERDATE, l.LO_ORDERKEY) AS
SELECT l.*, c.*, s.*, p.*
FROM dm.lineorder_local l
 ANY INNER JOIN dm.customer_local c ON (c.C_CUSTKEY = l.LO_CUSTKEY)
 ANY INNER JOIN dm.supplier_local s ON (s.S_SUPPKEY = l.LO_SUPPKEY)
 ANY INNER JOIN dm.part_local p ON  (p.P_PARTKEY = l.LO_PARTKEY)
where l.LO_ORDERKEY < 100;

CREATE TABLE dm.lineorder_flat_local ON CLUSTER cluster3s
(
    LO_ORDERKEY UInt32,
    LO_LINENUMBER UInt8,
    LO_CUSTKEY UInt32,
    LO_PARTKEY UInt32,
    LO_SUPPKEY UInt32,
    LO_ORDERDATE Date,
    LO_ORDERPRIORITY LowCardinality(String),
    LO_SHIPPRIORITY UInt8,
    LO_QUANTITY UInt8,
    LO_EXTENDEDPRICE UInt32,
    LO_ORDTOTALPRICE UInt32,
    LO_DISCOUNT UInt8,
    LO_REVENUE UInt32,
    LO_SUPPLYCOST UInt32,
    LO_TAX UInt8,
    LO_COMMITDATE Date,
    LO_SHIPMODE LowCardinality(String),
    C_CUSTKEY UInt32,
    C_NAME String,
    C_ADDRESS String,
    C_CITY LowCardinality(String),
    C_NATION LowCardinality(String),
    C_REGION LowCardinality(String),
    C_PHONE String,
    C_MKTSEGMENT LowCardinality(String),
    S_SUPPKEY UInt32,
    S_NAME String,
    S_ADDRESS String,
    S_CITY LowCardinality(String),
    S_NATION LowCardinality(String),
    S_REGION LowCardinality(String),
    S_PHONE String,
    P_PARTKEY UInt32,
    P_NAME String,
    P_MFGR LowCardinality(String),
    P_CATEGORY LowCardinality(String),
    P_BRAND LowCardinality(String),
    P_COLOR LowCardinality(String),
    P_TYPE LowCardinality(String),
    P_SIZE UInt8,
    P_CONTAINER LowCardinality(String)
)
ENGINE = MergeTree PARTITION BY toYear(LO_ORDERDATE) ORDER BY (LO_ORDERDATE, LO_ORDERKEY);

CREATE TABLE dm.lineorder_flat_all ON CLUSTER cluster3s
(
    LO_ORDERKEY UInt32,
    LO_LINENUMBER UInt8,
    LO_CUSTKEY UInt32,
    LO_PARTKEY UInt32,
    LO_SUPPKEY UInt32,
    LO_ORDERDATE Date,
    LO_ORDERPRIORITY LowCardinality(String),
    LO_SHIPPRIORITY UInt8,
    LO_QUANTITY UInt8,
    LO_EXTENDEDPRICE UInt32,
    LO_ORDTOTALPRICE UInt32,
    LO_DISCOUNT UInt8,
    LO_REVENUE UInt32,
    LO_SUPPLYCOST UInt32,
    LO_TAX UInt8,
    LO_COMMITDATE Date,
    LO_SHIPMODE LowCardinality(String),
    C_CUSTKEY UInt32,
    C_NAME String,
    C_ADDRESS String,
    C_CITY LowCardinality(String),
    C_NATION LowCardinality(String),
    C_REGION LowCardinality(String),
    C_PHONE String,
    C_MKTSEGMENT LowCardinality(String),
    S_SUPPKEY UInt32,
    S_NAME String,
    S_ADDRESS String,
    S_CITY LowCardinality(String),
    S_NATION LowCardinality(String),
    S_REGION LowCardinality(String),
    S_PHONE String,
    P_PARTKEY UInt32,
    P_NAME String,
    P_MFGR LowCardinality(String),
    P_CATEGORY LowCardinality(String),
    P_BRAND LowCardinality(String),
    P_COLOR LowCardinality(String),
    P_TYPE LowCardinality(String),
    P_SIZE UInt8,
    P_CONTAINER LowCardinality(String)
)
ENGINE = Distributed(cluster3s, dm, lineorder_flat_local,rand());

CREATE TABLE dm.lineorder_flat_left_all ON CLUSTER cluster3s
(
    LO_ORDERKEY UInt32,
    LO_LINENUMBER UInt8,
    LO_CUSTKEY UInt32,
    LO_PARTKEY UInt32,
    LO_SUPPKEY UInt32,
    LO_ORDERDATE Date,
    LO_ORDERPRIORITY LowCardinality(String),
    LO_SHIPPRIORITY UInt8,
    LO_QUANTITY UInt8,
    LO_EXTENDEDPRICE UInt32,
    LO_ORDTOTALPRICE UInt32,
    LO_DISCOUNT UInt8,
    LO_REVENUE UInt32,
    LO_SUPPLYCOST UInt32,
    LO_TAX UInt8,
    LO_COMMITDATE Date,
    LO_SHIPMODE LowCardinality(String),
    C_CUSTKEY UInt32,
    C_NAME String,
    C_ADDRESS String,
    C_CITY LowCardinality(String),
    C_NATION LowCardinality(String),
    C_REGION LowCardinality(String),
    C_PHONE String,
    C_MKTSEGMENT LowCardinality(String),
    S_SUPPKEY UInt32,
    S_NAME String,
    S_ADDRESS String,
    S_CITY LowCardinality(String),
    S_NATION LowCardinality(String),
    S_REGION LowCardinality(String),
    S_PHONE String,
    P_PARTKEY UInt32,
    P_NAME String,
    P_MFGR LowCardinality(String),
    P_CATEGORY LowCardinality(String),
    P_BRAND LowCardinality(String),
    P_COLOR LowCardinality(String),
    P_TYPE LowCardinality(String),
    P_SIZE UInt8,
    P_CONTAINER LowCardinality(String)
)
ENGINE = Distributed(cluster3s, dm, lineorder_flat_left_local,rand());

INSERT INTO dm.lineorder_flat_all
SELECT l.*, c.*, s.*, p.*
FROM dm.lineorder_all l
 GLOBAL ANY INNER JOIN dm.customer_all c ON (c.C_CUSTKEY = l.LO_CUSTKEY)
 GLOBAL ANY INNER JOIN dm.supplier_all s ON (s.S_SUPPKEY = l.LO_SUPPKEY)
 GLOBAL ANY INNER JOIN dm.part_all p ON  (p.P_PARTKEY = l.LO_PARTKEY);

INSERT INTO dm.lineorder_flat_left_all
SELECT l.*, c.*, s.*, p.*
FROM dm.lineorder_all l
 GLOBAL ANY left JOIN dm.customer_all c ON (c.C_CUSTKEY = l.LO_CUSTKEY)
 GLOBAL ANY left JOIN dm.supplier_all s ON (s.S_SUPPKEY = l.LO_SUPPKEY)
 GLOBAL ANY left JOIN dm.part_all p ON  (p.P_PARTKEY = l.LO_PARTKEY);

ALTER TABLE dm.lineorder_flat_all on cluster cluster3s DROP COLUMN C_CUSTKEY, DROP COLUMN S_SUPPKEY, DROP COLUMN P_PARTKEY;
ALTER TABLE dm.lineorder_flat_local on cluster cluster3s DROP COLUMN C_CUSTKEY, DROP COLUMN S_SUPPKEY, DROP COLUMN P_PARTKEY;