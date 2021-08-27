
-- 给定期望的路径终点，途经点和最大时间间隔
-- 查询出符合条件的路径详情，及符合路径的用户数
-- 按照用户数降序排列

create table test_path (
    uid UInt32,
    event_type String,
    ts_date date,
    ts_date_time Datetime
) engine = Memory;

insert into test_path values
(1, 'login', '2020-01-01', '2020-01-01 01:00:00'),
(1, 'login', '2020-01-01', '2020-01-01 02:00:00'),
(1, 'login', '2020-01-01', '2020-01-01 03:00:00'),
(2, 'login', '2020-01-01', '2020-01-01 01:00:00'),
(2, 'login', '2020-01-01', '2020-01-01 02:00:00'),
(2, 'login', '2020-01-01', '2020-01-01 03:00:00');

insert into test_path values
(3, 'login', '2020-01-01', '2020-01-01 01:01:00'),
(3, 'login', '2020-01-01', '2020-01-01 01:02:00'),
(3, 'login', '2020-01-01', '2020-01-01 01:03:00');

select
    result_chain,
    uniqCombined(uid) as user_count
from(
    with
        toUInt32(maxIf(ts_date_time, event_type = 'buy')) as end_event_max,
        arrayCompact(arraySort(
            x -> x.1,
            arrayFilter(
                x -> x.1 <= end_event_max,
                groupArray((toUInt32(ts_date_time), (event_type)))
            )
        )) as sorted_events,
        arrayEnumerate(sorted_events) as event_idxs,
        arrayFilter(
            (x, y, z) -> z.1 <= end_event_max and z.2.1 = 'buy' or y > 600),
            event_idxs,
            arrayDifference(sorted_events.1),
            sorted_events
        ) as gap_idxs,
        arrayMap( x -> x+1, gap_idxs) as gap_idxs_,
        arrayMap( x -> if(has(gap_idxs_, x), 1, 0), event_idxs) as gap_masks,
        arraySplit((x, y) -> y, sorted_events, gap_masks) as split_events
    select
        uid,
        arrayJoin(split_events) as event_chain_,
        arrayCompact(event_chain_.2) as event_chain,
        hasAll(event_chain, [('login', 'view')]) as has_midway_hit,
        arrayStringConcat(arrayMap(
            x -> concat(x.1, '#', x.2),
            event_chain
        ), ' -> ') as result_chain
    from(
        select ts_date, ts_date_time, event_type, uid
        from test_path
        where ts_date = '2020-01-01'
    )
    group by uid
    having length(event_chain) > 1
)
where event_chain[length(event_chain)].1 = 'buy' and has_midway_hit = 1
group by result_chain
order by user_countdesc
limit 20;
