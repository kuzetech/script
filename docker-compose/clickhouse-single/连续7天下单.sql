

create table test_pyq (
    uid UInt32,
    time date
) engine = Memory;


insert into test_pyq values 
(1, '2020-01-01'), (1, '2020-01-02'), (1, '2020-01-03'), (1, '2020-01-10'),
(2, '2020-01-01'), (2, '2020-01-02'), (2, '2020-01-05'), (2, '2020-01-15'),
(3, '2020-01-02'), (3, '2020-01-11');


with toDate('2020-01-01') as first_date
select 
    bitmapToArray(groupBitmapAndState(bitmapBuild(bm))) as result
from (
    select 
        time,
        groupArray(uid) as bm
    from test_pyq
    where time >= first_date and time <= (first_date + interval 3 day)
    group by time
);

