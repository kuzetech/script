SELECT 
    o.order_id, 
    o.order_date, 
    o.product_id, 
    p.name as product_name, 
    p.description as product_description
FROM orders AS o
INNER JOIN product FOR SYSTEM_TIME AS OF o.proctime AS p 
ON o.product_id = p.id;