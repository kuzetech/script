

with toDate('2021-10-12') as first_date
select 
    bitmapToArray(groupBitmapAndState(bitmapBuild(bm))) as result
from (
    with toDate('2021-10-12') as first_date
    select
        toDate(dt),
        groupArray(distinct pid) as bm
    from wide.login_steps
    where toDate(dt) >= first_date and toDate(dt) <= (first_date + interval 3 day)
    group by toDate(dt)
);

