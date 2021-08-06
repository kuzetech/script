SELECT * FROM system.clusters;
SELECT * FROM system.macros;

select * from settings where name like '%quorum%';

select * from settings where name = 'select_sequential_consistency';