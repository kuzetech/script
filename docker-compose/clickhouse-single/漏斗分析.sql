
create table test_funnel (
    uid String,
    eventId String,
    eventTime UInt64
) engine = Memory;


insert into test_funnel values 
('A', 'login', 20200101),('A', 'view', 20200102),('A', 'buy', 20200103),
('B', 'login', 20200101),('B', 'view', 20200102),
('C', 'login', 20200101),('C', 'buy', 20200102),
('D', 'login', 20200101),('D', 'view', 20200103),('D', 'buy', 20200102);

insert into test_funnel values 
('D', 'login', 20200201),('D', 'view', 20200202),('D', 'buy', 20200203);


select 
    level,
    total,
    neighbor(total, -1) as last,
    if(last = 0, -999, round((total/last), 4)) as rate
from(
    SELECT
        level,
        count() AS total
    FROM
    (
        select
            uid,
            windowFunnel(2)(eventTime, eventId='login', eventId='view', eventId='buy') as level
        from test_funnel
        group by uid
    )
    GROUP BY level
    ORDER BY level ASC
);