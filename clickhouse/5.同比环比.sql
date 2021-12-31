
select 
    month_start,
    total,
    neighbor(total, -1)  as pre_month_total,
    neighbor(total, -12) as pre_year_total,
    if(pre_month_total = 0, -999, round((total - pre_month_total)/pre_month_total, 4)) as over_month,
    if(pre_year_total = 0, -999, round((total - pre_year_total)/pre_year_total, 4)) as over_year
from (
    select toStartOfMonth(dt) as month_start, count(*) as total
    from wide.login_steps 
    group by month_start
    order by month_start asc
)
order by month_start desc;