SELECT name, total_rows, intDiv(total_bytes, 1048576) as total_size_MB
FROM system.tables
WHERE database='sausage'