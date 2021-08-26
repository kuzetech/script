
create table topn (
    uid Int32,
    earn Int32
) ENGINE = Memory

insert into topn values 
(1,1),(1,2),(1,3),(1,4),
(2,1),(2,23),(2,16),(2,36);

select uid, topK(2)(earn)
from (
    select uid, earn 
    from topn 
    order by uid asc, earn desc
)
group by uid
order by uid asc;