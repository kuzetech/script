

create table test_retention (
    orderId         UInt32      COMMENT '订单ID',
    uid             String      COMMENT '用户ID',
    finishTime      date        COMMENT '订单完成时间'
) engine = Memory;

insert into test_retention values 
('1', 'A', '2020-01-01'),('2', 'A', '2020-01-02'),('3', 'A', '2020-01-03'),
('4', 'A', '2020-01-04'),('5', 'A', '2020-01-05'),('6', 'A', '2020-01-06'),
('7', 'B', '2020-01-01'),('8', 'B', '2020-01-02');


-- retention 函数可以方便的计算留存情况，该函数接受多个条件，以第一个条件的结算结果为基准
-- 观察后面的各个条件是否也满足，满足则为1，不满足则为0，最终返回0和1的数组。
-- 通过统计1的数量，即可计算出留存率

-- 下面的sql语句计算 次日重复下单率，三日重复下单率，七日重复下单率
select 
    sum(ret[1]) as original,
    sum(ret[2]) as two_day_ret,
    sum(ret[3]) as three_day_ret,
    sum(ret[4]) as seven_day_ret,
    round(two_day_ret/original*100, 3) as two_day_ratio, 
    round(three_day_ret/original*100, 3) as three_day_ratio, 
    round(seven_day_ret/original*100, 3) as seven_day_ratio
from (
    with toDate('2020-01-01') as first_date
    select
        uid,
        retention(
            finishTime = first_date,
            finishTime = first_date + interval 1 day,
            finishTime = first_date + interval 2 day,
            finishTime = first_date + interval 5 day
        ) as ret 
    from test_retention
    where finishTime >= first_date and finishTime <= (first_date + interval 5 day)
    group by uid
);
