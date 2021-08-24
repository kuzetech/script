
SELECT 
  name, 
  total_rows, 
  formatReadableSize(total_bytes) as total_size 
FROM system.tables 
WHERE database='sausage';

SELECT 
  name, 
  value 
FROM system.settings 
WHERE name='join_algorithm';

SELECT 
  table, 
  partition_id, 
  name, 
  rows, 
  formatReadableSize(bytes_on_disk) as bytes_on_disk, 
  formatReadableSize(data_compressed_bytes) as data_compressed_bytes, 
  formatReadableSize(data_uncompressed_bytes) as data_uncompressed_bytes
FROM system.parts
WHERE database='dm' and table='customer_local';

select * from system.clusters where cluster='test';