RENAME TABLE 
  sausage.customer_all TO dm.customer_all,
  sausage.customer_local TO dm.customer_local,
  sausage.date_all TO dm.date_all,
  sausage.date_local TO dm.date_local,
  sausage.lineorder_all TO dm.lineorder_all,
  sausage.lineorder_flat_all TO dm.lineorder_flat_all,
  sausage.lineorder_flat_left_all TO dm.lineorder_flat_left_all,
  sausage.lineorder_flat_left_local TO dm.lineorder_flat_left_local,
  sausage.lineorder_flat_local TO dm.lineorder_flat_local,
  sausage.lineorder_local TO dm.lineorder_local,
  sausage.part_all TO dm.part_all,
  sausage.part_local TO dm.part_local,
  sausage.supplier_all TO dm.supplier_all,
  sausage.supplier_local TO dm.supplier_local
ON CLUSTER cluster3s

drop table dm.customer_all on cluster cluster3s;
drop table dm.date_all on cluster cluster3s;
drop table dm.lineorder_all on cluster cluster3s;
drop table dm.lineorder_flat_all on cluster cluster3s;
drop table dm.lineorder_flat_left_all on cluster cluster3s;
drop table dm.part_all on cluster cluster3s;
drop table dm.supplier_all on cluster cluster3s;