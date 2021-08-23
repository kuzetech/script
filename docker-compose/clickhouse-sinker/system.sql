
SELECT 
  name, 
  total_rows, 
  intDiv(total_bytes, 1048576) as total_size_MB 
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
  intDiv(bytes_on_disk, 1048576) as bytes_on_disk_MB, 
  intDiv(data_compressed_bytes, 1048576) as data_compressed_bytes_MB, 
  intDiv(data_uncompressed_bytes, 1048576) as data_uncompressed_bytes_MB
FROM system.parts
WHERE database='dm' and table='customer_local';