

create table test_sequence_match (
    uid UInt64,
    eventId String,
    eventTime UInt64
) engine = Memory;


insert into test_sequence_match values
(1, 'login', 1), (1, 'view', 2), (1, 'view', 3), (1, 'buy', 4);

insert into test_sequence_match values
(2, 'login', 1), (2, 'view', 2), (2, 'buy', 3);

select 
    uid,
    sequenceMatch('(?1)(?t>=1)(?2).*(?3)')(
        eventTime,
        eventId = 'login',
        eventId = 'view',
        eventId = 'buy'
    ) as is_match 
from test_sequence_match
group by uid;


insert into test_sequence_match values
(3, 'login', 1), (3, 'view', 2), (3, 'login', 3), (3, 'view', 4), (3, 'buy', 5), (3, 'buy', 6);


select 
    uid,
    sequenceCount('(?1)(?2)(?3)')(
        eventTime,
        eventId = 'login',
        eventId = 'view',
        eventId = 'buy'
    ) as is_match 
from test_sequence_match
where uid = 3
group by uid;