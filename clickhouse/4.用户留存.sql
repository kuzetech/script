
select 
    sum(ret[1]) as orig_count,
    sum(ret[2]) as two_day_count,
    sum(ret[3]) as three_day_count,
    sum(ret[4]) as seven_day_count,
    round(two_day_count/orig_count*100, 3) as two_day_ratio, 
    round(three_day_count/orig_count*100, 3) as three_day_ratio, 
    round(seven_day_count/orig_count*100, 3) as seven_day_ratio
from (
    with toDate('2021-10-09') as first_date
    select
        pid,
        retention(
            toDate(dt) = first_date,
            toDate(dt) = first_date + interval 1 day,
            toDate(dt) = first_date + interval 2 day,
            toDate(dt) = first_date + interval 6 day
        ) as ret 
    from wide.login_steps
    where toDate(dt) >= first_date and toDate(dt) <= (first_date + interval 6 day)
    group by pid
);
