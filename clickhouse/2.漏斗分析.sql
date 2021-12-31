
select 
    step_name,
    total,
    neighbor(total, -1) as last,
    if(last = 0, -999, round((total/last), 4)) as rate
from(
    SELECT
        step_name,
        count() AS total
    from wide.login_steps
    GROUP BY step_name
    ORDER BY total DESC
);