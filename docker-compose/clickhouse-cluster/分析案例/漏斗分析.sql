
create table test_funnel (
    uid         String      COMMENT '用户ID',
    eventId     String      COMMENT '事件名称',
    eventTime   UInt64      COMMENT '事件时间'
) engine = Memory;


insert into test_funnel values 
('A', 'login', 20200101),('A', 'view', 20200102),('A', 'buy', 20200103),
('B', 'login', 20200101),('B', 'view', 20200102),
('C', 'login', 20200101),('C', 'buy', 20200102),
('D', 'login', 20200101),('D', 'view', 20200103),('D', 'buy', 20200102),
('D', 'login', 20200201),('D', 'view', 20200202),('D', 'buy', 20200203);


-- 求用户在 login - view - buy 路径下的漏斗分析
-- 事件的窗口为3，意味着路径的历时事件最长为3

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
            windowFunnel(3)(eventTime, eventId='login', eventId='view', eventId='buy') as level
        from test_funnel
        group by uid
    )
    GROUP BY level
    ORDER BY level ASC
);